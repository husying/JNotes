在上章节中有谈到使用 RestTemplate 来消费服务。这章主要介绍一下 使用 Feign 来远程调度其他服务。 



[Feign](https://github.com/Netflix/feign)是一个声明式的Web服务客户端。这使得Web服务客户端的写入更加方便 要使用Feign创建一个界面并对其进行注释。它具有可插入注释支持，包括Feign注释和JAX-RS注释。Feign还支持可插拔编码器和解码器。Spring Cloud增加了对Spring MVC注释的支持，并使用Spring Web中默认使用的`HttpMessageConverters`。Spring Cloud集成Ribbon和Eureka以在使用Feign时提供负载均衡的http客户端。



现在我们搭建一个简单的服务端注册服务，客户端去调用服务使用的案例，在上章的工程中进行改造。

# 案例实践

创建module工程 eureka-feign-client

在pom 文件中我们需要引入`spring-cloud-starter-openfeign`包

**1、pom文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>com.husy</groupId>
        <artifactId>springcloud-eureka-feign</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>eureka-feign-client</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
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

```properties
spring:
  application:
    name: eureka-feign-client
server:
  port: 8300

eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8001/eureka/

```

**2、启动类**

```java
@SpringBootApplication
@EnableFeignClients
@EnableEurekaClient
public class EurekaFeignClientApplication {
	public static void main(String[] args) {
		SpringApplication.run(EurekaFeignClientApplication.class, args);
	}
}

```

- `@EnableDiscoveryClient` :启用服务注册与发现
- `@EnableFeignClients`：启用feign进行远程调用



**3、feign 调用**

```java
@FeignClient(value = "eureka-client",configuration = FeignConfig.class)
public interface FeignService {

	@GetMapping("/hi")
	String sayHi(@RequestParam(value = "name") String name );
}


@Configuration
public class FeignConfig {
	@Bean
	public Retryer feignRertyer(){
		return new Retryer.Default(100, TimeUnit.SECONDS.toMillis(1L),5);
	}
}

```

在接口 FeignService 上加＠FeignClient 注解来声明一个 FeignClient，其中 value 远程调用其他服务的服务名（及spring.application.name配置的名称），此类中的方法和远程服务中contoller中的方法名和参数需保持一致。



FeignConfig.class 为 FeignClient 的配置类，在FeignConfig 类加上＠Configuration 注解，表明该类是 个配置类，并注入一个 BeanName 为 feignRetryer的 Retryer 的Bean 。注入该 Bean 之后， Feign 在远程调用失败后会进行重试。 



**4、WEB层调用**

将FeignService 注入到controller层，像普通方法一样去调用即可

```java
@RestController
public class HiController {
	@Autowired
	FeignService feignService;

	@GetMapping("/hi")
	public String sayHi(@RequestParam(defaultValue = "forezp",required = false) String name){
		return feignService.sayHi(name);
	}
}
```



测试

依次启动eureka-server工程，端口号8001、启动2个eureka-client工程，端口号为8101和8102、在启动eureka-feign-client工程，端口号8300.

在浏览器上多次访 http: // localhost:8300/hi， 浏览器会轮流显示以下内容

> hi forezp,i am form port:8101
>
> hi forezp,i am form port:8102

由此可见， Feign Client 程调用了 eureka-client 服务（存在端口为 8101和8102两个实例）的“/hi” API 接口， Feign Client 有负载均衡的能力。





GitHub源码：https://github.com/HusyCoding/springcloud-example.git