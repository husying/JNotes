# springcloud（二） 服务注册和发现Eureka



# Eureka简介

Eureka 是一个用于服务注册和发现的组件，Eureka 分为Eureka  Server（服务端） 和 Eureka Client（客户端）

Eureka 优点：

* 功能和性能非常稳定
* 可以与spring Cloud 无缝对接
* 能与其他组件相互配合，很容易实现服务注册，负载均衡，熔断和只能路由等功能，如：负载均衡组件Ribbon、熔断器组件Hystrix、熔断器监控组件Hystrix Dashboard组件、熔断器聚合监控Turbine组件、以及网关Zuul组件。这些组件都是Netfilx公司提供，统称为Netfilx OSS组件。Netfilx OSS组件由Spring Could整合为 Spring Could Netfilx ，是Spring Could架构微服务的核心组件，也是基础组件

# Eureka 基本架构

主要包括以下3个角色

* Register Service：服务注册中心，它是一个Eureka  Server  ，提供服务注册和发现功能
* Provider Service：服务提供者，它是一个Eureka  Client，提供服务
* Consumer Service：服务消费者，它是一个Eureka  Client，消费服务



**原理：**

* 首先需要一个服务注册中心Eureka  Server 
* 在服务启动时，服务提供者Eureka  Client 向服务注册中心Eureka  Server 注册，将自己的信息（比如服务名和服务IP地址等）通过REST API的形式提交给服务注册中心Eureka  Server 
* 服务消费者Eureka  Client 也向服务注册中心Eureka  Server ，同时获取一份服务注册列表的信息，该列表包含了所有向服务中心Eureka  Server 注册的服务信息。
* 服务消费者Eureka  Client获取注册列表信息后，服务消费者就知道了服务提供者的IP地址，可以通过Http 远程调用来消费服务提供者的服务



# Eureka 常见概念

**Register--服务注册**

当Eureka Client 向Eureka Server 注册时，Eureka Client 提供自身的元数据，比如IP地址、端口’运行状况指标的url、主页地址等信息



**Renew--服务续约**

当Eureka Client 在默认情况下**每隔30秒发送一次心跳**来进行服务续约，来表明该Eureka Client可以正常使用

如果，**Eureka Server 在90秒内没收到Eureka Client 的心跳，Eureka Server便会将Eureka Client 实例从注册列表中移除**。注意：官方建议不要更改服务续约的间隔时间



**Fetch Registries--获取注册列表**

Eureka Client从Eureka Server 获取服务注册列表信息，并将其缓存在本地。Eureka Client会使用服务注册列表信息查找其他服务的信息，从而进行远程调用。

Eureka Client通过适应JSON 和XML 数据格式与Eureka Server通信。默认使用JSON 格式获取服务注册列表信息



**Cancel --服务下线**

Eureka Client 在关闭时可以向Eureka  Service 发送下线请求，在发送请求后，该Eureka Client实例信息将从Eureka Server 的服务注册列表中删除。

该下线请求不能自动完成，需要在程序关闭时调用一下代码

```java
DiscoveryManager.getInstance().shutdownComponent();
```



**Evuction-- 服务剔除**

默认情况下，Eureka Server 在90秒内没收到Eureka Client 的心跳，Eureka Server便会将Eureka Client 实例从注册列表中移除





# 为什么Eureka Client获取服务实例这么慢

1. Eureka client 的注册延迟

   Eureka client 启动后不会立即注册，有个延迟时间，如果跟踪代码会发现延迟时间为40秒，源码在eureka-client-1.6.2.jar的DefaultEurekaClientConfig类中，代码如下：

   ```java
   public int getInitialInstanceInfoReplicationIntervalseconds(){
       return configInstance.getIntProperty(
       	namespace + INITIAL_REGISTRATION_REPLICATION_DELAT_KEY,40).get();
   }
   ```

   

2. Eureka Server 的响应缓存

   Eureka Server维护默认每30秒更新一次响应缓存，所以即使刚刚注册的实例，也不会立即出现在服务注册列表中

3. Eureka Client 的缓存

   Eureka Client 保留注册表信息的缓存，该缓存每30秒更一次，因此，Eureka Client 刷新本地缓存，并发现其他新注册的实例可能需要30秒

4. LoadBalancer 的缓存

   Ribbon 的负载平衡器从本地的Eureka Client 获取服务注册列表信息。Ribbon 本身还维护了缓存，以避免每个请求都需要从Eureka Client 获取服务注册列表。此缓存每30秒刷新一次，所以至少需要30秒才能使用新注册的实例



**综上因素，一个新注册的实例，默认延迟40秒才进行注册，因此不能立马被Eureka Server发现。另外，刚注册的Eureka Client因为调用方各种缓存没有及时获取到最新的服务注册列表信息。**





# Eureka 自我保护模式

当有一个新的Eureka Server 出现时，它会尝试从相邻的Peer 节点获取所有服务实例注册表信息。

如果相邻的Peer 节点获取信息时出现故障，Eureka Server 会尝试其他的Peer 节点，在成功获取所有的服务实例信息后，会根据配置信息设置服务续约的阀值。

如果，在任何时间Eureka Server 接收到的服务续约低于该值配置的百分比（默认15分钟内低于85%），则服务器开启自我保护模式，即不再剔除注册列表的信息。

这样的好处：如Eureka Server 自身网络问题导致Eureka Client 无法续约，Eureka Client 的注册表信息不再被删除，还可以被其他服务消费

默认Eureka Server  自我保护模式，如果需要关闭，需要如下配置：

```properties
eureka.server.enable-self-preservation=false
```



参考资料：《深入理解Spring Cloud与微服务构建》

