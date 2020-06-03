# JNotes

主要记录一下 JAVA 学习的一个笔记，目的是将零碎的知识，进行系统化，体系化。个人认为可以作为一个 Java 程序员面试的宝典，是初级迈向高级的一个必备基础知识，它将囊括了Java后端开发中常用的一系列知识点，如 Java基础、集合、并发、IO、算法、设计模式、架构等模块；相信对于正准备找工作面试的同道来说，也许是一份非常好的参考；同时也推荐了一些非常优秀的开源项目或开发工具、技术书籍等，便于正在迷茫、找不到学习方向的小白们，能进一步提升自己的能力。



觉得之前一个版本总结的不是特别好，于是准备重新整理一份更完善的技术栈知识点。

---

# :mag_right::herb:技术栈

|     :hotsprings:      | :floppy_disk: | :globe_with_meridians: | :rainbow: | :triangular_ruler: |      :cd:       |   :pencil2:   | :wrench: | :pushpin: | :fire:   | :books:  |          :o:          |
| :-------------------: | :-----------: | :--------------------: | :-------: | :----------------: | :-------------: | :-----------: | :------: | :-------: | -------- | :------: | :-------------------: |
| [Java语言](#Java语言) |    数据库     |      框架/中间件       | 设计模式  |   数据结构/算法    | 操作系统/服务器 | 系统架构/开发 | 开发工具 | 面试准备  | 开源推荐 | 专业书籍 | [在线平台](#在线平台) |



# Java 语言

## Java 基础

- Java基础篇（1）面向对象基础
- Java基础篇（2）数据类型
- Java基础篇（3）String
- Java基础篇（4）Object
- Java基础篇（5）特殊关键字
- Java基础篇（6）类定义与初始化
- Java基础篇（7）运算
- Java基础篇（8）反射
- Java基础篇（9）异常
- Java基础篇（10）泛型



## Java 集合

- Java集合篇（1）集合关系
- Java集合篇（2）ArrayList源码解析
- Java集合篇（3）LinkedList源码解析
- Java集合篇（4）Vector源码解析
- Java集合篇（5）HashSet源码解析
- Java集合篇（6）TreeSet源码解析
- Java集合篇（7）LinkedHashSet源码解析
- Java集合篇（8）ArrayDeque源码解析
- Java集合篇（9）PriorityQueue源码解析
- Java集合篇（10）HashMap源码解析
- Java集合篇（11）TreeMap源码解析
- Java集合篇（12）HashTable源码解析



## JVM 相关

- JVM基础篇（）简介

- JVM基础篇（）内存模型
- JVM基础篇（）类加载机制
- JVM基础篇（）垃圾回收机制
- JVM调优篇（）JVM调优命令
- JVM调优篇（）JVM调优参数
- JVM调优篇（）Java问题排查



## Java 多线程与并发

- Java多线程与并发篇（1）理论基础
- Java多线程与并发篇（2）线程基础
- Java多线程与并发篇（3）线程池实现
- Java多线程与并发篇（4）线程安全
- Java多线程与并发篇（5）线程锁
- Java多线程与并发篇（6）volatile详解
- Java多线程与并发篇（7）ThreadLocal详解

- JUC详解（）原子类
- JUC详解（）锁LockSupport
- JUC详解（）锁ReentrantLock
- JUC详解（）锁ReentrantReadWriteLock
- JUC详解（）集合ConcurrentHashMap
- JUC详解（）集合CopyOnWriteArrayList
- JUC详解（）集合ConcurerntLinkedQueue
- JUC详解（）集合BlockingQueue 
- JUC详解（）线程池FutureTask
- JUC详解（）线程池ThreadPoolExecutor
- JUC详解（）线程池ScheduledThreadPoolExecutor 
- JUC详解（）线程池Fork/Join框架
- JUC详解（）工具类CountDownLatch
- JUC详解（）工具类CyclicBarrier
- JUC详解（）工具类Semaphore
- JUC详解（）工具类Phaser
- JUC详解（）工具类Exchanger



## Java 网络/IO/NIO/AIO

- Java网络编程篇（）基础

- Java IO 简介
- Java IO（）基础
- Java IO（）装饰者模式
- Java IO（）InputStream/OutputStream源码解析
- Java NIO（）基础
- Java AIO（）基础



## Java 版本特性

- Java8版本特性（1）概述
- Java8版本特性（2）函数式接口

- Java8版本特性（3）Optional类
- Java8版本特性（4）Stream API



# 数据库

- 数据库篇（1）基础
- 数据库篇（2）事务
- 数据库篇（3）算法
- 数据库篇（4）SQL语法
- 数据库篇（）NoSQL
- RDBMS之MySQL（）存储引擎
- RDBMS之MySQL（）数据类型
- RDBMS之MySQL（）索引
- RDBMS之MySQL（）SQL基本语法
- RDBMS之MySQL（）数据库设计规约
- RDBMS之MySQL（）性能优化
- NoSQL之Redis（）
- NoSQL之MongoDB（）
- NoSQL之ElasticSearch（）



# 框架/中间件

- Spring框架（1）基础
- Spring框架（2）事务管理
- Spring框架（3）AOP实现
- Spring框架（4）MVC
- Spring框架（）常用注解

- Spring框架（）设计模式
- Spring框架（）SpringBoot
- 分布式微服务框架之SpringCloud（）
- 分布式微服务框架之Dubbo（）

- 持久层框架（）Mybatis
- 持久层框架（）Mybatis常见使用技巧
- 持久层框架（）分页插件PageHelper详解
- 安全认证框架之Shiro（）
- ZooKeeper（）

- 消息队列（）简介
- 消息队列（）ActiveMQ详解
- 消息队列（）RabbitMQ详解
- 消息队列（）Kafka详解
- 分库分表中间件（）Sharding-JDBC
- 分库分表中间件（）MyCAT



# 设计模式

- JDK（）设计模式
- Spring框架（）设计模式
- 23种设计模式之简介
- 设计模式（1）工厂模式
- 设计模式（2）抽象工厂模式
- 设计模式（4）建造者模式
- 设计模式（5）原型模式
- 设计模式（6）适配器模式
- 设计模式（7）装饰器模式
- 设计模式（8）代理模式
- 设计模式（9）外观模式
- 设计模式（10）桥接模式
- 设计模式（11）组合模式
- 设计模式（12）享元模式
- 设计模式（13）策略模式
- 设计模式（14）模板模式
- 设计模式（15）观察者模式
- 设计模式（16）迭代器模式
- 设计模式（17）责任链模式
- 设计模式（18）命令模式
- 设计模式（19）备忘录模式
- 设计模式（20）状态模式
- 设计模式（21）访问者模式
- 设计模式（22）中介者模式
- 设计模式（23）解释器模式



# 数据结构与算法

- 数据结构篇（）简介
- 数据结构篇--线性表（）数组和矩阵
- 数据结构篇--线性表（）链表
- 数据结构篇--线性表（）hash表
- 数据结构篇--线性表（）栈和队列
- 数据结构篇--树（）基础
- 数据结构篇--树（）二叉树
- 数据结构篇--树（）平衡二叉树
- 数据结构篇--树（）B+树
- 数据结构篇--树（）红黑树
- 数据结构篇--树（）哈夫曼树
- 数据结构篇--图（）基础

- 排序算法（1）简介
- 排序算法（2）插入排序之直接插入排序
- 排序算法（3）插入排序之希尔排序
- 排序算法（4）选择排序之简单选择排序
- 排序算法（5）选择排序之堆排序
- 排序算法（6）交换排序之冒泡排序
- 排序算法（7）交换排序之快速排序
- 排序算法（8）归并排序
- 排序算法（9）基数排序
- 排序算法（10）计数排序
- 排序算法（11）桶排序

- 查询算法（1）顺序查询
- 查询算法（2）二分查询
- 查询算法（3）插值查询
- 查询算法（4）斐波那契查询
- 查询算法（5）树表查询
- 查询算法（6）分库查询
- 查询算法（7）哈希查询

- 领域算法（）加密算法
- 领域算法（）Snowflake算法
- 领域算法（）一致性Hash算法
- 领域算法（）ZAB算法
- 领域算法（）负载均衡算法
- 大数据算法（）分治/hash/排序
- 大数据算法（）布隆过滤
- 大数据算法（）双层桶划分
- 大数据算法（）MapReduce
- 大数据算法（）外排序
- 大数据算法（）前缀树Trie



# 操作系统与服务器

- Linux命令（1）常用命令
- WEB服务器（）Tomcat
- WEB服务器（）Jetty
- WEB服务器（）Nginx



# 系统架构与设计

- 高并发架构策略（1）缓存
- 高并发架构策略（2）限流
- 高并发架构策略（3）降级
- 高并发架构策略（4）负载均衡
- 高并发架构策略（4）容灾备份

- 微服务架构（）中台
- 架构案例（）秒杀系统

- 项目开发设计（）开发流程介绍
- 项目开发设计（）架构设计之开发工具
- 项目开发设计（）架构设计之工程结构设计
- 项目开发设计（）架构设计之Java命名规规约
- 项目开发设计（）关系型数据库设计
- 项目开发设计（）单元测试
- 文档模板（1）架构设计文档
- 文档模板（2）需求功能详细设计文档
- 文档模板（3）统一开发手册
- 文档模板（4）自测报告文档



# 开发工具

- 开发之常用开发类库（1）JSON类库详解
- 开发之常用开发类库（2）日志类库详解
- 开发之常用开发类库（3）Bean属性复制工具详解
- 开发之常用开发类库（4）Apache Commons包
- 开发之常用开发类库（5）Hutool包
- 开发之常用开发类库（6）Google Guava包

- 工具详解（）Maven
- 工具详解（）Git
- 工具详解（）SVN
- 工具详解（）Jenkins
- 常用工具（1）软件工具
- 常用工具（2）IDEA 插件
- 常用工具（3）在线工具

- 开发之快捷键（1）IDEA常用快捷键
- 开发之快捷键（2）Eclipse常用快捷键
- 开发之快捷键（3）Excel常用快捷键



# 面试准备

- 面试（）常见招聘
- 面试（）笔试题
- 面试（）简历模板
- 面试（）面谈技巧



# 开源推荐

- 个人项目（）springboot-chapters（进行中）
- 个人项目（）springcloud-chapters（进行中）
- 个人项目（）java-design-pattern（进行中）
- 个人项目（）husy-tool（进行中）
- 个人项目（）husy-demo（进行中）
- 个人项目（）husy-mall
- 个人项目（）husy-api
- GitHub开源框架（）[baomidou/mybatis-plus](https://github.com/baomidou/mybatis-plus)
- GitHub开源框架（）[looly/hutool](https://github.com/looly/hutool)
- GitHub开源框架（）[alibaba/fastjson](https://github.com/alibaba/fastjson)
- GitHub开源框架（）[Mybatis-PageHelper](https://github.com/pagehelper/Mybatis-PageHelper)

- GitHub开源项目之面试指南（）[AobingJava / JavaFamily](https://github.com/AobingJava/JavaFamily)
- GitHub开源项目之面试指南（）[labuladong / fucking-algorithm](https://github.com/labuladong/fucking-algorithm)
- GitHub开源项目之面试指南（）[doocs / advanced-java](https://github.com/doocs/advanced-java)
- GitHub开源项目之面试指南（）[Snailclimb / JavaGuide](https://github.com/Snailclimb/JavaGuide)
- GitHub开源项目之面试指南（）[crossoverJie / JCSprout](https://github.com/crossoverJie/JCSprout)
- GitHub开源项目之面试指南（）[CyC2018 / CS-Notes](https://github.com/CyC2018/CS-Notes)
- Gitee开源项目之分布式系统（）[张恕征](https://gitee.com/shuzheng) / [zheng](https://gitee.com/shuzheng/zheng)
- Gitee开源项目之分布式系统（）[小柒2012](https://gitee.com/52itstyle) / [spring-boot-seckill](https://gitee.com/52itstyle/spring-boot-seckill)
- Gitee开源项目之微服务系统（）[The Sun](https://gitee.com/geek_qi) / [Cloud-Platform](https://gitee.com/geek_qi/cloud-platform)
- Gitee开源项目之微服务系统（） [jeecp](https://gitee.com/owenwangwen) / [open-capacity-platform](https://gitee.com/owenwangwen/open-capacity-platform)
- Gitee开源项目之微服务系统（）[@HuangBingGui](https://gitee.com/JeeHuangBingGui) / [JeeSpringCloud](https://gitee.com/JeeHuangBingGui/jeeSpringCloud)
- Gitee开源项目之后台管理系统（）[闲.大赋](https://gitee.com/xiandafu) / [springboot-plus](https://gitee.com/xiandafu/springboot-plus)
- GitHub开源项目之后台管理系统（）[elunez / eladmin](https://github.com/elunez/eladmin)
- GitHub开源项目之商城系统（）[macrozheng / mall](https://github.com/macrozheng/mall)



# 专业书籍

- Effective Java中文版（第2版）.pdf
- Java并发编程的艺术.pdf
- Java并发编程实战
- Thinking In Java第四版中文版.pdf
- 深入理解Java虚拟机：JVM高级特性与最佳实践（第二版）.pdf
- 高性能MySQL（第3版）.pdf
- Head First设计模式.pdf
- 算法第四版.pdf
- 阿里巴巴Java开发手册（详尽版）.pdf
- 亿级流量网站架构核心技术 .pdf
- 重构_改善既有代码的设计.pdf
- 企业IT架构转型之道：阿里巴巴中台战略思想与架构实战.pdf



# 在线平台

- LintCode|[www.lintcode.com](http://www.lintcode.com)
- 菜鸟教程|[www.runoob.com](http://www.runoob.com)
- 并发编程网|http://ifeve.com/
- 个人博客网站|酷壳|https://coolshell.cn/
- 个人博客网站|Java 全栈知识体系|https://www.pdai.tech/
- 个人博客网站|廖雪峰的官方网站|https://www.liaoxuefeng.com/

