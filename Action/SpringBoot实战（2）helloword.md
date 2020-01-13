这里演示如果使用 SpringBoot  写一个 hello word 

在主工程项目 springboot-chapters下创建模块项目 springboot-helloword 





# 依赖web模块

在pom.xml中添加web支持：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

使用idea 新建项目时，pom.xml 文件中会有两个默认模块：

* spring-boot-starter ：核心模块，包括自动配置支持、日志和 YAML，boot-starter。
* spring-boot-starter-test ：测试模块，包括 JUnit、Hamcrest、Mockito。



# pom文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.husy</groupId>
        <artifactId>springboot-chapters</artifactId>
        <version>1.0.0</version>
    </parent>
    <groupId>com.husy</groupId>
    <artifactId>springboot-helloword</artifactId>
    <version>1.0.0</version>
    <name>springboot-helloword</name>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
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





# 编写 Controller 内容

```java
@RestController
public class HelloController {
   @RequestMapping("hello")
   public String hello(){
      return "Hello World";
   }
}
```

我们通过`@RestController` 源码就会知道 `@RestController` 就是 `@Controller` + `@ResponseBody`；

`@RestController` 源码如下：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController {
    @AliasFor(
        annotation = Controller.class
    )
    String value() default "";
}
```

# 测试

**Main**

```java
@SpringBootApplication
public class SpringbootHellowordApplication {

   public static void main(String[] args) {
      SpringApplication.run(SpringbootHellowordApplication.class, args);
   }
}
```

@SpringBootApplication启用这三个功能，如：自动配置，组件扫描，并能够在其“应用程序类”上定义额外的配置

通过源码我们可以发现，@SpringBootApplication继承了如下 3 个注解

* @EnableAutoConfiguration：启用Spring Boot的自动配置机制
* @ComponentScan：启用@Component对应用程序所在的软件包的扫描（请参阅最佳实践）
* @Configuration：允许在上下文中注册额外的bean或导入其他配置类

启动项目：

除了使用工具，如IDEA 启动，还可以使用jar启动

> java -jar target / springboot-helloword-1.0.0.jar



浏览器访问  http://localhost:8080/hello  ，页面显示如下：

> Hello World



# 开发人员工具

Spring Boot包含一组额外的工具，这些工具可以使应用程序开发体验更加愉快。集成spring-boot-devtools后，只要类路径上的文件发生更改，使用的应用程序就会自动重新启动。

要想devtools支持，需添加如下依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```



[源码实现](https://github.com/HusyCoding/springboot-chapters.git)