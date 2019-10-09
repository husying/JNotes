# springcloud（三）负载均衡Ribbon



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



