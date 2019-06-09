# Maven 

# Maven 基础概念

*   Project：指功能，被定义为工程对象模型（Project Object Model，POM）
*   POM：maven 核心文件，位于工程跟目录
*   GroupId：指一个工程在全局中的唯一标识符，一般是工程名
*   Artifact：指构建，需要被使用的 Artifact 都要放在仓库中，否则Maven 无法找到
*   Dependency：依赖
*   Plug-in：maven的插件集合
*   Repository：仓库，即放置Artifact的地方

# 常用maven依赖

## 图片验证码

1、Google Kaptcha

```xml
<dependency>
    <groupId>com.github.axet</groupId>
    <artifactId>kaptcha</artifactId>
    <version>${kaptcha.version}</version>
</dependency>
```





# SpringBoot 依赖

[全部依赖](https://docs.spring.io/spring-boot/docs/2.2.0.BUILD-SNAPSHOT/reference/html/using-spring-boot.html#using-boot-maven)

常用依赖如下

| 名称                                      | 描述                                                         |
| ----------------------------------------- | ------------------------------------------------------------ |
| spring-boot-starter-activemq              | 使用Apache ActiveMQ进行JMS消息传递                           |
| spring-boot-starter-amqp                  | 使用Spring AMQP和Rabbit MQ的入门者                           |
| spring-boot-starter-aop                   | 使用Spring AOP和AspectJ进行面向方面编程的入门者              |
| spring-boot-starter-cache                 | 使用Spring Framework的缓存支持的初学者                       |
| spring-boot-starter-data-jdbc             | 使用Spring Data JDBC的入门者                                 |
| spring-boot-starter-data-mongodb          | 使用MongoDB面向文档的数据库和Spring Data MongoDB的初学者     |
| spring-boot-starter-data-mongodb-reactive | 使用MongoDB面向文档的数据库和Spring Data MongoDB Reactive的入门者 |
| spring-boot-starter-data-redis            | 在Spring Data Redis和Lettuce客户端上使用Redis键值数据存储的初学者 |
| spring-boot-starter-data-redis-reactive   | 使用带有Spring Data Redis被动的Redis键值数据存储和Lettuce客户端的入门者 |
| spring-boot-starter-quartz                | 使用Quartz调度程序的入门者                                   |
| spring-boot-starter-thymeleaf             | 使用Spring MVC构建Web（包括RESTful）应用程序的入门者。使用Tomcat作为默认嵌入式容器 |
| spring-boot-starter-jetty                 | 使用Jetty作为嵌入式servlet容器的入门。替代 spring-boot-starter-tomcat |
| spring-boot-starter-logging               | 使用Logback进行日志记录的入门。默认日志启动器                |
| spring-boot-starter-log4j2                | 使用Log4j2进行日志记录的入门，替代spring-boot-starter-logging |
| spring-boot-starter-tomcat                | 使用Tomcat作为嵌入式servlet容器的入门者                      |

