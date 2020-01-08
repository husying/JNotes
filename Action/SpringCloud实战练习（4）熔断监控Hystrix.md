---
typora-root-url: SpringCloud实战练习（4）熔断监控Hystrix
---

# 案例演练

## Feign实战

复制工程 eureka-client-feign 为 eureka-client-hystrix-feign 。 引入依赖 spring-cloud-starter-netflix-hystrix，如下：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```

修改eureka-client-hystrix-feign 工程中的 EurekaClientFeign 类，在 @FeignClient 注解的fallback 配置加上快速失败的处理类。具体如下：

```java
@FeignClient(value = "eureka-client-producer", configuration = FeignConfig.class)
public interface EurekaClientFeign {
   @GetMapping(value = "/hi")
   String sayHi(@RequestParam(name = "name") String name);
}
```

```java
/**
 * @description: 熔断器处理类
 * @author: husy
 * @date 2019/12/6
 */
@Component
public class HiHystrix implements EurekaClientFeign {
   @Override
   public String sayHi(String name) {
      return "hi," + name + ",sorry,error !!!";
   }
}
```



修改yml 文件，配置如下：

```yml
spring:
  application:
    name: eureka-client-hystrix
server:
  port: 8203
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8001/eureka
feign:
  hystrix:
    enabled: true
```

**启动类**

启动类增加 @EnableHystrix 注解

```java
@EnableHystrix
@EnableFeignClients
@EnableEurekaClient
@SpringBootApplication
public class EurekaClientHystrixFeignApplication {
   public static void main(String[] args) {
      SpringApplication.run(EurekaClientHystrixApplication.class, args);
   }
}
```



**启动测试**

依次启动eureka-server、eureka-client-producer、eureka-client-hystrix-feign，在浏览器上访问http://localhost:8203/hi?name=aaa，浏览器显示如下：

>   Hello aaa,There port is 8101

关闭工程eureka-client-producer，即它处于不可用状态，此时eureka-client-hystrix无法调用eureka-client-producer，再次在浏览器上访问http://localhost:8203/hi?name=aaa，浏览器显示如下：

>   hi,aaa,sorry,error !!!



## **RestTemplate** 实战

复制工程 eureka-client-ribbon 为 eureka-client-hystrix-ribbon  。 引入依赖 spring-cloud-starter-netflix-hystrix，如下





## Hystrix Dashboard

Hystrix Dashboard 是监控 Hystrix 的熔断器状况的 个组件，提供了数据监控和 友好的图形化展示界面。

Hystrix Dashboard 需要Actuator 的起依赖、 Hystrix Dashboard 的起步依赖和 Hystrix 起步依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
</dependency>
```

启动类上添加如下注解：

```java
@EnableHystrix
@EnableHystrixDashboard
```

**测试**

修改 eureka-client-hystrix 工程，重新启动，在浏览器上访问http://localhost:8203/hystrix ，浏览器显示的界面如下：

![img](clipboard-1578063450332.png)

在界面上依次填写http://localhost:8203/actuator/hystrix.stream  2000 aa（这个可 以随意填写）单击“ monitor ”，进入页面如下：

![img](clipboard-1578063450333.png)

**问题：**

这是 springboot 2.0 会出现的异常 Unable to connect to Command Metric Stream，因为springboot的默认路径不是 "/hystrix.stream"

**2种解决办法：**

1、在bootstrap.properties中添加“ management.endpoints.web.exposure.include = hystrix.stream”；

2、项目里配置上下面的servlet，如下：

```java
@Bean
public ServletRegistrationBean getServlet() {
    HystrixMetricsStreamServlet streamServlet = new HystrixMetricsStreamServlet();
    ServletRegistrationBean registrationBean = new ServletRegistrationBean(streamServlet);
    registrationBean.setLoadOnStartup(1);
    registrationBean.addUrlMappings("/hystrix.stream");
    registrationBean.setName("HystrixMetricsStreamServlet");
    return registrationBean;
}
```



重新刷新监控面板页面，如下

![img](clipboard.png)

上面是在Feign 中使用 Hystrix Dashboard，我们也可以在RestTemplate 中使用，修改方式同理。我们对eureka-client-ribbon进行修改，如下：新增Actuator 的起依赖、 Hystrix Dashboard 的起步依赖和 Hystrix 起步依赖。启动类添加 @EnableHystrix、@EnableHystrixDashboard注解



## Turbine聚合监控

在使用 Hystrix Dashboard 组件监控服务的熔断器状况时， 每个服务都有 Hystrix Dashboard 主页，当服务数量很多时，监控非常不方便。为了同时监控多个服务的熔断器的状况， Netflix 开源了 Hystrix 的另 个组件 Turbine Turbine 用于聚合多个 Hystrix Dashboard,将多个 Hystrix Dashboard 组件的数据放在 个页面上展示，进行集中监控。

这里我们创建模块，eureka-client-turbine，引入依赖如下：

**Pom 文件**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-turbine</artifactId>
</dependency>
```



**配置文件如下：**

```properties
server.port=8025
spring.application.name=eureka-client-turbine
# 指定聚合哪些集群，多个使用","分割，默认为default。可使用http://.../turbine.stream?cluster={clusterConfig之一}访问
turbine.aggregator.cluster-config=default
#表明监控哪些服务
turbine.app-config=eureka-client-hystrix-feign,eureka-client-hystrix-ribbon
turbine.cluster-name-expression=new String("default")
#这里和service-hi启动类里的 registrationBean.addUrlMappings("/hystrix.stream")一致，原因待探索
turbine.instanceUrlSuffix=/hystrix.stream
eureka.client.service-url.defaultZone=http://localhost:8001/eureka/
```

**注意：** turbine.instanceUrlSuffix=/hystrix.stream 这里一定要和监控服务的地址一致。否则会出现Unable to connect to Command Metric Stream 异常，仪表盘显示不了



**启动类如下**

```java
@SpringBootApplication
@EnableTurbine
@EnableHystrixDashboard
public class EurekaClientTurbineApplication {
   public static void main(String[] args) {
      SpringApplication.run(EurekaClientTurbineApplication.class, args);
   }
}
```

**测试：**

在浏览器上访问http://localhost:8025/hystrix，然后输入地址 [http://localhost:8025/turbine.stream ](http://localhost:8025/turbine.stream)，点击进入，页面如下：

![img](/clipboard-1578063830295.png)