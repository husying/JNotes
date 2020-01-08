## 案例实践

在springcloud-chapters 项目中新建module工程  eureka-client-ribbon ，其作为服务消费者，通过 RestTemplate 来远程调用 eureka-client 服务 API 接口的“/hi”，即消费服务。该工程需要引用依赖spring-cloud-starter-netflix-ribbon 和 spring-boot-starter-web 依赖

**pom 文件**

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
    <artifactId>eureka-client-ribbon</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-client-ribbon</name>
    <description>负载均衡客户端</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
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

**yml文件**

```yml
server:
  port: 8201
spring:
  application:
    name: eureka-ribbon-client
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8001/eureka/
```

**启动类**

```java
@EnableEurekaClient
@SpringBootApplication
public class EurekaClientRibbonApplication {
   public static void main(String[] args) {
      SpringApplication.run(EurekaClientRibbonApplication.class, args);
   }
}
```

**控制器与服务层**

```java
@RestController
public class RibbonController {
   @Autowired
   LoadBalancerClient loadBalancerClient;
   @Autowired
   private RibbonService ribbonService;

   @GetMapping("/hi")
   public String hi(@RequestParam(required = false, defaultValue = "husy") String name) {
      return ribbonService.hi(name);
   }

   @GetMapping("/testInstance")
   public String testInstance() {
      ServiceInstance serviceInstance = this.loadBalancerClient.choose("eureka-client");
      // 打印当前选择的是哪个节点
      return "节点打印-->>"+ serviceInstance.getServiceId()+":"+ serviceInstance.getHost()+":"+ serviceInstance.getPort();
   }
}
```

```java
public interface RibbonService {
   String hi(String name);
}

@Service
public class RibbonServiceImpl implements RibbonService {
   @Autowired
   RestTemplate restTemplate;

   @Override
   @GetMapping("/hi")
   public String hi(@RequestParam(required = false, defaultValue = "husy") String name) {
      return restTemplate.getForObject("http://eureka-client/hi?name=" + name, String.class);
   }
}
```



**启动测试**

启动 eureka-cluster-server（或者eureka-server） 服务器，再启用eureka-cluster-client 服务提供者，然后在启动 eureka-client-ribbon 服务消费者。

多次访问浏览器 http://localhost:8201/hi?name=aaa ，浏览器会轮流显示如下内容：

>   hi aaa,i am form port:8101 
>
>   hi aaa,i am form port:8102

多次访问浏览器 http://localhost:8201/testInstance ，浏览器会轮流显示如下内容：

>   节点打印-->>eureka-client:localhost:8101 
>
>   节点打印-->>eureka-client:localhost:8102



**这说明负载均衡器起了作用，负载均衡器会轮流地请求eureka-cluster-client 两个实例中的“ API 接口。**