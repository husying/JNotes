# Ribbon 简介

Ribbon是Netflix发布的负载均衡器，它有助于控制HTTP和TCP的客户端的行为。为Ribbon配置服务提供者地址后，Ribbon就可基于某种负载均衡算法，自动地帮助服务消费者去请求。Ribbon默认为我们提供了很多负载均衡算法，例如轮询、随机等。当然，我们也可为Ribbon实现自定义的负载均衡算法。



负载均衡是指将负载分摊到多个执行单元上，常见两种负载均衡方式：

1. 独立进程单元，通过负载均衡策略，将请求转发到不同的执行单元上，例如Ngnix
2. 将负载均衡逻辑以代码封装到服务消费者的客户端，因为客户端有一份服务信息列表，所以可以通过负载均衡策略将请求分摊给多个服务提供者，以达到负载均衡的目的，Ribbon  属于上该种方式



在Spring Cloud 微服务中，Ribbon 是用作服务消费者的负载均衡器存在。有两种使用方式：

1. 与RestTemplate结合
2. 与Feign结合，Feign 默认集成Ribbon



负载均衡有好几种实现策略，常见的有：

1. 随机 (Random)
2. 轮询 (RoundRobin)
3. 一致性哈希 (ConsistentHash)
4. 哈希 (Hash)
5. 加权（Weighted）



# RestTemplate 简介

RestTemplate 是Spring Resource 中一个访问第三方RESTful API 接口的网络请求框架。使用来消费REST 服务的。

RestTemplate 类 的主要方法有headForHeaders()、getForHeaders()、postForHeaders()、get()、delete()、 分别对应HEAD\GET\POST\PUT\DELETE\OPTIONS等方法

RestTemplate 支持Xml 、JSON数据格式、默认实现序列化，可以将JSON 字符串自动转换为实体







# 案例实践

创建多模块项目springcloud-eureka-ribbon， 该项目在springcloud-eureka 项目上，增加eureka-ribbon-client 模块。项目结构如下

> springcloud-eureka-ribbon
>
> |__eureka-server   注册中心服务
>
> |__eureka-client   服务提供者
>
> |__eureka-ribbon-client  负载均衡客户端



修改 eureka-client 模块的配置文件application.yml，如下：

```properties
---
spring:
  profiles: client1
  application:
    name: eureka-client
server:
  port: 8101

eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8001/eureka/
---
spring:
  profiles: client2
  application:
    name: eureka-client
server:
  port: 8102

eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8001/eureka/

```



**eureka-ribbon-client**

新建子模块`eureka-ribbon-client`，引用依赖`spring-cloud-starter-netflix-ribbon`，具体如下

**1、pom.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.9.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.husy</groupId>
    <artifactId>eureka-ribbon-client</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-ribbon-client</name>
    <description>Demo project for Spring Boot</description>

    <properties>
        <java.version>1.8</java.version>
        <spring-cloud.version>Greenwich.SR3</spring-cloud.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

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



**配置文件 application.yml**

```properties
server:
  port: 8200

eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8001/eureka/
spring:
  application:
    name: eureka-ribbon-client
```



启动类加上注解`@EnableEurekaClient`，开启Eureka Client 功能，然后在向增加一个restTemplate的Bean，并使用`@LoadBalanced`开启负载均衡功能，具体如下：

```java
@SpringBootApplication
@EnableEurekaClient
public class EurekaRibbonClientApplication {

	@LoadBalanced
	@Bean
	RestTemplate restTemplate() {
		return new RestTemplate();
	}

	public static void main(String[] args) {
		SpringApplication.run(EurekaRibbonClientApplication.class, args);
	}

}

```



创建RibbonController 类

```java
package com.husy.eurekaribbonclient;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * @Description: TODO
 * @Author: husy
 */

@RestController
public class RibbonController {
	@Autowired
	private RestTemplate restTemplate;

	@GetMapping("/hi")
	public String hi(@RequestParam(required = false,defaultValue = "husy")String name ){
		return restTemplate.getForObject("http://eureka-client/hi?name="+name, String.class);
	}

}

```





启动工程项目，在浏览器多次访问http://localhost:8200/hi?name=adafsd 时，在负载均衡器作用下，浏览器会轮流显示如下内容：

> hi adafsd,i am form port:8102
>
> hi adafsd,i am form port:8101



## LoadBalancerClient 简介

负载均衡器的核心类为 LoadBalancerClient ，它可以从Eureka Client 中获取服务注册列表信息，并将该信息缓存；在调用choose()方法时，会根据负载均衡策略选择一个服务实例的信息，从而进行负载均衡

如，在controller类中添加如下代码：

```java
@Autowired
private LoadBalancerClient loadBalancerClient;

@GetMapping("/testInstance")
public String testInstance() {
ServiceInstance serviceInstance = this.loadBalancerClient.choose("eureka-client");
// 打印当前选择的是哪个节点
return "节点打印-->>"+ serviceInstance.getServiceId()+":"+ serviceInstance.getHost()+":"+ serviceInstance.getPort();
}

```



重启项目，在浏览器多次访问http://localhost:8200/testInstance 时，在负载均衡器作用下，浏览器会轮流显示如下内容：

> 节点打印-->>eureka-client:localhost:8101
>
> 节点打印-->>eureka-client:localhost:8102

由此可见，loadBalancerClient.choose("eureka-client") 客户轮流获取eureka-client 的服务实例

注意：禁用如果Ribbon 从Eureka获取注册列表，则需要自己去维护一份服务注册列表信息，有兴趣的朋友可以试试







[GitHub代码](https://github.com/HusyCoding/springcloud-example.git)