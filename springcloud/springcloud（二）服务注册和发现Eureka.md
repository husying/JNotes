# Eureka简介

Eureka是Netflix开源的一款提供服务注册和发现的组件，它提供了完整的Service Registry和Service Discovery实现。也是springcloud体系中最重要最核心的组件之一。

Eureka 分为Eureka  Server（服务端） 和 Eureka Client（客户端）

Eureka 优点：

* 功能和性能非常稳定
* 可以与spring Cloud 无缝对接
* 能与其他组件相互配合，很容易实现服务注册，负载均衡，熔断和只能路由等功能，如：负载均衡组件Ribbon、熔断器组件Hystrix、熔断器监控组件Hystrix Dashboard组件、熔断器聚合监控Turbine组件、以及网关Zuul组件。这些组件都是Netfilx公司提供，统称为Netfilx OSS组件。Netfilx OSS组件由Spring Could整合为 Spring Could Netfilx ，是Spring Could架构微服务的核心组件，也是基础组件

# Eureka 基本架构

主要包括以下3个角色

* Register Service：服务注册中心，它是一个Eureka  Server  ，提供服务注册和发现功能
* Provider Service：服务提供者，它是一个Eureka  Client，将自身服务注册到Eureka，从而使服务消费方能够找到
* Consumer Service：服务消费者，它是一个Eureka  Client，从Eureka获取注册服务列表，从而能够消费服务



**原理：**

* 首先需要一个服务注册中心Eureka  Server 
* 在服务启动时，服务提供者Eureka  Client 向服务注册中心Eureka  Server 注册，将自己的信息（比如服务名和服务IP地址等）通过REST API的形式提交给服务注册中心Eureka  Server 
* 服务消费者Eureka  Client 也向服务注册中心Eureka  Server ，同时获取一份服务注册列表的信息，该列表包含了所有向服务中心Eureka  Server 注册的服务信息。
* 服务消费者Eureka  Client获取注册列表信息后，服务消费者就知道了服务提供者的IP地址，可以通过Http 远程调用来消费服务提供者的服务



![img](assets/eureka-architecture-overview.png)



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

1. **Eureka Server 的响应缓存**

   **Eureka Server维护默认每30秒更新一次响应缓存，所以即使刚刚注册的实例，也不会立即出现在服务注册列表中**

2. Eureka client 的注册延迟

   Eureka client 启动后不会立即注册，有个延迟时间，如果跟踪代码会发现延迟时间为40秒，源码在eureka-client-1.6.2.jar的DefaultEurekaClientConfig类中，代码如下：

   ```java
   public int getInitialInstanceInfoReplicationIntervalseconds(){
       return configInstance.getIntProperty(
       	namespace + INITIAL_REGISTRATION_REPLICATION_DELAT_KEY,40).get();
   }
   ```

   

3. Eureka Client 的缓存

   Eureka Client 保留注册表信息的缓存，该缓存每30秒更一次，因此，Eureka Client 刷新本地缓存，并发现其他新注册的实例可能需要30秒

4. LoadBalancer 的缓存

   Ribbon 的负载平衡器从本地的Eureka Client 获取服务注册列表信息。Ribbon 本身还维护了缓存，以避免每个请求都需要从Eureka Client 获取服务注册列表。此缓存每30秒刷新一次，所以至少需要30秒才能使用新注册的实例





# Eureka 自我保护模式

当有一个新的Eureka Server 出现时，它会尝试从相邻的Peer 节点获取所有服务实例注册表信息。

如果相邻的Peer 节点获取信息时出现故障，Eureka Server 会尝试其他的Peer 节点，在成功获取所有的服务实例信息后，会根据配置信息设置服务续约的阀值。

如果，在任何时间Eureka Server 接收到的服务续约低于该值配置的百分比（默认15分钟内低于85%），则服务器开启自我保护模式，即不再剔除注册列表的信息。

这样的好处：如Eureka Server 自身网络问题导致Eureka Client 无法续约，Eureka Client 的注册表信息不再被删除，还可以被其他服务消费

默认Eureka Server  自我保护模式，如果需要关闭，需要如下配置：

```properties
eureka.server.enable-self-preservation=false
```





# 案例实践

微服务一般采用 Maven 多 module 结构。所以我们需要创建一个maven主工程

结构如下：

> springcloud-chapters
>
> ​	|__eureka-server
>
> ​	|__eureka-client-producer



主工程项目springcloud-chapters的 pom 文件如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.husy</groupId>
    <artifactId>springcloud-chapters</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.9.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <properties>
        <java.version>1.8</java.version>
        <spring-cloud.version>Greenwich.SR3</spring-cloud.version>
    </properties>

    <modules>
        <!--注册中心-->
        <module>eureka-server</module>
        <!--服务提供者  单实例-->
        <module>eureka-client-producer</module>
    </modules>

    <dependencies>
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
    <repositories>
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
        </repository>
    </repositories>
</project>
```



## Eureka Server

**1、pom文件配置**

springcloud 已集成了Eureka 服务器，只需要引用`spring-cloud-starter-netflix-eureka-server` 依赖即可

。在很多博文和文章中都引用的是`spring-cloud-starter-eureka-server`，这里需要说明一下，`spring-cloud-starter-eureka-server`是之前的版本，官方推荐使用的是前者。

![1570677293649](assets/1570677293649.png)

![1570677396266](assets/1570677396266.png)



所以，我们pom 文件如下：

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

    <artifactId>eureka-server</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-server</name>
    <description>注册中心</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
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



**2、配置文件**

在默认设置下，该服务注册中心也会将自己作为客户端来尝试注册它自己，所以我们需要禁用它的客户端注册行为。

这里使用的是*application.yml*，如下：

```properties
server:
  port: 8761

eureka:
  instance:
    hostname: localhost
  client:
    # 表示是否将自己注册到Eureka Server，默认为true
    registerWithEureka: false
    # 表示是否从Eureka Server获取注册信息，默认为true。
    fetchRegistry: false
    serviceUrl:
      # 设置与Eureka Server交互的地址，查询服务和注册服务都需要依赖这个地址。
      # 默认是http://localhost:8761/eureka ；多个地址可使用 , 分隔。
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```



**3、启动类**

添加启动代码中添加`@EnableEurekaServer`注解

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
	public static void main(String[] args) {
		SpringApplication.run(EurekaServerApplication.class, args);
	}
}
```



ok，Eureka Server 初步搭建完成。启动工程后，访问：http://localhost:8761 ，可以看到下面的页面，其中还没有发现任何服务

![1570678280491](assets/1570678280491.png)



## Eureka Client

创建module工程 eureka-client-producer

**1、pom文件**

客户端需要引用`spring-cloud-starter-netflix-eureka-client`和`spring-boot-starter-web` 依赖

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
    <artifactId>eureka-client-producer</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-client-producer</name>
    <description>服务提供者</description>

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



**2、配置文件**

```properties
spring:
  application:
    name: eureka-client
server:
  port: 8762

eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka/
```



**3、 客户端代码**

```java
@RestController
public class HiController {
	@Value("${server.port}")
	String port;

	@RequestMapping("/hi")
	public String Hello(@RequestParam String name) {
		return "Hello " + name + ",There port is " + port;
	}
}
```

**4、启动类**

```java
@SpringBootApplication
@EnableEurekaClient
public class EurekaClientProducerApplication {
	public static void main(String[] args) {
		SpringApplication.run(EurekaClientProducerApplication.class, args);
	}
}
```



启用服务，启动后，我们重新访问服务端页面：http://localhost:8762/hi?name=husy，如下：

![1570680105311](assets/1570680105311.png)

我们可以看到有一个服务已经注册了。



## Eureka Cluster Server

在微服务项目中，Eureka Server 的作用举足轻重，如果单服务的话，遇到故障或毁灭性问题。那整个项目将停止运行。因此对Eureka 进行高可用集群是非常必要的



这里只介绍三台集群的配置情况，每台注册中心分别又指向其它两个节点即可，修改pom 文件。

**1、pom 文件**

```properties
---
spring:
  profiles: server1
server:
  port: 8761
eureka:
  instance:
    hostname: server1
  client:
    # 表示是否将自己注册到Eureka Server，默认为true
    registerWithEureka: false
    # 表示是否从Eureka Server获取注册信息，默认为true。
    fetchRegistry: false
    serviceUrl:
      # 设置与Eureka Server交互的地址，查询服务和注册服务都需要依赖这个地址。
      # 默认是http://localhost:8761/eureka ；多个地址可使用 , 分隔。
#      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      defaultZone: http://server1:8761/eureka/

---
spring:
  profiles: server2
server:
  port: 8762
eureka:
  instance:
    hostname: server2
  client:
    # 表示是否将自己注册到Eureka Server，默认为true
    registerWithEureka: false
    # 表示是否从Eureka Server获取注册信息，默认为true。
    fetchRegistry: false
    serviceUrl:
      # 设置与Eureka Server交互的地址，查询服务和注册服务都需要依赖这个地址。
      # 默认是http://localhost:8761/eureka ；多个地址可使用 , 分隔。
#      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      defaultZone: http://server2:8762/eureka/
```



本地搭建Eureka Server 集群，需要修改 host 文件，我的在C:\Windows\System32\drivers\etc目录下

在文件最后加上以下代码：

>127.0.0.1 peer1
>
>127.0.0.1 peer2



打包编译后，用 `java -jar` 启动 ，方式如下

> java -jar eureka-server-1.0-SNAPSHOT.jar --spring.profiles.active=peer1
> java -jar eureka-server-1.0-SNAPSHOT.jar --spring.profiles.active=peer2

依次启动完成后，浏览器输入：`http://localhost:8001/` 效果图如下：

![1570701599343](assets/1570701599343.png)



**注意：**

只启动 server1 后，报异常，如下：

![1570701415543](assets/1570701415543.png)

这正常现象，只要启动完3个服务后，就不会报错了。小伙伴们不要慌。



**Eureka Cluster Client**

修改 Eureka Client的配置文件，修改如下：

```properties
server:
  port: 8101
spring:
  application:
    name: eureka-client
eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8001/eureka/
```

启动项目，再次浏览器输入：`http://localhost:8001/` 

![1570701671090](assets/1570701671090.png)



[GitHub代码](https://github.com/HusyCoding/springcloud-example.git)


