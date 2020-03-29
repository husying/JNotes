SQL 是structure Query Language（结构化查询语言） 的简称，是关系型数据库语言；

SQL 语句主要可以分为以下 3 个类别，如下：

* DDL（Data Definition Languages，数据定义语言）：对数据库内部的对象进行创建、删除、修改等操作，常用关键字：create、drop、alter
* DML（Data Manipulation Languages，数据操作语言）：对数据库表记录进行操作，主要包括插入、更新、删除和查询，常用关键字：insert、delete、update和select
* DCL（Data Control Languages，数据控制语言）：主要控制系统的对象权限，常用关键字：grant、revoke



# 常用SQL

## 表结构设计

```sql
#删除表
DROP TABLE if EXISTS `table_name`;
#创建新表
CREATE TABLE `table_name` (
	`table_id` INT(11) [ NOT NULL ] [ AUTO_INCREMENT ] COMMENT '主键ID',
	`col1` TYPE1 [ NOT NULL ] DEFAULT '' COMMENT '字段描述',
	PRIMARY KEY (`table_id`),
	INDEX `idx_col1` (`col1`)
)
COMMENT='表结构描述'
ENGINE=InnoDB
;
#根据已有的表创建新表：
CREATE TABLE `tab_new`like `table_name`;
-- definition only 表明只是用查询表的表定义,不插入数据。
CREATE TABLE `tab_new` as select col1,col2… from `table_old` definition only

#修改表结构
-- 1、添加字段（alter、add、after）
ALTER TABLE `table_name` ADD COLUMN `col2` INT NULL AFTER `col1`;
-- 2、修改字段（alter、modify、change）,modify与change的区别：change可以修改字段名称，modify不行
ALTER TABLE `table_name` MODIFY  `col_name` int unsigned default '0';
ALTER TABLE `table_name` CHANGE  `col_name` int unsigned default '0';
-- 3、删除字段（alter、drop）
ALTER TABLE `table_name` DROP  `col_name`

#修改表约束
PRIMARY KEY     --标识该属性为该表的主键，可以唯一的标识对应的元组
FOREIGN KEY     --标识该属性为该表的外键，是与之联系某表的主键
UNIQUE          --标识该属性的值是唯一的
-- 格式
 
-- 1、主键
 ALTER TABLE `table_name` ADD PRIMARY KEY('col_name');
 ALTER TABLE `table_name` DROP PRIMARY KEY;
-- 2、外键
ALTER TABLE `table1_name` ADD CONSTRAINT fk_id FOREIGN KEY(dept_id) REFERENCES `table2_name`(`col_name`);
ALTER TABLE `table1_name` DROP CONSTRAINT fk_id;
-- 3、索引
ALTER TABLE `table_name` ADD UNIQUE ( `column` ) ;
ALTER TABLE `table_name` ADD INDEX idx_name ( `column` ) ;
ALTER TABLE `table_name` ADD INDEX idx_name ( `column1`, `column2`, `column3` );
ALTER TABLE `table_name` ADD FULLTEXT ( `column`) ;
```



## DML语法

```sql
#数据增删改查
选择：select * from table1 where 范围
插入：insert into table1(field1,field2) values(value1,value2)
删除：delete from table1 where 范围
更新：update table1 set field1=value1 where 范围
查找：select * from table1 where field1 like ’%value1%’ ---like的语法很精妙，查资料!
排序：select * from table1 order by field1,field2 [desc]
总数：select count as totalcount from table1
求和：select sum(field1) as sumvalue from table1
平均：select avg(field1) as avgvalue from table1
最大：select max(field1) as maxvalue from table1
最小：select min(field1) as minvalue from table1
```



## 特殊查询

### 日历表

当我们在做数据报表的时候，经常会去查询近一段时间显示的数据，但是拿到的数据却是某一天没数据的话是查询不出来的，但是我们希望没数据的那天显示为0

这时有两种解决办法

* 其一：重写sql语句，使用 SELECT  UNION 一个个写出来，还有一种就是创建日历表
* 其二：在返回数据的java代码中重新拼接数据，先获取三十日的日期，把没数据的补0即可

**创建日历表**

```sql
# =====================>> 创建日历表  start <<========================
DROP TABLE IF EXISTS `num`;
CREATE TABLE `num` (i INT);
INSERT INTO `num` (i) VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)

# 日期的表
DROP TABLE IF EXISTS `t_calendar`;
CREATE TABLE t_calendar(
	report_date DATE
); 
 
-- 生成并插入当前年初前后 10 年的日期数据
INSERT INTO t_calendar(report_date) 
SELECT ADDDATE( DATE_SUB(DATE_SUB(curdate(),INTERVAL DAYOFYEAR(CURDATE())-1 DAY),INTERVAL 10 YEAR ) ,numlist.id) AS `date`
FROM(
	SELECT id FROM (
		SELECT n1.i + n10.i * 10  + n100.i * 100 + n1000.i * 1000 AS id
		FROM num n1	CROSS JOIN num AS n10 CROSS JOIN num AS n100 CROSS JOIN num AS n1000
	) t WHERE t.id<(select TimeStampDiff(DAY,DATE_SUB(DATE_SUB(curdate(),INTERVAL DAYOFYEAR(CURDATE())-1 DAY),INTERVAL 10 YEAR ),DATE_SUB(DATE_SUB(curdate(),INTERVAL DAYOFYEAR(CURDATE())-1 DAY),INTERVAL -11 YEAR )))
) AS numlist;

DROP TABLE `num`;
# =====================>> 创建日历表  end <<========================
```

## 视图

优点：

1. 简化复杂的 SQL 操作，比如复杂的连接，让数据更加清晰，所见即所得
2. 只使用实际表的一部分数据
3. 通过只给用户访问视图的权限，保证数据的安全性；
4. 更改数据格式和表示。

缺点：

1. 性能相对较差，简单查询会变的复杂
2. 修改不方便

```sql
CREATE VIEW myview AS
SELECT Concat(col1, col2) AS concat_col, col3*col4 AS compute_col
FROM mytable
WHERE col5 = val;
```



## 存储过程

存储过程可以看成是对一系列 SQL 操作的批处理。

使用存储过程的好处:

* 代码封装，保证了一定的安全性；
* 代码复用；
* 由于是预先编译，因此具有很高的性能。

命令行中创建存储过程需要自定义分隔符，因为命令行是以 ; 为结束符，而存储过程中也包含了分号，因此会错误把这部分分号当成是结束符，造成语法错误。包含 in、out 和 inout 三种参数。给变量赋值都需要用 select into 语句。每次只能给一个变量赋值，不支持集合的操作。

```sql
delimiter //

create procedure myprocedure( out ret int )
    begin
        declare y int;
        select sum(col1)
        from mytable
        into y;
        select y*y into ret;
    end //

delimiter ;
```

```sql
call myprocedure(@ret);
select @ret;
```

**游标**

在存储过程中使用游标可以对一个结果集进行移动遍历。游标主要用于交互式应用，其中用户需要对数据集中的任意行进行浏览和修改。

使用游标的四个步骤:

1. 声明游标，这个过程没有实际检索出数据；
2. 打开游标；
3. 取出数据；
4. 关闭游标；

```sql
delimiter //
create procedure myprocedure(out ret int)
    begin
        declare done boolean default 0;

        declare mycursor cursor for
        select col1 from mytable;
        # 定义了一个 continue handler，当 sqlstate '02000' 这个条件出现时，会执行 set done = 1
        declare continue handler for sqlstate '02000' set done = 1;

        open mycursor;

        repeat
            fetch mycursor into ret;
            select ret;
        until done end repeat;

        close mycursor;
    end //
 delimiter ;
```

## 触发器

触发器会在某个表执行以下语句时而自动执行: DELETE、INSERT、UPDATE。

触发器必须指定在语句执行之前还是之后自动执行，之前执行使用 BEFORE 关键字，之后执行使用 AFTER 关键字。BEFORE 用于数据验证和净化，AFTER 用于审计跟踪，将修改记录到另外一张表中。

INSERT 触发器包含一个名为 NEW 的虚拟表。

```sql
CREATE TRIGGER mytrigger AFTER INSERT ON mytable
FOR EACH ROW SELECT NEW.col into @result;

SELECT @result; -- 获取结果
```

DELETE 触发器包含一个名为 OLD 的虚拟表，并且是只读的。

UPDATE 触发器包含一个名为 NEW 和一个名为 OLD 的虚拟表，其中 NEW 是可以被修改的，而 OLD 是只读的。

MySQL 不允许在触发器中使用 CALL 语句，也就是不能调用存储过程



# 资料参考

* [Java 全站知识体系](http://www.pdai.tech)