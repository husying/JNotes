

**springboot-chapters** 是一个 SpringBoot 学习，并实战练习的项目，通过示例代码，快速简单上手教程



# 模块总览

**包含子模块工程如下：**

```java
springboot-helloword：SpringBoot 入门工程
springboot-profiles：SpringBoot 配置文件使用，分别采用 .properties和 .yml 进行配置，并进行多种方式读取
springboot-web： SpringBoot Web应用简单实现
springboot-aop： SpringBoot  AOP 切面的实现
springboot-async： SpringBoot  线程异步实现
springboot-session： SpringBoot  Session 运用
springboot-servlet： 集成  Servlet 3.0 
springboot-swagger：集成 Swagger 2 进行统一 API 接口管理
springboot-jpa：集成 JPA 进行数据库操作
springboot-mybatis：集成 Mybatis 进行数据操作
springboot-jdbc：集成 Jdbc-Tmeplate 进行数据操作
springboot-mybatisplus：集成 Mybatis-plus 进行数据库操作，分页处理
springboot-multi-db：多数据源
springboot-dynamic-db：动态数据源运用
springboot-pagehelper：集成 PageHelper 进行分页查询
springboot-thymeleaf：集成 Thymeleaf 模板引擎
springboot-freemarker：集成 Freemarker 模板引擎
springboot-velocity：集成 Velocity 模板引擎
springboot-ehcache：集成 EhCache ，进行缓存运用
springboot-redis：集成 Redis ，进行缓存运用
springboot-memcache：集成 memcache，进行缓存运用
springboot-mongodb：集成 MongoDB，进行缓存运用
springboot-shiro：集成 Shiro 进行权限认证
springboot-security：集成 Spring Security 进行权限认证
springboot-sso：集成 SSO 单点登录
springboot-logback：集成 Logback 进行日志记录
springboot-rabbitmq：集成 RabbitMQ  队列
springboot-rocketmq：集成 RocketMQ  队列
springboot-activemq：集成 ActiveMQ  队列
springboot-kafka：集成 kafka 队列
springboot-scheduld：SpringBoot 的定时器运用
springboot-quartz：集成 Quartz，实现定时任务管理
springboot-xxl-job：集成 xxl-Job，实现定时任务管理
springboot-actuator：集成 Actuator 进行监控
springboot-oauth : 集成 OAuth 2
springboot-zookeeper：集成 ZooKeeper，进行分布式构建
springboot-dubbo：集成 Dubbo 微服务
springboot-websocket：集成 WebSocket 模块，实现后端向前端进行主动推送功能
springboot-elasticsearch：集成 ElasticSearch
springboot-sharding-jdbc：集成 Sharding-JDBC ，进行分库分表操作
springboot-fastdfs：集成FastDFS 进行在分布式系统中进行文件上传、下载等操作
springboot-devtools：集成 DevTools 模块进行热部署实现
springboot-mail：集成 Mail 模块进行发送邮件
```



# 版本说明

| **依赖名称(artifactId)** | **版本号**    | **描述**                  |
| ------------------------ | ------------- | ------------------------- |
| spring-boot-starter      | 2.2.2.RELEASE | springboot 启动类依赖     |
| spring-boot-starter-web  | 2.2.2.RELEASE | springboot web 启动类依赖 |



# **主工程POM 文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.2.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.husy</groupId>
    <artifactId>springboot-chapters</artifactId>
    <version>1.0.0</version>
    <name>springboot-chapters</name>
    <packaging>pom</packaging>

    <modules>
        <module>springboot-helloword</module>
        <module>springboot-profiles</module>
        <module>springboot-web</module>
    </modules>

    <properties>
        <java.version>1.8</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```



# 演练说明

子模块工程正在计划中，以下为以实现工程项目

* [SpringBoot实战（1）springboot-chapters介绍](SpringBoot实战（1）springboot-chapters介绍.md)
* [SpringBoot实战（2）helloword](SpringBoot实战（2）helloword.md)
* [SpringBoot实战（3）读取配置文件](SpringBoot实战（3）读取配置文件.md)





# 源码

[开源地址]([源码实现](https://github.com/HusyCoding/springboot-chapters.git))



# 资料参考

* [纯洁的微笑](http://www.ityouknow.com/spring-boot.html)