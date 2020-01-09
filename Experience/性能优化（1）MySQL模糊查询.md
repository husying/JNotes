---
typora-root-url: 性能优化（1）MySQL模糊查询
---

关于MySQL模糊查询有优化问题，网络上如下几种方案：

* 模糊查询修改为后缀模糊查询
* 使用LOCATE（substr,str,pos）方法
* 使用POSITION(substr IN field)方法
* 使用INSTR(str,substr)方法

这里测试一下真假 



# LOCATE、POSITION、INSTR

**环境准备**

MySQL 版本：8.0.16

搜索引擎：InnoDB

数据库表结构 ：

```sql
CREATE TABLE `user` (
	`id` VARCHAR(50) NOT NULL,  # 考虑特殊情况使用 UUID 主键
	`name` VARCHAR(30) NOT NULL,
	`create_time` TIMESTAMP NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `idx_name` (`name`)
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB
;
```

数据量大小：4900002

![](数据量大小.png)

当前系统CPU 、磁盘IO状态：

![](/1578033488870.png)



模糊查询SQL执行3次的结果：

```sql
SELECT * FROM `user` WHERE `name`  LIKE '%躬%';
/* 影响到的行: 0  Found rows: 9,525  查询: 0.328 sec*/
/* 影响到的行: 0  Found rows: 9,525  查询: 0.281 sec*/
/* 影响到的行: 0  Found rows: 9,525  查询: 0.282 sec*/
```

可以看出平均需要 3 s



使用后缀模糊查询

```sql
SELECT * FROM `user` WHERE `name`  LIKE '躬%';
/* 影响到的行: 0  Found rows: 1,453  查询: 0.094 sec. */
/* 影响到的行: 0  Found rows: 1,453  查询: 0.078 sec. */
/* 影响到的行: 0  Found rows: 1,453  查询: 0.079 sec. */
```

以上可以看出 SQL语句可以使用了索引，搜索的效率大大的提高了！

但是，我们在做模糊查询的时候，非特定情况，这种前缀查询并不能满足需求，所以，并不合适所有的模糊查询



而使用其他函数呢？

![1578035852164](1578035852164.png)



可以看出 LOCATE、POSITION、INSTR并不能有效的提高查询效率。



具体怎么优化模糊查询的SQL，小编至今还没找到良好的处理方式，如果你知道，麻烦留言指点:pray::pray::pray: