# 熔断器监控Hystrix Dashboard



Hystrix的主要优点之一是它收集关于每个HystrixCommand的一套指标。Hystrix Dashboard可以有效的方式显示每个断路器的运行状况。

在使用 Hystrix Dashboard 组件监控服务的熔断器状况时， 每个服务都有 Hystrix Dashboard 主页，当服务数量很多时，监控非常不方便。

这时我们需要一个工具将这些服务的数据汇总到一起展示，于是就诞生了 Turbine

Turbine作为 Netflix 开源了 Hystrix 的组件 ， Turbine 用于聚合多个 Hystrix Dashboard，将多个 Hystrix Dashboard 组件的数据放在 个页面上展示，进行集中监控。





# 案例演练

## Hystrix Dashboard

Hystrix Dashboard 需要依赖`spring-cloud-starter-netflix-hystrix-dashboard` 和 `spring-boot-starter-actuator`



这里使用上章的项目springcloud-eureka-feign

修改eureka-feign-client的pom文件，添加依赖，如下：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

```

**启动类**

添加注解`@EnableHystrixDashboard`

```java
@SpringBootApplication
@EnableFeignClients
@EnableEurekaClient
@EnableHystrix
@EnableHystrixDashboard
public class EurekaFeignClientApplication {
	public static void main(String[] args) {
		SpringApplication.run(EurekaFeignClientApplication.class, args);
	}
}
```



启动项目，浏览器输入 http://localhost:8300/hystrix，浏览器展示如下

![1571370881898](assets/1571370881898.png)

通过页面可以如果查看默认集群使用第一个url；查看指定集群使用第二个url；单个应用的监控使用最后一个

这里我们单个应用颜色，在输入框输入 http://localhost:8300/hystrix.stream 输入之后点击 monitor，进入页面，如图

![1571371202312](assets/1571371202312.png)

我们发现，出现了Unable to connect to Command Metric Stream错误，

不要慌，如果你的springboot 版本和我一样也是2.0则需要添加 ServletRegistrationBean 因为springboot的默认路径不是 "/hystrix.stream"

如下：

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



重启，刷新浏览器，显示页面如下：

![1571377273728](assets/1571377273728.png)

然后我们请求服务接口http://localhost:8300/hi?name=aaaa，

![1571377338115](assets/1571377338115.png)



## Turbine

继续在该项目上进行改造，我们增加一个module工程，取名为eureka-monitor-client

**GitHub源码** https://github.com/HusyCoding/springcloud-example.git

