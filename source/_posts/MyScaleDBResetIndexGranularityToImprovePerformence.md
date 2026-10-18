---
title: 通过修改 IndexGranularity 提升 MyScaleDB 的搜索性能
date: 2024-04-30 19:10:25
tags:
  - MyScaleDB
  - clickhouse
  - IndexGranularity
  - VectorSearch
  - MSTG
---
![MyScaleDB](/images/myscaledb-logo-with-text.png)

MyScaleDB 是基于 ClickHouse 开发的的分布式向量数据库，支持结构化数据以及非结构化数据的存储,查询，其支持 SQL 语句查询的特点，极大地简化了开发人员的开发工程量，提升了工作效率。笔者使用 MyScaleDB 进行非结构化数据（向量数据）的高精度搜索服务，在使用过程中，发现特定业务下因索引粒度设置不合理，导致查询效率低下的问题，本文将介绍如何调整索引粒度，提升查询效率。

<!-- more -->

**********

## 问题描述

笔者开发的系统，需要利用 embedding 向量数据进行近似搜索，获取到 TopK 的候选结果之后，还需要进行精确的搜索，进而返回最终明确的答案给用户。

### 硬件平台简介

简单介绍一下部署 MyScaleDB 的硬件资源：

+ CPU: Intel Gold 6230 CPU, 限制使用 32 Core;
+ 内存: 256GB DDR4
+ 存储: 1TB Intel SSD，顺序读取性能大约在 400MB/s;

### 整体表结构及数据情况

整体的表结构如下所示：

```sql
------------------------------------------------------------------------------ 
-- Create database
------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS test_table;

------------------------------------------------------------------------------ 
-- Create tables
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS test_table.global_embedding (
    id Int64,
    birthday Nullable(Date),
    data  Array(Float32),
    template String,
    CONSTRAINT check_length CHECK length(data) = 256,
    PRIMARY KEY(id)
) ENGINE = MergeTree();

------------------------------------------------------------------------------ 
-- Create Vector Index
------------------------------------------------------------------------------
ALTER TABLE test_table.global_embedding ADD VECTOR INDEX float_embedding data TYPE MSTG('metric_type = Cosine');
```

其中:

+ `data` 为 256 维的 embedding 向量,需要进行向量的近似搜索；
+ `template`是一个经过压缩的二进制数据，里面存放了二次经筛依赖的数据，大小在 17KB 左右；
+ **global_embedding** 表拥有6770万行数据；
+ 查询的 SQL 语句: `select id,template,distance(data, ?) AS dist from test_table.global_embedding order by dist limit 10`
  + 其中 *?* 输入的是查询的向量数据，limit 10 中的数字10，可根据测试需要调整，后文将直接通过 topK 声明；

### 优化前的性能表现

+ topK 实用默认值10，单次搜索的时延为 1000ms；
  + 5并发，任务时延>16s；
  + 获取template数据 100ms；
+ topK 设置为 3 之后， 单搜速度为 300~400 ms
  + CPU 使用率不高，只有不到百分之三十资源使用率，看磁盘占用已经 100%， 400M/s

## 问题分析

初步分析瓶颈应该在存储的读取性能上，作者尝试从这个角度分析问题所在。

+ 通过向量搜索，获取 topK 的候选行；
  + MyScaleDB/ClickHouse 使用稀疏索引来加速数据查找；
+ MyScaleDB/ClickHouse 使用列存储，这意味着同一列的所有数据值都存储在一起，这有助于提高压缩率和查询效率，特别是当查询只涉及表的少数几个列时;
+ MyScaleDB/ClickHouse 会使用索引来快速定位到包含查询条件的数据块。index_granularity 影响查询的效率，因为它决定了查询需要扫描的数据块的数量;
+ index_granularity 为默认值 8192，对于`test_table.global_embedding`表，每个数据块的大小为：
  + 8192 * 17KB = 139264KB = 136MB
+ 假设 topK 为 10，那么需要获取 10 个数据块，单次搜索获取 Top10 需要读取 1360MB 的数据，意味着需要大约4s，才能遍历完数据命中具体的行；
+ 假设 topK 为 3，单次搜索获取 Top3 需要读取 3 个数据块大约 408MB 的数据，基本占满 SSD 存储的理论最大顺序读性能，符合我们实际的观测值；

> index_granularity 决定了命中数据块之后精确获取对应数据的性能，调整他的大小可以减少数据块的大小，从而提高吞吐性能。

## 解决方案

通过重新建表，调整 index_granularity 大小，减小索引对应数据块的大小，减少对存储 I/O 的资源占用。

```sql
------------------------------------------------------------------------------ 
-- Create tables
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS test_table.global_embedding (
    id Int64,
    birthday Nullable(Date),
    data  Array(Float32),
    template String,
    CONSTRAINT check_length CHECK length(data) = 256,
    PRIMARY KEY(id)
) ENGINE = MergeTree()
SETTINGS index_granularity = 128;
```

index_granularity 改成 128，索引对应的数据块大小在 128 * 17KB = 2176KB = 2.125MB, 大幅减少对存储 I/O 压力，实际性能表现也如我们的预期:

+ 10并发取 top5,, CPU 占用已从 600% 拉满到 3200%, 存储I/O占用在 50%;
+ 10并发取 top10, CPU 占用 2200%，存储 I/O 已经到瓶颈（ssd 情况下）;

## Reference

+ [MyScale 超越专用向量数据库](https://myscale.com/blog/zh/myscale-outperform-specialized-vectordb/)
+ [MyScaleDB - 开源 SQL 向量数据库用于多模态数据管理](https://myscale.com/blog/zh/myscaledb-open-source-announcement/)