# SpringBoot 动态定时任务持久化

# Quartz依赖

```xml
<!--quartz依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>

```



# sql脚本

很多人的博文中都没有SQL脚本，很多朋友都不知道怎么获取SQL脚本，这里解密一下，该SQL脚本是由官方定义好的，可以直接去官网下载的。但是下载注意了，版本的不同可能有稍微变化。

我们根据spring-boot-starter-quartz 依赖找到对应的版本，如下：

![1569492250582](assets/1569492250582.png)



然后到官网下载相应的tar.gz包，[官方地址](http://www.quartz-scheduler.org/downloads/)，解压后在src\org\quartz\impl\jdbcjobstore下，找到相应的数据库脚本，

![1569492566123](assets/1569492566123.png)

