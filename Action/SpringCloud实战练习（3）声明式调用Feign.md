# 案例实践

创建module工程 eureka-client-feign

**pom文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.husy</groupId>
        <artifactId>springcloud-chapters</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <groupId>com.husy</groupId>
    <artifactId>eureka-client-feign</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-client-feign</name>
    <description>feign 服务消费者</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
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

**yml 文件**

```yml
spring:
  application:
    name: eureka-client-feign
server:
  port: 8202
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8001/eureka
```

**启动类**

```java
@EnableEurekaClient
@EnableFeignClients
@SpringBootApplication
public class EurekaClientFeignApplication {
   public static void main(String[] args) {
      SpringApplication.run(EurekaClientFeignApplication.class, args);
   }
}
```

**Feign Client 配置类**

```java
@Configuration
public class FeignConfig {
   @Bean
   public Retryer feignRertyer() {
      return new Retryer.Default(100, TimeUnit.SECONDS.toMillis(1), 5);
   }
}
```

**控制层/业务层**

```java
/**
 * @description: 业务接口
 */
public interface HiService {
   String sayHi(String name );
}

/**
 * @description: 业务实现
 */
@Service
public class HiServiceImpl implements HiService {
   @Resource
   EurekaClientFeign eurekaClientFeign;

   @Override
   public String sayHi(String name) {
      return eurekaClientFeign.sayHi(name);
   }
}
/**
 * @description: 控制器
 */
@RestController
public class HiController {
   @Autowired
   HiService hiService;

   @GetMapping("/hi")
   public String sayHi(@RequestParam(defaultValue = "husy",required = false)String name ){
      return hiService.sayHi(name);
   }
}
```

**启动测试**

这里我们启动eureka-server 工程，端口号为8001，在启动两个 eureka-cluster-client-producer 工程，端口分表8101和8102。在启动eureka-client-feign 工程，端口号为8202 

在浏览器上多次访问http://localhost:8202/hi?name=aaa，浏览器会轮流显示以下内容：

>   hi aaa,i am form port:8101 
>
>   hi aaa,i am form port:8102



为什么会出现负载均衡的效果呢？

我们查看 spring-cloud-starter-openfeign 依赖，发现其有 spring-cloud-starter-netflix-ribbon 依赖和 feign-hystrix 依赖