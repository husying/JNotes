



# Zuul的作用

Zuul 作为路由网关组件，在微服务架构中有着非常重要的作用，主要体现在以下6个方面：

1.  Zuul 、Ribbon 以及 Eureka 相结合，可以实现智能路由和负载均衡的功能，Zuul 能够将请求流量按某种策略分发到集群状态的多个服务实例。
2.  网关将所有服务的 API 接口统一聚合，并统一对外暴露。外界系统调用 API 接口时，都是由网关对外暴露的API 接口，外界系统不需要知道微服务系统中各服务相互调用的复杂性。微服务系统中保护了其内部微服务单元的API 接口，防止其被外界直接调用，导致服务的敏感信息对外暴露。
3.  网关服务可以做用户身份认证和权限认证，防止非法请求操作 API接口，对服务器起到保护作用。
4.  网关可以实现监控功能，实时日志输出，对请求进行记录。
5.  网关可以用来实现流量监控，在高流量的情况下，对服务进行降级。
6.  API 接口从内部服务分离出来方便做测试。



# Zuul的工作原理

Zuul 是通过 Servlet 来实现的，Zuul 通过自定义的ZuulServlet（类似于 Spring MVC 的DispatcServlet 来实现的，采用的是异步阻塞模型，所以性能比 Ngnix 差）来对请求进行控制。

Zuul 的核心是系列过滤器，可以在Http请求的发起和响应返回期间执行一系列的过滤器。Zuul 包括以下4 种过滤器：

*   **PRE过滤器**：它是在请求路由到具体的服务之前执行的，这种类型的过滤器可以做安全验证，例如身份验证、 参数验证等。
*   **ROUTING 过滤器**：它用于将请求路由到具体的微服务 。在默认情况下，它使用Http Client 进行网络请求。
*   **POST 过滤器**：它是在请求己被路由到微服务后执行的般情况下，用作收集统计信息、指标，以及将响应传输到客户端
*   **ERROR 过滤器**：它是在其他过滤器发生错误时执行的

Zuul 采取了动态读取、编译和运行这些过滤器。过滤器之间不能直接相互通信，而是通过RequestContext 对象来共享数据，每个请求都会创建一个 RequestContext 对象。Zuul 过滤具有以下关键特性：

*   Type （类型）：Zuul过滤器的类型，这个类型决定了过滤器在请求的哪个阶段起作用，例如 Pre、Post 阶段等。
*   Execution Order （执行顺序） ：规定了过滤器的执行顺序，Order的值越小，越先执行
*   Criteria （标准）：Filter 执行所需的条件
*   Action （行动〉：如果符合执行条件，则执行 Action（即逻辑代码）



# Zuul请求的生命周期

当一个客户端 Request 请求进入Zuul 服务时，网关先进入“pre filter“ ，进行一系列的验证、操作或者判断。然后交给“routing filter” 进行路由转发，转发到具体的服务实例进行逻辑处理、返回数据。当具体的服务处理完后，最后由“post filter“，进行处理，该类型的处理器处理完之后，将 Response 信息返回给客户端。



# Zuul 的常见使用方式

由于Zuul 其他Netflix 组件可以相互配合、无缝集成Zuul很容易就能实现负载均衡、智能路由和熔断器等功能。在大多数情况下Zuul都是以集群的形式在的。由于Zuul 横向扩展能力非常好，所以当负载过高时，可以通过添加实例来解决性能瓶颈。

*   一种常见的使用方式是对不同的渠道使用不同的 Zuul 来进行路由，例如移动端共用Zuul 关实例；Web 端用另一个 Zuul网关实例，其他的客户端用另外 Zuul 实例进行路由
*   另一种常见的集群是通过Ngnix 和 Zuul 相互结合来做负载均衡。暴露在最外面的是Ngnix 主从双热备进行Keepalive, Ngnix 经过某种路由策略，将请求路由转发到 Zuul 集群上，Zuul 最终将请求分发到具体的服务上。架构图如图所示：

![](./SpringCloud实战练习（5）路由网关Zuul/clipboard.png)



# 案例实践

创建model工程 eureka-client-zuul ，引入依赖 eureka-client、 zuul、web 

**pom.xml**

```xml
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
    <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
</dependency>
```

**yml 文件**

```yml
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8001/eureka/
server:
  port: 8206
spring:
  application:
    name: eureka-client-zuul
zuul:
  routes:
    producer:
      path: /producer/**
      serviceId: eureka-client-producer
    feign:
      path: /feign/**
      serviceId: eureka-client-feign
    ribbon:
      path: /ribbon/**
      serviceId: eureka-client-ribbon
```

**启动类**

```java
@EnableEurekaClient
@EnableZuulProxy
@SpringBootApplication
public class EurekaClientZuulApplication {
   public static void main(String[] args) {
      SpringApplication.run(EurekaClientZuulApplication.class, args);
   }
}
```



**启动测试**

依次启动 eureka-server、eureka-cluster-client-producer（启动2个端口，8101、8102）、eureka-client-feign、eureka-client-ribbon、eureka-client-turbine

浏览器多次访问http://localhost:8206/client/hi?name=aaa ，会交替显示如下内容：

>   hi aaa,i am form port:8101 
>
>   hi aaa,i am form port:8102

浏览器多次访问 http://localhost:8206/feign/hi?name=aaa，http://localhost:8206/ribbon/hi?name=aaa，会出现同一结果



**在Zuul上配API接口的版本号**

只需压在配置文件增加如下配置

```properties
zuul.prefix=/v1
```

重启eureka-client-zuul 服务，在浏览上访问 http://localhost:8206/v1/client/hi?name=aaa，就会出现如下显示

>   hi aaa,i am form port:8101
>
>   hi aaa,i am form port:8102



# Zuul上配置熔断器

在Zuul实现熔断器功能需要实现 ZuulFallbackProvider 的接口，实现接口有两个方法

*   一个是getRoute()方法，用于指定熔断功能应用于哪些路由的服务
*   一个是方法fallbackResponseO为进入熔断功能时执行的逻辑

注意在Spring Cloud Finchley.RELEASE 版本中 ZuulFallbackProvider 已被删除并替换为FallbackProvider ，具体如下;

```java
package com.husy.eurekaclientzuul;

import org.springframework.cloud.netflix.zuul.filters.route.FallbackProvider;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * @description: TODO
 * @author: hsy
 * @date; 2019/12/17
 */
@Component
public class MyFallbackProvider implements FallbackProvider {
   @Override
   public String getRoute() {
      return "eureka-client-producer";
   }

   @Override
   public ClientHttpResponse fallbackResponse(String route, Throwable cause) {
      return new ClientHttpResponse() {
         @Override
         public HttpStatus getStatusCode() throws IOException {
            return HttpStatus.OK;
         }

         @Override
         public int getRawStatusCode() throws IOException {
            return 200;
         }

         @Override
         public String getStatusText() throws IOException {
            return "OK";
         }

         @Override
         public void close() {

         }

         @Override
         public InputStream getBody() throws IOException {
            return new ByteArrayInputStream("eureka-client-zuul: error!!!! i'm the fallback.".getBytes());
         }

         @Override
         public HttpHeaders getHeaders() {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            return headers;
         }
      };
   }
}
```

重启eureka-client-zuul 服务，并且关闭 eureka-client-producer 的两个实例，在浏览上访问 [http://localhost:8206/v1/client/hi?name=aaa](http://localhost:8206/client/hi?name=aaa)，就会出现如下显示

>   eureka-client-zuul: error!!!! i'm the fallback.

**在Zuul 中使用过滤器**

实现过滤器很简单，只需要继承ZuulFilter，并实现ZuulFilter中的抽象方法，如下：

*   **filterType**()：即过滤器的类型它有 种类型，分别是“pre”，“post”，“routing”和“error”
*   **filterOrder**()：过滤顺序，它为Int类型的值，值越小，越早执行该过滤器
*   IZuulFilter的**shouldFilter**()：表示该过滤器是否过滤逻辑，如果为true，则执行run（）方法：如果为false，则不执行run （）方法。
*   Object的**run**()：写具体的过滤的逻辑

在实际开发中，可以用此过滤器进行安全验证。这里以检查 参数中是否有token 。具体如下;

```java
@Component
public class MyFilter extends ZuulFilter {
   public static Logger log = LoggerFactory.getLogger(MyFilter.class);
   @Override
   public String filterType() {
      return FilterConstants.PRE_TYPE;
   }

   @Override
   public int filterOrder() {
      return 0;
   }

   @Override
   public boolean shouldFilter() {
      return true;
   }

   @Override
   public Object run() throws ZuulException {
      RequestContext ctx = RequestContext.getCurrentContext();
      HttpServletRequest request = ctx.getRequest();
      Object accessToken = request.getParameter("token");
      if (accessToken == null) {
         log.warn("token is empty");
         ctx.setSendZuulResponse(false);
         ctx.setResponseStatusCode(401);
         try {
            ctx.getResponse().getWriter().write("token is empty ");
         } catch (Exception e) {
            return null;
         }
      }
      log.info("ok");
      return null;
   }
}
```

重启eureka-client-zuul 服务，在浏览上访问 [http://localhost:8206/v1/client/hi?name=aaa](http://localhost:8206/client/hi?name=aaa)，就会出现如下显示

>   token is empty