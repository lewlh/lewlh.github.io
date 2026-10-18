---
title: x99 平台组装记录
date: 2024-10-16 10:00:00
tags:
    - x99
    - E5
    - RX580
    - 华南金牌
---

笔者手里有闲置的 DDR4 ECC 内存条，以及两块大容量的 SAS 硬盘，最近突发奇想打算组装一台 x99 平台的 NAS,用于家庭影音娱乐、相片视频数据的备份以及轻量的 DevOps。本文记录一下硬件选购的分析过程以及组装的过程。

![鲁大师跑分](/images/202501/鲁大师_核心硬件评测.png)

<!-- more -->

**********

## x99 主板分析

E5 洋垃圾 CPU 本身并不贵，组装成本的大头在主板以及内存，其他的配件基本上用啥平台成本都差不多。x99 主板主要就是华南金牌、精粤这两个品牌，综合网上的评论我觉得华南金牌的主板可能更适合我一些，因此搜集了这个品牌在售的几款主板作为比较：

| 主板型号 | 芯片组 | 内存支持 | 内存标准 | PCI-E | 扩展接口 | 备注信息 | 黑苹果 | 价格 |
| ------- | ------ | ------ | ------------------ | ---------------- | -------------- | ---- | ---- | ---- |
| 华南金牌 X99-F8 | IntelC612 | DDR4/DDR4 ECC | 支持四通道 DDR4 2400/2133/1866MHz，最大支持 256GB | 2 个 PCIExpress3.0x16 插槽，1 个 PCIExpress3.0x4 插槽，2 个 PCIExpress3.0x1 插槽 | 1 个 M.2 2280NVME PCIEX4 3.032Gbps，1 个 M.2 2280 NVME PCIEX4 2.0 20Gbps，1 个 M.2 WIFI （NGFF 协议）接口 | [产品规格](http://www.huananzhi.com/more.php?lm=10&id=305) | [Hackintosh, Huananzhi F8 Gaming](https://github.com/luchina-gabriel/EFI-HUANANZHI-F8-GAMING-INTEL-XEON-E5-2699-V4-RX-570-8x32Gb-256GB-RAM-PUBLIC) | 2024年10月新主板[581](https://item.taobao.com/item.htm?id=584879880832&pisk=f5Nkzm1K-mts1hxo5tc5KTJ6WhWxP3GIxkdKvXnF3moXwkh-9jJq-4xeT2Ry3-4_x0QCFbemxorm4k4CP2oUYkmLetCTPzGITGEh61U5TZNVokDyTqo4l2OeLTLJcnhITGIhrJtiPXZsxEjI-x7mJ2deakky3moj-4uUY0k202gITDJQpsRQfpNWrjnM2ND90ejYSczr4zU8gUkJFro0RyVxrrDUzwOeTS0oEWCw1_5ET8z8mAeljQ2QzRZI7u-PqqVuSW2a0wREx-yZIRrd8dmQkRDUBx-l4GJ2QKZBOq7Lgp9IUqgmXmWNcnzjuC1foZxulYujWhQcopT-UqgmEZbDqRkrlVI1.&scene=taobao_shop&skuId=5155043328483&spm=a1z10.1-c-s.w17522917-24950991782.5.7e46768eluySuB)，闲鱼二手300 |
| 华南金牌 X99-TF | IntelC612 | 4 个 DDR3+4 个 DDR4 内存插槽，支持服务器内存 | 支持四通道 DDR3 1866/1600/1333MHz 规格内存，DDR4 2400/2133/1866MHz 规格内存，D3/D4 分别最大支持 128GB，不支持 D3/D4 同时使用（DDR3 内存需搭配支持志强 E5-2629 v3/ E5-2649 v3/E5-2669 v3/E5-2673 v3/ E5-2676 v3/E5-2678 v3/E5-2696 v3/E5-2666 v3/E5-2686v4/E5-2696v4） | 2 个 PCIExpress3.0x16 插槽，1 个 PCIExpress3.0x4 插槽，2 个 PCIExpress2.0x1 插槽 | 1 个 M.2 2280 NVME PCIEX43.0 32Gbps，1 个 M.2 2280NVME PCIEX42.0 20Gbps，1 个 M.2WIFI（NGFF 协议）| [产品规格](http://www.huananzhi.com/more.php?lm=10&id=306) | [HUANNA-X99TF-OC-9.1-EFI](https://github.com/KGDJudy/HUANNA-X99TF-OC-9.1-EFI?tab=readme-ov-file) | 2024年10月新主板[582](https://item.taobao.com/item.htm?id=584879880832&pisk=f5Nkzm1K-mts1hxo5tc5KTJ6WhWxP3GIxkdKvXnF3moXwkh-9jJq-4xeT2Ry3-4_x0QCFbemxorm4k4CP2oUYkmLetCTPzGITGEh61U5TZNVokDyTqo4l2OeLTLJcnhITGIhrJtiPXZsxEjI-x7mJ2deakky3moj-4uUY0k202gITDJQpsRQfpNWrjnM2ND90ejYSczr4zU8gUkJFro0RyVxrrDUzwOeTS0oEWCw1_5ET8z8mAeljQ2QzRZI7u-PqqVuSW2a0wREx-yZIRrd8dmQkRDUBx-l4GJ2QKZBOq7Lgp9IUqgmXmWNcnzjuC1foZxulYujWhQcopT-UqgmEZbDqRkrlVI1.&scene=taobao_shop&skuId=5155043328482&spm=a1z10.1-c-s.w17522917-24950991782.5.7e46768eluySuB) |
| 华南金牌 X99-BD4 | Intel B/H/Q/Z | DDR4/DDR4 ECC | 支持四通道 DDR4 2400/2133/1866MHz 规格内存，最大支持 128GB | 2 个 PCIExpress3.0x16 插槽，1 个 PCIExpress3.0x4 插槽，1 个 PCIExpress2.0x1 插槽 | 1 个 M.2 22110NVME PCIEX4 3.032Gbps，1 个 M.2 2280 NGFF SATA3.06Gbps (使用时会占用一个 SATA3.0 接口信号) |[产品规格](http://www.huananzhi.com/more.php?lm=10&id=314) | 无 | T |
| 华南金牌 X99-PD4 | Intel P55/H55 | DDR4/DDR4 ECC | 支持双通道 DDR4 2400/2133/1866MHz 规格内存（视 CPU 而定）最大支持 128GB | 2 个 PCI Express3.0 x16 插槽，1 个 PCI Express2.0 x1 插槽 | 2 个 M.2 2280 NVME PCIE X4 3.0 32Gbps | [产品规格](http://www.huananzhi.com/more.php?lm=10&id=869) | 无 | 2024年10月新主板274 |
| 华南金牌 X99-PD3 | Intel P55/H55 | DDR3/DDR3 ECC | 支持双通道 DDR3 1866/1600/1333MHz 规格内存（视 CPU 而定）最大支持 128GB | 2 个 PCI Express3.0 x16 插槽，1 个 PCI Express2.0 x1 插槽 | 2 个 M.2 2280 NVME PCIE X4 3.0 32Gbps | [产品规格](http://www.huananzhi.com/more.php?lm=10&id=870) | 无 | 2024年10月新主板[278](https://item.taobao.com/item.htm?from=cart&id=752134934675&pisk=greSeAtbLye47JOz69Iq1dagNNkQVy6NdHiLjkpyvYH-RvZQXXpFZYlIdr34U4rre2MQAlhL82ryqS4aXLyPZvJIEvDd7NWNQ3qoKvCNSOwMqxnIXBBEvQdYqzuA1KXNQuqX40IaDOyz4eSqXBpLJbhxkcgx20h-yiMxAckpeXpJME3mvvHKw4hvMcnWeBh8JEpxAD9JpQ3-DIntfvn8JvKddBi9NDq5m7CGJsQG4u0XppejDw0aVN9Sb-m5nVqSlNQuhdcSWu3XpNkAjbuxf-QHz22bD8FgktJSdonQ5YFfkLaQ2zNt68BfDyZaPJGaztI8-YnL-f2FSL08vl2g_A6BAmN_DxsP2du_4VRBcfvIcVSfcBAhFOqIljFlCPc-m0jPciTxtbnmcmjfcBfKwmml5isXkW5..&skuId=5187231545850&spm=a1z0d.6639537%2F202410.item.d752134934675.5bfb7484eMt9qh) |

芯片组性能差异差异:

+ [H81](https://www.intel.cn/content/www/cn/zh/products/sku/75016/intel-h81-chipset/specifications.html?wapkw=H81)
+ [B85](https://www.intel.cn/content/www/cn/zh/products/sku/75019/intel-b85-chipset/specifications.html?wapkw=B85)
+ [Q85](https://www.intel.cn/content/www/cn/zh/products/sku/75010/intel-q85-chipset/specifications.html?wapkw=Q85)
+ [Q87]
+ [H87](https://www.intel.cn/content/www/cn/zh/products/sku/75004/intel-h87-chipset/specifications.html?wapkw=H87)
+ [Z87](https://www.intel.cn/content/www/cn/zh/products/sku/75013/intel-z87-chipset/specifications.html?wapkw=Z87)
+ [IntelC612](https://www.intel.cn/content/www/cn/zh/products/sku/81759/intel-c612-chipset/specifications.html)

以下是我选择主板的依据：

+ 我想要尝试黑苹果，因此最好网上有成功安装系统案例的主板；
+ 因为 E5 CPU 没有集成显卡，需要安装独立显卡；SAS 硬盘我需要单独买一个直通卡连接；另外我还需要安装无线网卡，因此 PCI-E 的插槽需要足够,且通道数需要足够，不要影响性能；
+ 尽可能地减低内存的成本，一是尝试先尝试闲置的 DDR4 ECC 内存是否可用，如不可用，再购买内存;
+ 需要支持安装 NVMe 存储;
+ 主板+处理器的成本需要控制在400元以内；

最终，我把目标定在华南金牌 X99-TF 这款主板。它支持 DDR3/DDR4 内存，且可以使用 ECC 的服务器内存，便宜量大，另外这款主板有足够的 PCI-E 接口，满足我的需要。我计划在闲鱼上蹲一套二手的主板。

## E5 CPU 分析

在我开始看 E5 处理器的这段时间，它的价格已经下来不少了，极具性价比。这些“洋垃圾”物理核足够多，就是单核性能由于架构的原因已经比十年后的处理器差不少了，在同代架构 CPU 里面只能尽量找主频足够高的型号。比较下来，我选择了 E5-2666 v3 这款处理器。对我而言，他的优点足够突出：

+ 足够便宜，淘宝二手才卖40元左右；
+ 在同代架构的型号里面，他的单核主频很高，达到 3.5GHz；
+ 它支持 DDR3/DDR4 ECC 内存，可以进一步压低整套机器的成本；
+ 由于是 v3，因此它可以打鸡血，将全核睿频拉到 3.5GHz，性能还能进一步提升；

| CPU型号 | 物理内核 | 内存 | TDP |基础频率 | 最高睿频息 | 全核睿频 | Single Thread Rating | Multithread Rating | 超频/鸡血 | 价格(2024Q4) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| E5-2696 v4 | 22 | DDR3/DDR4 | 150W | 2.2GHz | 3.6GHz | - | [2141](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2696+v4+%40+2.20GHz&id=2750) | 24858 |  | [1070](https://item.taobao.com/item.htm?id=684315543698&ns=1&pisk=gRCoh3Np-ni_fsMXArR7K8WYVE2YF4OBFMhpvBKU3n-jwp-LFMvhvi9FwQQRmHSOxeCR96XjtN_CwzOLPQ_WOBrTX5ChPaOQtMyn6_VVueQqLU8z6uQy94ZTX5F3UqR3qlIJt5bigFYwTUJeLKzDJeDy8MJEgZ-XReoy8bzcunt28UlrUjo2PeorTM8EuE8e-YkyY3k4gUt2zBRevgowYBJ1guNnthayk87MrLxNz37RlsywFY_WmOB1gUbDbakITX5DrL5prrJDIBWPyivOElclvaW1AFSr4uYcZNfhQizETHXVQdXNvykMAZBMLOpqqoKdBZCynGrxiM9hUORPtlVV4bDqQxsIOEzdgvMBUETDXnyacm5AiaH3ormllL8XWcU0ovgJUETDEr4mqOJylFE1.&priceTId=2147bf7a17291429373481956e1c73&skuId=5210221214661&spm=a21n57.1.item.46.d636523cq8J3kt&utparam=%7B%22aplus_abtest%22%3A%22911c7f73b69d7598b21ce770bb50a673%22%7D&xxc=ad_ztc) |
| ***Core i9-10900K*** | 10 | DDR4 | 125W | 3.7GHz | 5.3GHz | - | [3127](https://www.cpubenchmark.net/cpu.php?id=3730&cpu=Intel+Core+i9-10900K+%40+3.70GHz) | 22732 | | |
| E5-2696 v3 | 18 | DDR3/DDR4 | 145W | 2.3GHz | 3.6GHz | - | [2097](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2696+v3+%40+2.30GHz&id=2526) | 22140 |  | [230](https://item.taobao.com/item.htm?id=681385672976&ns=1&pisk=gGajhPA77RUz-Dt4vNCrAetbUMu_lR_ehCGTt5L26q3xBuN3Cx5GmqrSC8eSHE5cmcH_nqng0AkqCVNgd_WF8wP0iV0AL97F0QZ2i2v9XApZw3hEWZ6P4LP0iVD9adIU2SvsjgNXDfHON4hs_f3tDmF8wYc6HKetH0p-OX0tBRet24hKGnpvWVp-wYceBjHvWUK-9fRvHfety_GMjLts9nGgG_qANcWJ_bFxFFLTkNmxdYxw5FixMmaTMYNzazGjcvizel_8RWFY-faG9hMsYoeqZR_CF4UbhrnS5NOsNkN8hrg1rQDYxuyYyVA6DqrUTPmLkZ9nUDc_dqE5eEwd4ETEdSkefQiH5bMFN_tMjZ_31Y9cctKxDbccg_1WecmxZbGlN_tGXmhoi915NLEN.&priceTId=2150419417291420199071521e1cd6&skuId=5138264018017&spm=a21n57.1.item.1.d636523cq8J3kt&utparam=%7B%22aplus_abtest%22%3A%226fde380599a1b3bff4d0c7b34422ccb4%22%7D&xxc=ad_ztc) |
| E5-2686 v4 | 18 | DDR3/DDR4 | 145W | 2.3GHz | 3.0GHz | - | [1801](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2686+v4+%40+2.30GHz&id=2870) | 20261 | | |
| E5-2680 V3 | 12 | DDR4 1600/1866/2133 | 120W | 2.5GHz | 3.3GHz | - | [1805](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2680+v3+%40+2.50GHz&id=2390) | 15144 |  | [35](https://item.taobao.com/item.htm?from=cart&id=587618923418&pisk=gz0rKCxSIyDfXa8_GSUU_OPfa-z85zv1L2wQtXc3N82ke3E3t-lMw8tp2voqKxE7E2ld8WcnpQeBwnG-wyUHCdge5bh-INxlF2rumZVnigbh-FZDH1_HCdT683f08LJsFy-2FZVasyVux8jDgWNUZ7D3qrc0HWFhEWbkgj2YnWj3Z8Vcn7F1KaD3ZsX0_WWhZk2uirV8n743-HNZmD84huA1KgjVGtmg4Rcu3Nlxo7baCFec-luYZuunZ-ojcqPz4Rqjnqgq7fcoWWupsMyUf0D7Mv8w3r0rU4q48e5UgclmU4zekseoXmMooyCFqzis12EirUWThlFEQzm2nakG4n6Li_GSJ0WhYuVYgRO2gvZ-j5xmLEERvMEXpSy61fsdvu2_gRO2RMILcIV4CCNO.&skuId=4958628425221&spm=a1z0d.6639537%2F202410.item.d587618923418.61c67484kouDjY)|
| E5-2678 v3 | 12 | DDR3/DDR4 | 120W | 2.5GHz | 3.1GHz | - | [1761](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2678+v3+%40+2.50GHz&id=2584) | 14726 | | |
| E5-2676 V3 | 12 | DDR3/DDR4 | 120W | 2.4GHz | 3.0GHz | - | [1636](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2676+v3+%40+2.40GHz&id=2643) | 13524 |  | [42](https://item.taobao.com/item.htm?from=cart&id=587618923418&pisk=gaorK1YSskcfW3-_h-EUQ1yfUSr8juA1TDNQKvD3F7VkwUU3KSkMe7TpyXuqtjU7ZDkdYJDn9LFBeEM-ekEH1CiefYH-sGYlNDzuor2InwblrhaDMOsH1Ct6YUX0YQRsNk8N5i2aIk2u-7bD3JwUE8c3ro40MJehZJjk3xVYiJb3E72ci8e1tgc3Etf0QJ5hEyVuno28iJq3xHHZo2-4Gzv1tabVhZS7A5DugMjNB8akpx_CjGX_FzNgoSS3lmyzz5Do2HrxcJuibzhMGaNo7RGaCbtc4fkoaV4iqsA430kZYRzciBeqoAhLIz5fkfDjC0UxYC5094wTm8u2KZVu-gof9-XSFD3PtwzuH-P63KlQyV2MoX-YywQLlBe41dM1JwUu1-P63H_dJr90359_B&skuId=4958628425219&spm=a1z0d.6639537%2F202410.item.d587618923418.61c67484kouDjY) |
| E5-2673 V3 | 12 | DDR3/DDR4 | 110W | 2.4GHz | 3.1GHz | - | [1739](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2673+v3+%40+2.40GHz&id=2606) | 14219 |  | [42](https://item.taobao.com/item.htm?from=cart&id=587618923418&pisk=gLmip3tYnW15FEbQGpr6oF7pSCYp5OZb7jIYMoF28WPIXdaYM22qMX9XClH4ijcLOj4XCSF4ijHqWpKJ2AM_colDw3KRi8wKFfXN7GJV88ekw-l_pYM_coRcpi8JqAGzuDy3Q-yeK-eAb1l47vWUCWyaQ-l4Tyyze1r40jJ3882lbiSN0wWU3W7NgGy4Y9yTHGS47iJ3YWw2vuCzgozSYCtcobqKqslTIPVrQ5ktdD7UlNMQtza-YRD3aAWf0io3IPmYIIsffouZBX4-SQjiMAuSG8lN_C2njYmmzXJV0S0Ezz0rMK7uGv3uu4UFsBFxyvna-bRdxjam74rZmQxF4dbFzwGfcJJxYZ_b7Jw3wW8yO6JiQk9vKpfidPyQe_pHKZ6T7Jw3Spvhs4zad8d5.&skuId=4958628425218&spm=a1z0d.6639537%2F202410.item.d587618923418.61c67484kouDjY) |
| E5-2669 v3 | 12 | DDR3/DDR4 | 120W | 2.3GHz | 2.6GHz | - | [1502](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2669+v3+%40+2.30GHz&id=2700) | 16107 | | |
| ***AMD Ryzen 5 4600H*** | 6 | DDR4 | 45W | 3.0GHz | 4.0GHz | - | [2434](https://www.cpubenchmark.net/cpu.php?cpu=AMD+Ryzen+5+4600H&id=3708) | 14416 | | |
| ***Core i7-10870H*** | 8 | DDR4 | 45W | 2.2GHz | 5.0GHz | - | [2662](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i7-10870H+%40+2.20GHz&id=3856) | 14360 | | |
| **E5-2666 V3** | 10 | DDR3/DDR4 最高2133 | 135W | 2.9GHz | 3.5GHz | 3.2GHz | [1969](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2666+v3+%40+2.90GHz&id=2471) | 14277 | 全核3.5GHz  | [41](https://item.taobao.com/item.htm?from=cart&id=587618923418&pisk=gLXxKKG87unxuPorQVNkscmHwtZlWOIqmZSIIFYm1aQR5NKiIGTMBNQOWEA_uKXOyKWliAY0udI1-dU3-J2h0iJ2Cy4hny6S5K-9fxtjS4gWxdt6332C0iJw500_t_sqWCzILjt65upWXhuXCI9sV0TyXngf5EOSPHKeCF_15QGWxhkslAtsVUTyvVgXfIi7FhKZCnM15LZJbHI4pEEXmACZ9Y9BLJcimmXJDILtIEkOFOkH6eG6rAH9kndxmiT-CA6Rasac0ee-PUj1Y1ORB4zkQgfdW1_7fATONHQph_USHd9XvZJfhz0vBLKe91Q0zATc9g_JtT0oKL6AktOJdg-lK9Lb42YpjjZ82flwG3z7ZcncjrT0u3L30elZ_Coy2eq8RflwGdtJ-o-j_fRaq&skuId=5096242036805&spm=a1z0d.6639537%2F202410.item.d587618923418.61c67484kouDjY) |
| ***Core i3-12100E*** | 4 | DDR4 | 60W | 3.2GHz | 4.2GHz | - | [3481](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i3-12100E&id=5576) | 14250 | | |
| ***Apple M1 8 Core*** | 8 | DDR4 | 15.1W | 3.2/2.1GHz | - | - | [3685](https://www.cpubenchmark.net/cpu.php?cpu=Apple+M1+8+Core+3200+MHz&id=4104) | 14152 | | |
| E5-2649 v3 | 10 | DDR3/DDR4 | 105W | 2.3GHz | 3.0GHz | - | [1674](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2649+v3+%40+2.30GHz&id=3194) | 12399 | | |
| E5-2629 v3 | 8 | DDR3/DDR4 | 85W | 2.4GHz | 2.6GHz | - | [1426](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E5-2629+v3+%40+2.40GHz&id=2867) | 9139 | | |

## 显卡

随着挖矿、人工智能等需求的爆发式发展，最近几年消费级的 GPU 迭代明显变慢，黄仁勋、苏姿丰精准的刀法导致新品、二手卡的价格非常坚挺甚至上涨，苦了我们这些普通消费者。了解完整体的行情，我也给自己定了几点需求：

+ 价格足够低，因此只能买二手卡了；
+ 自己想试用一下黑苹果，因此只能选择 AMD 的显卡了；
+ 从大学毕业之后，我就没怎么玩过游戏，因此想买一张畅玩 1080p 的显卡，也给自己一个放松的机会；
+ 希望这个显卡能跑一下人工智能的应用，在家里跑一下模型推理；

这些需求综合下来，只有多朝矿渣 AMD RX580 系列显卡了，因为这是我见过的，最接近我想要的显卡，而且价格也还可以接受。2024Q4 我在找淘宝、京东、闲鱼、拼多多电商平台 RX580 显卡，看看去哪里买，总体有以下几点值得一说:

+ 或许是由于首个国产3A大作《黑神话·悟空》带火了装机市场，整体二手显卡的价格比2023年都上涨了，RX580 系列的显卡价格，比之前上涨了接近 100 元，来到 380~400 元的价格区间；
+ 以卡诺基为代表的翻新卡，基本上都只销售残血版本的 RX580 2048SP，且散热风扇都是恒速转动的(少部分不是);
+ 以卡诺基为代表的翻新卡，基本上都会降频，跑分会比普通的二手卡低;
+ 卡诺基为代表的翻新卡，以及淘宝的二手卡，都声称提供二年的质保;
+ 如果要安装黑苹果，那么似乎只有 RX580 8GB 2304SP 版本的显卡是免驱的，其他型号的好像需要刷 BIOS 或者是改驱动，会比较麻烦；

后来我选择在淘宝二手显卡店家“非凡电脑显卡”购买了一张二手显卡，用了一个月后显卡就掉驱动黑屏无法使用，不过店家也给我换了一张卡，这个后文展开说。

## 最后的主机配置

最后，我在闲鱼、淘宝和京东，凑齐了整机，配置如下：

| 配件类型 | 型号 | 购买渠道 | 价格(2024Q4) | 说明 |
| :---: | :---: | :---: | :---: | :---: |
| 主板 | 华南金牌 X99-TF | 闲鱼 | 340 | 此价格包括CPU+散热器+顺丰邮费 |
| CPU | E5-2666 V3 | 闲鱼 | - | - |
| CPU散热器 | 四热管+双利民风扇 | 闲鱼 | - | - |
| 内存 | SAMSUNG DDR3 ECC 1866HZ  32G | [淘宝](https://item.taobao.com/item.htm?_u=n8646pv367d&id=13978621463&spm=a1z09.2.0.0.661b2e8dAESMVA&skuId=5121897329385) | 55 | 主板到了之后尝试使用DDR4 ECC 64GB 的内存，但是主板不识别。后来就决定买DDR3 ECC服务器的内存，带散热马甲,后续又买了两条同型号内存。 |
| 显卡 | [GIGABYTE Radeon™ RX 580 GAMING 8G](https://www.gigabyte.com/tw/Graphics-Card/GV-RX580GAMING-8GD-rev-10-11-12#kf) | [淘宝](https://item.taobao.com/item.htm?_u=n8646pvbd9e&id=700266366619&pisk=gtwz1Lf7Sv4jUYyP-mDe3c6Ls9H-LYb1-JgIxkqnV40l906HLkriAgQd2So3RrId2YZn8yzjkpiCwwpUuzZgNbaQN2mnorqWF26-Tyr_Wy9Ce7iHLrZKtywUvpo3xyI-RgCb2uHKKN__LOZ825NAsWwrqqX0D0AH-sGkatr5cN_1C95kmv7P5zN7YkTmbcDnqXmomioIxL03-bXDmqnKxUmHEirmkqAHED03mqm-4UDHEvqmico6EBmnxxXmkDkHEX43mhVYiWWqlbjOF-zWJayraVqoudrYn04BwuuV2gw4g0uiCqJHK-ozcqjflLXZo7N3Fx2lo9H0XSao0AWeYmPamYmzgMAmrl0oEcFV7LH7bqk7UAX9r2NbbJoUpwB47u4zsf2kzgzpJmx7VJFy-BloDmu10ikgaJ1VEJ42KBdKGwnq5GZ69Bho5mu109Op9jsm0VsoY&spm=a1z09.2.0.0.661b2e8dAESMVA&sku_properties=30308%3A41420) | 386 | 这个卡用一个月后就坏了，我自费寄回给店家，店家发了一张讯景 [XFX GTS RX580 XXX 8GB 2304SP](https://www.techpowerup.com/gpu-specs/xfx-gts-rx-580-xxx-8-gb.b4480) 替换 |
| NVMe | 芯点子C700 1TB | [京东](https://item.jd.com/10121823829508.html) | 347 | 希捷联名，酷玩530平替,双十一送散热马甲 |
| HDD | SEAGATE SAS 16TB * 2 | - | - | 测试发现，一块硬盘有严重坏道，另外一个硬盘有部分坏道，前者基本不可用，后者可以放一下不那么重要的资料，如电影 |
| SAS直通卡 | 浪潮2308 6G直通卡IT模式 | [淘宝](https://item.taobao.com/item.htm?_u=n8646pve6e7&id=772642815737&pisk=gJ971SqXLep4opUDq4nVl1-I1YWQdeMZpkspjHezvTBROJKy5MyFTbjQdZttqalnZeOXJEfPyw5FdMTNo3yEq3oIdHKOy9RPzML2REVyzp7euvtM5_yyvprkiF-TULllLJ6lK93Z7Akaq3Xhp70uXD4uMMs-LuedJTXY7aZr6AkwqnZP2c-xQLkC4nsg9JLdwseAbZIRJJI-csINv9eR98FYkZjdp9IdySIAxM4L28LLkrICbJILp_eYkMIGpgLdy-nfxHqLOGF5x3iVYBzivJzC5ZwLpKsx-w-Sg8S6EgZG53_jWN9VVFb92ZwLpaSQiVxpJ2wFBCYXd1BEd-XyfIBAVIiLMaC6wCBJdVaJD1Ow6s9nI8x5saBfmpu0ewOv9L5lKz35cLt6dBsrbR764NPQc12CcNojcWVnrLTiBTLV-t5RmgmrcmaAt_IccimjcWchwijo5mibPvf..&skuId=5391221020198&spm=a1z09.2.0.0.661b2e8dAESMVA) | 47 |  |
| SAS连接线 | 6G线 8087转1分4 SAS/SATA转接线（0.7m）大4pin供电 | [淘宝](https://item.taobao.com/item.htm?_u=n8646pve6e7&id=772642815737&pisk=g44U1qjQn42_JBaFEf0y7j_8ma3KF2XfEzMSZ7VoOvDh2X_kz7PmN6BR9lluFRCR92NoU8ysBUG5vTLzQJN0ADw7AYcoIRVBRY_K48PbH8T5JkGkzRN-q8azwUluZ8CKF6I_9W3-rt6bzZNL9oZOmuarZhVg6blH-UjsSHkQTiXflZNNxX37staQAe_-gjTorDmkSFDtaYvot8mMSbHM-bYnZdfZwA0kqvcos5cotBv3EevijjlmZLmntdDiiAcnr42usHYQju7ZCDfARPyBe6TUixVnQUY2MvnHq8xW7F5ZtDHmjOYJybhEYxVnQtBOJ6izLDz18KhUjSuKT8QvJ2mzxo03zt7ESyyU-cykahu7854I68RDA5mufynYROYEooFIRu2GZUDzjbjzWLhMOWa8YLxrxfhZh15Zokz5bw4uQUxJ2c6-_x1bG3K-xxGZh1Rw23n1sfkf9wC..&skuId=5484848971126&spm=a1z09.2.0.0.661b2e8dAESMVA) | 41 |  |
| 无线网卡 | BCM943602CS_3天线 | [淘宝](https://item.taobao.com/item.htm?_u=n8646pva809&id=569121658326&pisk=geb41cZfKFXWY6_4IQYZzBaOxPLvbE2QIN96s1fMGKv0XIai715H1SeTMgRGCTFTME1MQOWWeVO_DR3NUt1hcn61cdAMETfjldavbO5CpOg_kiOi7T19jO_N6VRGsOFvCSE5MsL9SJwC7y1AMMs8xG_2sLYlwI0ioutm0z5bNJwQRPrmZFy4dtsXQFDkTBYMihAmr7R6sAmcIh0lZLd9sxAio75keLmioCvGZLAvgxYMiC4krCRZjm0Mn3mkeC8imKXGZHXOqGzyFnVLlaWjBXmf8pfDUV0E9QxmQ1ms82oHinvHqf3s5Cd20pfDUJe8kStN3n77uvdVq68vgOUKkExNmMYc7Jz2rZWVo3Wi_081u_bXwOlnc_xGVZKdl802-MCXlGXusVvNqCjP6AdoGs_O0AmwmQdyd7Py-i7_4rbGUVmtX3w9apNCOcn9mpOyd7lrXcK7ZQJQMrC..&skuId=4369136840865&spm=a1z09.2.0.0.661b2e8dAESMVA) | 87 | 2.4G 450Mbps/5G 1300Mbps/蓝牙4.0/支持黑苹果 |
| 电源 | 驿晨宇 玄武550v4| [淘宝](https://item.taobao.com/item.htm?_u=n8646pvd6a6&id=700692686188&pisk=goTu1agdttw_BtJTeK7SYWHB_nmvP7_B8pUdpwBE0tWjOuE-NM5etpYp2BWd-pvHKTIEFaLHnCOKNeh5z2feBKbpwTBpnXvJOyHSAaUUKLOZFQBKNeXFnLJhAb6dL9vpT3hxWVdWNw_eKA3tWrpxidpu46rrTs5NsjCrG3uebw_EBvqY8ggGRdORK2zz0sWft6rPap72g_1G865P8jXVt1ZUUp7EijfGOkzF8TPqu1W4U97FTqSVs_rFayzEiZWfOu7F8HK_Q97FfEk8FFrKQskBX_jlQQWywQY4uiqWgtDsBEx0JOAyAyzeo_jkRByWRU_e4QpcX3Dgrpdyfp1wU8kliUAM-hJqTyWH0hSMbphUj9OvjM-O08DAphdvzivZHrvCx3-NzeDiugzz0lrXdy1q9ErQAg5fiOQvajAin32mPjc0EIsPG1etijqQwg5figcmi8xN4s1rh&spm=a1z09.2.0.0.661b2e8dAESMVA&skuId=5446264631289) | 201 | 网红电源，实际支持700W额定输出功率，ATX3.0标准 |
| 机箱 | TT 启航者S5 | 闲鱼 | 30 | 送了两个主机风扇 |
| 合计 |  |  | 1534 |  |

以上配置，没有像其他垃圾佬那样使用极低的价格采购配件，还是比较符合我自身的条件和需求的。

### 关于SAS硬盘问题

浪潮2308 6G直通卡IT模式在 Windows11 下可以免驱识别 Raid 卡以及两块硬盘，但是在黑苹果 Ventura 13.7.2 系统下无法识别，暂时未找到解决的办法。

### 关于安装黑苹果

博主已经将完整的 OpenCore EFI 文件提交到此项目下 [HUANANZHI-X99-TF-OC-EFI](https://github.com/lewlh/HUANANZHI-X99TF-OC-EFI), 感兴趣的朋友可以查看。

## 性能测试

![鲁大师跑分](/images/202501/鲁大师_核心硬件评测.png)

![GamePP跑分](/images/202501/GamePP_BenchMark.jpg)

![CPU-Z跑分](/images/202501/CPU-Z.PNG)

![GPU-Z参数](/images/202501/GPU-Z.gif)

![CinebenchR23_SingleCore](/images/202501/CinebenchR23_SingleCore_iShot_2025-01-18_18.27.49.png)

![CinebenchR23_MutiCore](/images/202501/CinebenchR23_MutiCore_iShot_2025-01-18_18.27.29.png)

![Geekbench-v6-cpu](/images/202501/Geekbench-v6-cpu-9993019-2025-01-18-19_57_34.png)

![Geekbench-v6-Metal](/images/202501/Geekbench-v6-compute-3502892-2025-01-18-19_59_17-Metal.png)

![Geekbench-v6-OpenCL](/images/202501/Geekbench-v6-compute-3502977-2025-01-18-20_00_03-OpenCL.png)

## References

+ 显卡
  + [《二手显卡选购攻略 2024暑期版》](https://mp.weixin.qq.com/s/XrNuVA6rNwLWUWFsCeS-kQ)
  + [《从入门到入土 AMD RX580北极星系列显卡二手淘金指南》](https://mp.weixin.qq.com/s/5ex6PChanZjAVyyzoGGsRQ)
  + [《垃圾佬的最爱显卡！矿界传奇但还能打，低预算玩黑猴游戏爱好者的首选显卡！》](https://mp.weixin.qq.com/s/YC5nWaq44FlT5XUlghHgDA)
  + [《妖卡拆解 旌宇RX5600 12G miniG用料浅析》](https://mp.weixin.qq.com/s/K2zYq6Sotu0ZM1Q6404iKQ)
  + [《妖卡再临 旌宇RX5600 miniG 12GB ITX显卡浅析》](https://mp.weixin.qq.com/s/199v0nafx2rIH8z9L9eIyQ)
  + [《苏氏遗孤 秽土转生 AMD RX5600 OEM 6GB显卡全解析》](https://mp.weixin.qq.com/s/V2JtuwLzqqADtIks7gDFaQ)
  + [《一帖搞定 二手显卡专用 测试数据全图》](https://mp.weixin.qq.com/s/bf2SmFOTctEYucEj8CU5tw)
  + [《兄弟们我忍不住下山了，买了个2022年产的RX580》](https://post.smzdm.com/p/a60dg90n/)
  + [《『攒机』电脑里的名堂 第3期 UEFI显卡故障玄学 解铃还须系铃人》](https://mp.weixin.qq.com/s/ClegwqLHqSHDNOenXWHyxw)
+ 主板
  + [《好价X99主板，90出头的四通道主板还要什么自行车！》](https://mp.weixin.qq.com/s/-5XWngv6zc4XpLriRh9l4Q)
  + [《垃圾佬E5洋垃圾绝配主板，可能是目前性价比最高的X99主板！》](https://mp.weixin.qq.com/s/XUXN_evUaxfw4fVoKcK35w)
+ 处理器
  + [《E5 系列真是 CPU 中的垃圾吗？E5 洋垃圾处理器还值得入手吗？》](https://mp.weixin.qq.com/s/1kt75uZnO2Xz0HDZQ5Ie_Q)
  + [《垃圾佬为什么都爱用E5处理器？因为它是真便宜啊！不到10元拿下！》](https://mp.weixin.qq.com/s/yixsOM0q4ecWFx4JX4dQSw)
  + [《如何选购E5CPU,打造性价比装机》](https://mp.weixin.qq.com/s/YVk05KkAP9rOzuuJuseWlA)
  + [《一代神U！人手一套，不到50元的真香处理器，鸡血后性能媲美十代i5！》](https://mp.weixin.qq.com/s/ucEx3U42d_CdtrPU42CaEw)
+ NVMe
  + [芯点子 C700 目前最便宜 7000m/s 固态硬盘简测](https://post.smzdm.com/p/ad9nxzzp/)
  + [芯点子c700上手，感觉还行](https://www.bilibili.com/opus/998865335593467907)
  + [芯点子C700 2T固态硬盘上手简评：希捷酷鱼530兄弟？](https://www.bilibili.com/video/BV14z421r7wg/?vd_source=3ddb5800edba7dbb68fa507b3abf76b7)
