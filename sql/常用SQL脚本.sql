


# 本周7天的日期
SELECT @a := @a + 1 as `index`  , DATE_ADD(DATE_SUB(CURRENT_DATE,INTERVAL WEEKDAY(CURRENT_DATE)+1 DAY ),INTERVAL @a DAY) AS `date`
FROM mysql.help_topic,(SELECT @a:=0,@m:=7) temp
WHERE @a < @m

#最近 7 天的日期
SELECT @s :=@s + 1 as `index`, DATE_SUB(CURRENT_DATE, INTERVAL @s DAY) AS `date`
FROM mysql.help_topic,(SELECT @s := -1) temp
WHERE @s < 6

#最近30天，每天日期
SELECT @a := @a + 1 AS 'index', DATE_SUB(CURRENT_DATE,INTERVAL@a DAY) AS 'day'
FROM  mysql.help_topic,(SELECT @a:=0,@m:=30 ) temp
WHERE @a<@m

# 获取本月每天日期
SELECT @a := @a + 1 AS 'index', DATE_ADD(DATE_SUB(CURRENT_DATE,INTERVAL DAYOFMONTH(CURRENT_DATE) DAY),INTERVAL @a DAY) AS 'day'
FROM mysql.help_topic,(SELECT @a:=0,@m:=day(LAST_DAY(CURRENT_DATE))) temp
WHERE @a<@m



# 查询今年所有月份日期
SELECT @a := @a + 1 AS 'no', DATE_FORMAT(DATE(DATE_ADD(DATE_SUB(CURRENT_DATE,INTERVAL MONTH(CURRENT_DATE) MONTH), INTERVAL @a MONTH)),'%Y-%m') AS 'month'
FROM mysql.help_topic,(SELECT @a:=0,@m:=12) temp
WHERE @a<@m



