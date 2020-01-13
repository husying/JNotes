SpringBoot 的核心文件为 application.properties，又可以命名为application.yml，所有的与springboot集成框架等的配置属性都可以在它里面配置。

在主工程项目 springboot-chapters下创建模块项目 springboot-profiles



# 演练

在主工程项目 springboot-chapters下创建模块项目 springboot-profiles

## **pom**

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
    <artifactId>springboot-profiles</artifactId>
    <version>1.0.0</version>
    <name>springboot-profiles</name>

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



## **配置文件风格**

Spring Boot 支持 2 种配置方式，properties 和 yml 文件风格，默认使用properties ，以下选一种即可

**application.properties风格**

```properties
my.name=战三
my.sex=F
my.age=18
```

**application.yml风格**

```yml
my:
  name: 战三
  sex: F
  age: 18
```



# 获取配置文件方式

* 通过 `@Value`注解取值

* 通过Environment取值

* 通过将配置文件装配到实体类

    

## **@Value 取值**

```java
@SpringBootTest
class SpringbootProfilesApplicationTests {
   @Value("${my.name}")
   String name;
   String sqldb;
   @Value("${my.sex}")
   String sex;
   @Value("${my.age}")
   Integer age;

   @Test
   void contextLoads() {
      System.out.println(name);
      System.out.println(sex);
      System.out.println(age);
   }

}
```

**properties取值乱码问题**

注意，当我们从 application.properties 获取中文是，可能发生乱码，

**解决方案：**

1、IntelliJ IDEA 开发工具如下：

> 设置 File Encodings的Transparent native-to-ascii conversion为true，具体步骤如下：依次点击
>
> File -> Settings -> Editor -> File Encodings
>
> 将Properties Files (*.properties)下的Default encoding for properties files设置为UTF-8，将Transparent native-to-ascii conversion前的勾选上。
>
> 配置完成后一定要重新新建一个application.properties 

2、在yml文件中进行配置，不会发生乱码



**@Value注解失效问题**

该方式有个不好的地方，就是在使用时，需要注意@Value注解是否生效的问题。一般使用有以下注意事项

* 不能作用于静态变量（static）
* 不能作用于常量（final）
* 不能在非注册的类中使用（类需要被注册在spring上下文中，如用@Service,@RestController,@Component等）
* 使用这个类时，只能通过依赖注入的方式，用new的方式是不会自动注入这些配置的

为什么呢？ 我们可以通过Spring在初始化Bean的过程了解

![img](SpringBoot实战（3）读取配置文件/2126b210ec2.webp)

解释一下：

1. 读取定义
2. Bean Factory Post Processing
3. 实例化
4. 属性注入
5. Bean Post Processing

这个问题的原因就很明显了。@Value注入是在第四步，而初始化变量是在第三部，这个使用变量还没有被注入，自然为null了。



## **Environment取值**

org.springframework.core.env.Environment是当前应用运行环境的公开接口，主要包括应用程序运行环境的两个关键方面：配置文件(profiles)和属性。Environment继承自接口PropertyResolver，而PropertyResolver提供了属性访问的相关方法。

代码实现如下：

```java
@Autowired
private Environment environment;
@Test
void contextLoads2() {
   System.out.println(environment.getProperty("my.name"));
   System.out.println(environment.getProperty("my.sex"));
   System.out.println(environment.getProperty("my.age"));
}
```



**配置文件装配到实体类**

当有读取很多配置属性时，如果逐个读取属性会非常麻烦，通常会把这些属性作为一个变量名来创建一个JavaBean 的变量

可通过注解@ConfigurationProperties获取配置文件中的指定值并注入到实体类中



**代码实现：**

配置类：

```java
@Component
@ConfigurationProperties(prefix = "my")
public class ConfigBean {
   String name;
   String sex;
   Integer age;

    // 省略getter，setter，toString方法
}
```

测试

```java
@Autowired
ConfigBean configBean;

@Test
void contextLoads3() {
   System.out.println(configBean.getName());
   System.out.println(configBean.getSex());
   System.out.println(configBean.getAge());
}
```



# **读取自定义文件**

我们可以通过@PropertySource指定读取的配置文件，如下：

在实际开发过程中，可能有多个不同的环境配置文件，Spring Boot 支持启动时在配置文件application.yml中指定环境的配置环境，配置文件格式为application-{profile}.properties，其中{profile}对应环境标识，

例如：

> application-test.properties     测试环境
> application-dev.properties     开发环境
> application-prod.properties   生产环境

如何指定使用哪个环境配置文件，只需要配置上 spring.Profiles.active，该配置标识系统将采用哪个profiles。

如下：

```properties
spring.profiles.acitve=dev
```

当然我们也可以通过  java -jar 这种方式启动程序，并指定程序的配置文件，启动命令如下：

> java -jar springboot-profiles-1.0.0.jar --spring.profiles.acitve=dev





[源码实现](https://github.com/HusyCoding/springboot-chapters.git)