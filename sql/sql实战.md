# 一、基本语法

```sql
1、创建数据库
CREATE DATABASE database-name

2、删除数据库
drop database dbname

3、备份sql server
--- 创建 备份数据的 device
USE master
EXEC sp_addumpdevice 'disk', 'testBack', 'c:\mssql7backup\MyNwind_1.dat'
--- 开始 备份
BACKUP DATABASE pubs TO testBack

4、创建新表
create table tabname(col1 type1 [not null] [primary key],col2 type2 [not null],..)

根据已有的表创建新表：
A：create table tab_new like tab_old (使用旧表创建新表)
B：create table tab_new as select col1,col2… from tab_old definition only

5、删除新表
drop table tabname

6、增加一个列
Alter table tabname add column col type
注：列增加后将不能删除。DB2中列加上后数据类型也不能改变，唯一能改变的是增加varchar类型的长度。

7、添加主键： Alter table tabname add primary key(col)
删除主键： Alter table tabname drop primary key(col)

8、创建索引：create [unique] index idxname on tabname(col….)
删除索引：drop index idxname
注：索引是不可更改的，想更改必须删除重新建。

9、创建视图：create view viewname as select statement
删除视图：drop view viewname

10、几个简单的基本的sql语句
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





# 日历表

当我们在做数据报表的时候，经常会去查询近一段时间显示的数据，但是拿到的数据却是某一天没数据的话是查询不出来的，但是我们希望没数据的那天显示为0

这时有两种解决办法

其一：重写sql语句，使用 SELECT  UNION 一个个写出来，还有一种就是创建日历表

其二：在返回数据的java代码中重新拼接数据，先获取三十日的日期，把没数据的补0即可



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



# 常用关键字

## 约束条件

```sql
PRIMARY KEY     --标识该属性为该表的主键，可以唯一的标识对应的元组
FOREIGN KEY     --标识该属性为该表的外键，是与之联系某表的主键
NOT NULL        --标识该属性不能为空
UNIQUE          --标识该属性的值是唯一的
AUTO_INCREMENT	--标识该属性的值是自动增加，这是MySQL的SQL语句的特色
DEFAULT	        --为该属性设置默认值
```





# 常用时间处理

```sql
-- 计算两个日期之间的时间间隔的方法
select TimeStampDiff(DAY,'2019-01-01','2019-02-03')
```

