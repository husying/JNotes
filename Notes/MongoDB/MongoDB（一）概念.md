# MongoDB 简介

MongoDB 是最早热门非关系数据库的之一，使用也比较普遍，一般会用做离线数据分析来使用，放到内网的居。

MongoDB 基于分布式文件存储的数据库。由C++语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。在高负载的情况下，添加更多的节点，可以保证服务器性能。

MongoDB 是一个高性能，开源，无模式的文档型数据库，是当前 NoSql 数据库中比较热门的一种。

MongoDB 最大的特点是他支持的查询语言非常强大，其语法有点类似于面向对象的查询语言，几乎可以实现类似关系数据库单表查询的绝大部分功能，而且还支持对数据建立索引。



**MongoDB 与关系数据库的区别：**

> 传统的关系数据库一般由数据库（database）、表（table）、记录（record）三个层次概念组成，
>
> MongoDB 是由数据库（database）、集合（collection）、文档对象（document）三个层次组成。
>
> MongoDB 对于关系型数据库里的表，但是集合中没有列、行和关系概念，这体现了模式自由的特点。
>
> MongoDB 中的一条记录就是一个文档，是一个数据结构，由字段和值对组成。MongoDB 文档与 JSON 对象类似![img](assets/crud-annotated-document.png)



**MongoDB 特点：**

> * MongoDB 是一个面向文档存储的数据库，操作起来比较简单和容易。
> * MongoDB记录中设置任何属性的索引
> * Mongo支持丰富的查询表达式。查询指令使用JSON形式的标记，可轻易查询文档中内嵌的对象及数组。
> * MongoDB 的适合对大量或者无固定格式的数据进行存储，比如：日志、缓存等。对事物支持较弱，不适用复杂的多文档（多表）的级联查询。





# 资料参考

* [纯洁的微笑](http://www.ityouknow.com/springboot/2017/05/08/spring-boot-mongodb.html)
* [菜鸟教程](https://www.runoob.com/mongodb/mongodb-intro.html)