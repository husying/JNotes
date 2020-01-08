# Zuul 简介

Zuul 作为路由网关组件，主要有以下特点：

* Zuul、Ribbon以及Eureka 相结合，可以实现智能路由和负载均衡的功能，Zuul能将请求流量按某种策略分发到集群状态的多个服务实例。
* 网关将所有服务的 API 接口统 聚合，并统 对外暴露
* 网关服务可以做用户身份认证和权限认证，防止非法请求操作 PI 接口，对服务器起到保护作用。
* 网关可以实现监控功能，实时日志输出，对请求进行记录。
* 网关可以用来实现流量监控 在高流量的情况下，对服务进行降级。
* API 接口从内部服务分离出来 方便做测试。

## 工作原理

Zuul 是通过 Servlet 来实现的， Zuul 通过自定义的 Zuu!Servlet （类似于 Spring MVC 的DispatcServlet ）来对请求进行控制。 Zuul 的核心一系列过滤器，可以在 Http 请求的发起和 响应返回期间执行 系列的过滤器。Zuul 采取了动态读取、编译和运行这些过滤器 过滤器 间不能直接通信，而是通 RequestContext 对象来共享数据 每个请求都会创建 一个RequestContext 对象

Zuul 包括以下 种过滤器：

* PRE 过滤器 它是在请求路由到具体的服务之前执行的，这种类型的过滤器可 以做 安全验证，例如身份验证、 参数验证等。
* ROUTING 过滤器 它用于将请求路由到具体的微服务 。在默认情况下，它使用 Http Client 进行网络请求。
* POST 过滤器：它是在请求己被路由到微服务后执行的 般情况下，用作收集统计 信息、指标，以及将响 传输到客户端
* ERROR 过滤器：它是在其他过滤器发生错误时执行的



ZuulServlet Zuul 的核心 Servi et ZuulServlet 的作用是初始化 ZuulFilter 并编排这ZuulFilter 的执行顺序。

＠EnableZuulProxy