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



# 二、基本定义

## 1、ACID特性

总得来说，事务是为了保证数据的安全性，一致性，正确性。必须满足所谓的**ACID**(原子性、一致性、隔离性和持久性)属性

*   **原子性(atomic)**，事务必须是原子工作单元；对于其数据修改，要么全都执行，要么全都不执行
*   **一致性(consistent)**，事务的执行结果，必须是从一个一致状态，变成另一个新的一致状态。事务的原子性保证其一致性
*   **隔离性(insulation)**，主要在并发时，各个事务之间互不影响。并发事务所作的修改必须与任何其它并发事务所作的修改隔离。
*   **持久性(Duration)**，事务一旦提交，数据就永久的保存在数据库，它对于系统的影响是永久性的。



