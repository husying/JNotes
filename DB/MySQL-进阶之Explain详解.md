---
typora-root-url: MySQL-进阶之Explain详解
---



在 MySQL 性能优化中，慢查询优化是我们经常需要解决的问题。通常我们可以使用 Explain 命令来了解 SQL 语句的执行计划，仅对select语句有效



# **Explain** 

代码演示如下

![](clipboard.png)



explain 查询会输出 12 列，如：id、select_type、table、partitions、type、possible_keys、key、key_len、ref、rows、filtered、extra

以下分别介绍一下，其中type 和 key 是我们看一个SQL 性能好坏的重点。



## select_type

表示查询类型，主要用于区别普通查询，联合查询，子查询等的复杂查询

>   **SIMPLE**：简单SELECT(不使用UNION或子查询)
>   **PRIMARY**：最外面的SELECT
>   **UNION**：UNION中的第二个或后面的SELECT语句
>   **DEPENDENT UNION**：UNION中的第二个或后面的SELECT语句,取决于外面的查询
>   **UNION RESULT**：UNION 的结果
>   **SUBQUERY**：子查询中的第一个SELECT
>   **DEPENDENT SUBQUERY**：子查询中的第一个SELECT,取决于外面的查询
>   **DERIVED**：导出表的SELECT(FROM子句的子查询)



**table**数据库中表名称或别名



## type

表示对表访问方式；常用的类型有： **ALL、index、range、 ref、eq_ref、const、system、NULL（从左到右，性能从差到好）**

**注意：一般保证查询至少达到range级别，最好能达到ref**

>   **ALL**：Full Table Scan， MySQL将遍历全表以找到匹配的行
>   **index**：Full Index Scan，index与ALL区别为index类型只遍历索引树
>   **range**：只检索给定范围的行，如： between/in、> 、< 、in 等方式
>   **ref**：表示上述表的连接匹配条件，即哪些列或常量被用于查找索引列上的值
>   **eq_ref**： 类似ref，区别就在使用的索引是唯一索引，对于每个索引键值，表中只有一条记录匹配，简单来说，就是多表连接中使用primary key或者 unique key作为关联条件
>   **const/system**： 当MySQL对查询最多有一个匹配行，在这行的列值可被优化器剩余部分认为是常数。如将主键置于where列表中，MySQL就能将该查询转换为一个常量，system是const类型的特例，当查询的表只有一行的情况下，使用system
>   **NULL**：MySQL在优化过程中分解语句，执行时甚至不用访问表或索引，例如从一个索引列里选取最小值可以通过单独索引查找完成。



## possible_keys

指出MySQL能使用哪个索引在表中找到记录，查询涉及到的字段上若存在索引，则该索引将被列出，但不一定被查询使用（该查询可以利用的索引，如果没有任何索引显示 null）



## key

**显示MySQL实际决定使用的键(索引)。如果没有选择索引，键是NULL。**



**key_len：**表示索引中使用的字节数

**ref：**列与索引的比较，表示上述表的连接匹配条件，即哪些列或常量被用于查找索引列上的值

**rows：**估算出结果集行数，表示MySQL根据表统计信息及索引选用情况，估算的找到所需的记录所需要读取的行数



## Extra

>   Using index：表示相应的select操作用使用覆盖索引，避免访问了表的数据行。如果同时出现using where，表名索引被用来执行索引键值的查找；如果没有同时出现using where，表名索引用来读取数据而非执行查询动作。
>
>   Using where：表明使用where过滤，当有where子句时，extra都会有说明。
>
>   Using temporary：表示需要使用临时表来存储结果集，常见于排序和分组查询，常见 group by ; order by
>
>   Using filesort：当Query中包含 order by 操作，而且无法利用索引完成的排序操作称为“文件排序”
>
>   Distinct：发现第1个匹配行后,停止为当前的行组合搜索更多的行
>
>   Not exists：表示MySQL能够对查询进行LEFT JOIN优化,发现1个匹配LEFT JOIN标准的行后,不再为前面的的行组合在该表内检查更多的行。
>
>   Range checked for each record：mysql没有发现好的索引可用，速度比没有索引要快得多。
>
>   Using sort_union(...)/Using union(...)/Using intersect(...)：表明 index_merge 联接类型合并索引扫描。
>
>   Using index for group-by：表明可以在索引中找到GROUP BY或DISTINCT所需的所有数据，不需要查询实际的表。



**资料参考**

*   高性能MySQL（第3版）.pdf