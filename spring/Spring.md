

# Spring

**Spring是一个轻量级的IoC和AOP容器框架**。是为Java应用程序提供基础性服务的一套框架，目的是用于简化企业应用程序的开发，它使得开发者只需要关心业务需求。

**Spring 的优势**

*   **低侵入 / 低耦合** （降低组件之间的耦合度，实现软件各层之间的解耦）
*   **支持声明式事务管理**（基于切面和惯例）
*   **方便集成其他框架**（如MyBatis、Hibernate）
*   **降低 Java 开发难度**



![2019-06-08_113939](assets/2019-06-08_113939.png)

Context 模块构建与核心模块之上，扩展了BeanFactory的 功能。`ApplicationContext` 是Context 模块的核心接口。



# 一、IOC容器

**控制反转（IoC) ：对象的创建交给外部容器完成**，IoC也称为依赖注入（DI），主要负责依赖类之间的创建、拼接、管理、获取等工作。`BeanFactory`接口 是Spring 框架的核心接口。

**依赖注入（DI）**：是一个过程，**由容器动态的将某个依赖关系注入到组件之中**，这个过程基本上是bean本身的反向（因此名称，控制反转）



Spring框架的IoC容器的基础在`org.springframework.beans`和`org.springframework.context`包

*   `BeanFactory`接口提供了一种能够管理任何类型对象的高级配置机制。 

*   `ApplicationContext`是`BeanFactory`子接口，接口代表Spring IoC容器，负责实例化，配置和组装bean





## 1、Spring Bean

### 1> Bean 实例化方式

*   构造函数实例化
*   静态工厂方法实例化
*   实例工厂方法实例化

**构造函数实例化**

```xml
<bean id="exampleBean" class="examples.ExampleBean"/>
```

**静态工厂方法实例化**

```xml
<bean id="clientService" class="examples.ClientService" factory-method="createInstance"/>
```

```java
public class ClientService {
    private static ClientService clientService = new ClientService();
    private ClientService() {}
    public static ClientService createInstance() {
        return clientService;
    }
}
```

**实例工厂方法实例化**

```xml
<!-- the factory bean, which contains a method called createInstance() -->
<bean id="serviceLocator" class="examples.DefaultServiceLocator">
    <!-- inject any dependencies required by this locator bean -->
</bean>

<!-- the bean to be created via the factory bean -->
<bean id="clientService"
    factory-bean="serviceLocator"
    factory-method="createClientServiceInstance"/>
```

```java
public class DefaultServiceLocator {
    private static ClientService clientService = new ClientServiceImpl();
    public ClientService createClientServiceInstance() {
        return clientService;
    }
}
```



**Bean 设置别名**

```java
<alias name="myApp-dataSource" alias="subsystemA-dataSource"/>
```

注解方式使用`@Bean`可以使用注释来提供别名



**实例化与使用**

基于XML的配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">
    <!-- 服务层对象 -->
	<bean id="petStore" class="org.springframework.samples.jpetstore.services.PetStoreServiceImpl">
        <property name="accountDao" ref="accountDao"/>
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>
    <!-- 数据访问对象 -->
    <bean id="accountDao"
        class="org.springframework.samples.jpetstore.dao.jpa.JpaAccountDao">
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions go here -->
</beans>
```

容器实例化与使用

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
PetStoreService service = context.getBean("petStore", PetStoreService.class);
List<String> userList = service.getUsernameList();
```



### 2> Bean 的标签属性

*   懒加载：由 `lazy-init`属性控制
*   作用域：由 `scope ` 属性控制
*   初始化：`init-method`
*   销毁：`destroy-method`



**scope 属性值**可以为 ：

*   **singleton**：定义bean的范围为每个spring容器一个实例(默认值)；
*   **prototype**：定义bean可以被多次实例化(使用一次就创建一次)；
*   **request**：定义bean的范围单个HTTP请求的生命周期；
*   **session**：定义 bean的范围是HTTP的生命周期Session；
*   **application**：定义bean的范围是ServletContext 的生命周期。
*   **websocket**：定义bean的范围是 WebSocket 的生命周期



### 3> Bean 的配置方式

*   **基于XML配置**：当Bean的实现类来源于第三方类库，比如DataSource、HibernateTemplate等，无法在类中标注注解信息，只能通过XML进行配置；而且命名空间的配置，比如aop、context等，也只能采用基于XML的配置。

*   **基于注解配置**：
    *   组件注解：`@Component`、`@Controller`、`@Service`、`@Repository`
    *   使用容器注解：`@Configuration`、`@Bean`，此种方式可再代码中通过反射方式获取实例



```java
<bean id="helloWorld" class="com.itheima.spring.helloword.Helloword"></bean>

ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
Helloword helloword = (Helloword) context.getBean("helloWorld3");


@Configuration
public class Config {
  @Bean
  public MyService myService() {
      return new MyServiceImpl();
  }
}
ApplicationContext ctx = new AnnotationConfigApplicationContext(Config.class);
MyService myService = ctx.getBean(MyService.class);
```



`@Repository`，`@Service`和，`@Controller`是`@Component`更具体的用例的专业化（分别在持久性，服务和表示层）

`@Component`是任何Spring管理组件的通用构造型

`@RestController`是Spring MVC 的注释，由`@Controller`和 组成`@ResponseBody`。

## 2、依赖注入(DI)

**3种注入方式**：

*   **构造器注入：推荐**。因为它允许您将应用程序组件实现为不可变对象，并确保所需的依赖项不是`null`
*   **Setter注入**：仅用于在类中指定合理默认值的可选依赖项。否则，必须在代码使用依赖项的任何位置执行非空检查。setter注入的一个好处，可使类的对象二次注入
*   **注解注入**。



### 1> 构造器注入

bean定义中定义构造函数参数的顺序是在实例化bean时将这些参数提供给适当的构造函数的顺序

`<constructor-arg/>` 元素中显式指定构造函数参数索引或类型

*   使用`ref` 属性指定构造函数参数引用另一个bean时
*   使用`type`属性指定构造函数参数的类型，则容器可以使用与简单类型的类型匹配  
*   使用`index`属性构造函数参数的索引
*   使用`name`属性指定构造函数参数名称
*   使用注解 `@ConstructorProperties`
*   使用 c 命名空间方式

**使用`ref` 属**

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg ref="beanTwo"/>
    <constructor-arg ref="beanThree"/>
</bean>

<bean id="beanTwo" class="x.y.ThingTwo"/>
<bean id="beanThree" class="x.y.ThingThree"/>
```

```java
package examples;
public class ExampleBean {
   public ThingOne(ThingTwo thingTwo, ThingThree thingThree) {
   }
}
```

**使用`type`属性**

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg type="int" value="7500000"/>
    <constructor-arg type="java.lang.String" value="42"/>
</bean>
```

  

```java
package examples;
public class ExampleBean {
    private int years;
    private String ultimateAnswer;

    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

**使用`index`属性**：该指数从0开始。

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg index="0" value="7500000"/>
    <constructor-arg index="1" value="42"/>
</bean>
```

**使用`name`属性**

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg name="years" value="7500000"/>
    <constructor-arg name="ultimateAnswer" value="42"/>
</bean>
```



**注解引入 @ConstructorProperties**

```java
package examples;

public class ExampleBean {

    // Fields omitted

    @ConstructorProperties({"years", "ultimateAnswer"})
    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```



**c 命名空间方式:**

需要在Schema引入  xmlns:c="http://www.springframework.org/schema/c"

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:c="http://www.springframework.org/schema/c"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="beanTwo" class="x.y.ThingTwo"/>
    <bean id="beanThree" class="x.y.ThingThree"/>

    <!-- traditional declaration with optional argument names -->
    <bean id="beanOne" class="x.y.ThingOne">
        <constructor-arg name="thingTwo" ref="beanTwo"/>
        <constructor-arg name="thingThree" ref="beanThree"/>
        <constructor-arg name="email" value="something@somewhere.com"/>
    </bean>

    <!-- c-namespace declaration with argument names -->
    <bean id="beanOne" class="x.y.ThingOne" c:thingTwo-ref="beanTwo"
        c:thingThree-ref="beanThree" c:email="something@somewhere.com"/>

</beans>
```

 



### 2> Setter 注入

`<property/>`元素指定属性或构造器参数

```java 
public class ExampleBean {
    private AnotherBean beanOne;
    private YetAnotherBean beanTwo;
    private int i;

    public void setBeanOne(AnotherBean beanOne) { this.beanOne = beanOne;  }
    public void setBeanTwo(YetAnotherBean beanTwo) { this.beanTwo = beanTwo;  }
    public void setIntegerProperty(int i) { this.i = i; }
}
```

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <property name="beanOne">  <ref bean="anotherExampleBean"/>   </property>
    <property name="beanTwo" ref="yetAnotherBean"/>
    <property name="integerProperty" value="1"/>
</bean>

<bean id="anotherExampleBean" class="examples.AnotherBean"/>
<bean id="yetAnotherBean" class="examples.YetAnotherBean"/>
```



**以下示例使用 p命名空间 进行更简洁的XML配置：**

需要  xmlns:p="http://www.springframework.org/schema/p" 的引入

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource"
        destroy-method="close"
        p:driverClassName="com.mysql.jdbc.Driver"
        p:url="jdbc:mysql://localhost:3306/mydb"
        p:username="root"
        p:password="masterkaoli"/>

</beans>
前面的XML更
```



### 3> 方法注入

假设单例bean A需要使用非单例（原型）bean B，可能是在A上的每个方法调用上。容器只创建一次单例bean A，因此只有一次机会来设置属性。每次需要时，容器都不能为bean A提供bean B的新实例。

解决方案是放弃一些控制反转，通过实现`ApplicationContextAware`接口

```java
public class CommandManager implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    public Object process(Map commandState) {
        Command command = createCommand();
        command.setState(commandState);
        return command.execute();
    }

    protected Command createCommand() {
        return this.applicationContext.getBean("command", Command.class);
    }

    public void setApplicationContext(
            ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
```



### 4> 循环注入

bean A和bean B之间的循环依赖强制其中一个bean在完全初始化之前被注入另一个bean（一个经典的鸡与蛋的场景）。

*   循环依赖就是循环引用，就是两个或多个Bean相互之间的持有对方
*   构造器循环依赖 ：只能抛出BeanCurrentlyInCreationException异常表示循环依赖。 
*   setter方法循环注入：分单例（scope=“singleton”）和非单例模式（scope=“prototype”）的情况
    *   多例模式： 因为prototype作用域的Bean，Spring容器不进行缓存，因此无法提前暴露一个创建中的Bean。会抛出异常
    *   单例模式：通过Spring容器提前暴露刚完成构造器注入但未完成其他步骤（如setter注入）的Bean来完成的，而且只能解决单例作用域的Bean循环依赖。



### 5> 集合对象的注入

在使用Java `Collection` 对象中的`List`, `Set`, `Map`, `Properties`时，可以用`<list/>`, `<set/>`, `<map/>`, and `<props/>`进行属性注入

配置如下 ：

```xml
<bean id="moreComplexObject" class="example.ComplexObject">
    <!-- Properties -->
    <property name="adminEmails">
        <props>
            <prop key="administrator">administrator@example.org</prop>
            <prop key="support">support@example.org</prop>
            <prop key="development">development@example.org</prop>
        </props>
    </property>
    <!--java.util.List-->
    <property name="someList">
        <list>
            <value>a list element followed by a reference</value>
            <ref bean="myDataSource" />
        </list>
    </property>
    <!-- java.util.Map -->
    <property name="someMap">
        <map>
            <entry key="an entry" value="just some string"/>
            <entry key ="a ref" value-ref="myDataSource"/>
        </map>
    </property>
    <!-- java.util.Set-->
    <property name="someSet">
        <set>
            <value>just some string</value>
            <ref bean="myDataSource" />
        </set>
    </property>
</bean>
```

  集合合并

```xml
<beans>
    <bean id="parent" abstract="true" class="example.ComplexObject">
        <property name="adminEmails">
            <props>
                <prop key="administrator">administrator@example.com</prop>
                <prop key="support">support@example.com</prop>
            </props>
        </property>
    </bean>
    <bean id="child" parent="parent">
        <property name="adminEmails">
            <!-- the merge is specified on the child collection definition -->
            <props merge="true">
                <prop key="sales">sales@example.com</prop>
                <prop key="support">support@example.co.uk</prop>
            </props>
        </property>
    </bean>
<beans>
```

注意使用的`merge=true`上属性`<props/>`的元素 `adminEmails`的财产`child`bean定义。当`child`容器解析并实例化bean时，生成的实例有一个`adminEmails` `Properties`集合，其中包含将子集合`adminEmails`与父`adminEmails`集合合并的结果 。以下清单显示了结果：

```
administrator=administrator@example.com 
sales=sales@example.com 
support=support@example.co.uk
```

孩子`Properties`集合的值设置继承父所有属性元素`<props/>`，和孩子的为值`support`值将覆盖父集合的价值。  



### 6> Properties 文件注入

Properties 文件定义如下：

```properties
jdbc.driverClassName=org.hsqldb.jdbcDriver
jdbc.url=jdbc:hsqldb:hsql://production:9002
jdbc.username=sa
jdbc.password=root
```

**xml 引入代码**

```xml
<!--引入文件-->
<context:property-placeholder location="classpath:com/something/jdbc.properties"/>
<!--或者-->
<bean class="org.springframework.beans.factory.config.PropertySourcesPlaceholderConfigurer">
    <property name="locations">
        <value>classpath:com/something/strategy.properties</value>
    </property>
</bean>
```

 **使用注解引入**

```java
@Configuration
@ImportResource("classpath:/com/acme/properties-config.xml")
public class AppConfig {

    @Value("${jdbc.url}")
    private String url;

    @Value("${jdbc.username}")
    private String username;

    @Value("${jdbc.password}")
    private String password;

    @Bean
    public DataSource dataSource() {
        return new DriverManagerDataSource(url, username, password);
    }
}
```



## 3、上下文架构

运用 `<property-placeholder/>`：引入属性文件

运用 `<annotation-config/>`：开启注解如， `@Configuration`、`@Autowired`、`@Inject`和`@Value` `@Resource`

运用 `<tx:annotation-driven/>`：开启 `@Transactional`

运用 `<component-scan/>`：开启组件注解



**`<context:annotation-config>` 和 `<context:component-scan>`的区别**

[参考](https://www.cnblogs.com/leiOOlei/p/3713989.html)

*   `<context:annotation-config>` **是用于激活那些已经在spring容器里注册过的bean**（无论是通过xml的方式还是通过package sanning的方式）上面的注解。
*   `<context:component-scan>`除了具有`<context:annotation-config>`的功能之外，还可以在指定的package下扫描以及注册javabean 。
*   当 <context:annotation-config />和 <context:component-scan >同时存在的时候，前者会被忽略。



## 4、Bean 的生命周期

*   **实例化Bean：**

    对于BeanFactory容器，当客户向容器请求一个尚未初始化的bean时，或初始化bean的时候需要注入另一个尚未初始化的依赖时，容器就会调用createBean进行实例化。对于ApplicationContext容器，当容器启动结束后，通过获取BeanDefinition对象中的信息，实例化所有的bean。

*   **设置对象属性（依赖注入）：**

    实例化后的对象被封装在BeanWrapper对象中，紧接着，Spring根据BeanDefinition中的信息 以及 通过BeanWrapper提供的设置属性的接口完成依赖注入。

*   **处理Aware接口：**

    接着，Spring会检测该对象是否实现了xxxAware接口，并将相关的xxxAware实例注入给Bean：

    ​	①如果这个Bean已经实现了BeanNameAware接口，会调用它实现的setBeanName(String beanId)方法，此处传递的就是Spring配置文件中Bean的id值；

    ​	②如果这个Bean已经实现了BeanFactoryAware接口，会调用它实现的setBeanFactory()方法，传递的是Spring工厂自身。

    ​	③如果这个Bean已经实现了ApplicationContextAware接口，会调用setApplicationContext(ApplicationContext)方法，传入Spring上下文；

*   **BeanPostProcessor：**

    如果想对Bean进行一些自定义的处理，那么可以让Bean实现了BeanPostProcessor接口，那将会调用postProcessBeforeInitialization(Object obj, String s)方法。由于这个方法是在Bean初始化结束时调用的，所以可以被应用于内存或缓存技术；

*   **InitializingBean 与 init-method：**

    如果Bean在Spring配置文件中配置了 init-method 属性，则会自动调用其配置的初始化方法。

    如果这个Bean实现了BeanPostProcessor接口，将会调用postProcessAfterInitialization(Object obj, String s)方法；

*   以上几个步骤完成后，Bean就已经被正确创建了，之后就可以使用这个Bean了。

*   **DisposableBean：**

    当Bean不再需要时，会经过清理阶段，如果Bean实现了DisposableBean这个接口，会调用其实现的destroy()方法；

*   **destroy-method：**最后，如果这个Bean的Spring配置中配置了destroy-method属性，会自动调用其配置的销毁方法。



## 5、IoC实现原理





# 二、事务管理

## 1、配置方式

**声明式事务**

*    xml
*   注解（@Transactional ）

声明式事务支持，最重要的概念是通过AOP代理启用此支持



**基于XML的事务配置声明方法**

```java
<bean id="txManager" class="org.springframework.orm.hibernate5.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory"/>
</bean>
<tx:advice id="txAdvice" transaction-manager="txManager">
    <tx:attributes>
    <tx:method name="get*" read-only="true" rollback-for="NoProductInStockException"/>
    <tx:method name="updateStock" no-rollback-for="InstrumentNotFoundException"/>
    <tx:method name="*"/>
    </tx:attributes>
</tx:advice>
```

`PlatformTransactionManager`实现通常需要了解它们工作的环境：JDBC，JTA，Hibernate等

*   JDBC："org.springframework.jdbc.datasource.DataSourceTransactionManager"
*   JTA："org.springframework.transaction.jta.JtaTransactionManager" 
*   Hibernate："org.springframework.orm.hibernate5.HibernateTransactionManager"





**基于注释的方法**

```xml
<tx:annotation-driven transaction-manager="txManager"/>

<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <!-- (this dependency is defined somewhere else) -->
    <property name="dataSource" ref="dataSource"/>
</bean>
```

```java
@Transactional
public class DefaultFooService implements FooService {
    Foo getFoo(String fooName);
    Foo getFoo(String fooName, String barName);
    void insertFoo(Foo foo);
    void updateFoo(Foo foo);
}
```

默认`@Transactional`设置如下：

*   传播设置是 `PROPAGATION_REQUIRED.`
*   隔离级别是 `ISOLATION_DEFAULT.`
*   该事务是读写的。
*   事务超时默认为基础事务系统的默认超时，如果不支持超时，则默认为none。
*   任何`RuntimeException`触发器回滚，任何检查`Exception`都没有。



## 2、隔离级别

**Spring中支持五种事务隔离级别**：

*   **ISOLATION_DEFAULT**：数据库默认隔离级别
*   **ISOLATION_READ_UNCOMMITTED**：未提交读；读取到没有被提交的数据
*   **ISOLATION_READ_COMMITTED**：**提交读(Oracle\sqlserver  默认**)，读到那些已经提交的数据 
*   **ISOLATION_REPEATABLE_READ**（repeatable）：**可重复读（Mysql 默认）**；这个事务不结束，别的事务就不可以改这条记录，加锁
*   **SERIALIZABLE**（serializable）：**串行化（级别最高）**，运行完一个事务的所有子事务之后才可以执行另外一个事务



## 3、传播途径

Spring共有7种传播途径：

*   支持当前事务
    *   **propagation_required**：支持当前事务，如果不存在 就新建一个(默认) 
    *   **propagation_supports**：支持当前事务，如果不存在，就不使用事务 
    *   **propagation_mandatory**（强制）：支持当前事务，如果不存在，抛出异常 
*   不支持当前事务
    *   **propagation_requires_new**：如果有事务存在，挂起当前事务，创建一个新的事务 
    *   **propagation_not_supported**：如果有事务存在，挂起当前事务 ，如果不存在以非事务方式运行
    *   **propagation_never**：如果有事务存在，抛出异常 ，如果不存在以非事务方式运行
    *   **propagation_nested**：如果当前事务存在，则嵌套事务执行（他的提交是要等和他的父事务一块提交的，父回滚他回滚）

## 4、实现原理

*   事务声明默认使用 AOP 代理；
*   如果使用 this.xxx 的方式，事物会失效。this 此时不是代理类的对象。
    *   **解决方法：**
    *   1.注入自身，使用代理对象调用；
    *   2.使用AopContext,获取当前代理对象；
    *   3.使用BeanFactory获取代理对象。

## 5、事务属性

**Transactional 的事务属性** （如级别、回滚、传播途径、时长等）

*   @isolation：用于指定事务的隔离级别。默认为底层事务的隔离级别
*   @noRollbackFor：指定遇到特定异常时不回滚事务
*   @noRollbackForClassName：指定遇到特定的多个异常时不回滚事务
*   @propagation：指定事务传播行为
*   @readOnly：指定事务是否可读
*   @rollbackFor：指定遇到特定异常时回滚事务
*   @rollbackForClassName：指定遇到特定的多个异常时回滚事务
*   @timeout：指定事务的超长时长。





# 三、切面编程AOP

## 1、AOP概念

*   通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术
*   利用AOP可以对业务逻辑的各个部分进行隔离，降低耦合度，提高程序的可重用性，同时提高了开发的效率；
*   主要功能：日志记录，性能统计，安全控制，事务处理，异常处理等等。

## 2、AOP核心概念

*   **切面（Aspect）：** 一个关注点的模块化，这个关注点可能会横切多个对象
*   **连接点（Joinpoint）** ：程序执行过程中某个特定的连接点
*   **通知（Advice）**  ：在切面的某个特的连接点上执行的动作
*   **切入点（Pointcut）** ：匹配连接的断言，在Aop中通知和一个切入点表达式关联
*   **引入（Intruduction）** ： 在不修改类代码的前提下，为类添加新的方法和属性
*   **目标对象（Target Object）** ： 被一个或者多个切面所通知的对象
*   **Aop代理（AOP Proxy）** ： AOP框架创建的对象，用来实现切面契约（aspect contract）（包括方法执行等）
*   **织入（Weaving）** ：把切面连接到其他的应用程序类型或者对象上，并创建一个被通知的对象，氛围：编译时织入，类加载时织入。执行时织入



## 3、通知类型

AOP由 5 种通知分类： 

*   @**Before**: 前置通知, 在方法执行之前执行
*   @**After**: 后置通知, 在方法执行之后执行，不能访问目标方法的执行结果
*   @**AfterRunning**: 返回通知, 在方法返回结果之后执行，不管正常返回还是异常退出
*   @**AfterThrowing**: 异常通知, 在方法抛出异常之后
*   @**Around**: 环绕通知, 围绕着方法执行，
    *   连接点的参数类型必须是 `ProceedingJoinPoint`，它是JoinPoint子接口，
    *   **在环绕通知中需要明确调用其 proceed() 来执行倍代理的方法。如果忘记，会导致通知执行了，但目标方法没有被执行**
    *   如果需要返回目标方法执行后的结果，即调用 proceed() 的返回值。否则会出现空指针异常



## 4、AOP代理

Spring AOP默认使用AOP代理的标准JDK动态代理。这使得任何接口（或接口集）都可以被代理。

Spring AOP也可以使用CGLIB代理。这是代理类而不是接口所必需的。默认情况下，如果业务对象未实现接口，则使用CGLIB

![img](assets/aop-proxy-call.png)

```java
public static void main(String[] args) {
    ProxyFactory factory = new ProxyFactory(new SimplePojo());
    factory.addInterface(Pojo.class);
    factory.addAdvice(new RetryAdvice());

    Pojo pojo = (Pojo) factory.getProxy();
    // this is a method call on the proxy!
    pojo.foo();
}
```



## 5、注解支持

在Spring配置中使用@AspectJ方面，您需要启用Spring支持，以基于@AspectJ方面配置Spring AOP，

**使用Java配置启用@AspectJ支持**

要使用Java启用@AspectJ支持`@Configuration`，请添加`@EnableAspectJAutoProxy` 注释，如以下示例所示：

```java
@Configuration
@EnableAspectJAutoProxy
public class AppConfig {

}
```

**使用XML配置启用@AspectJ支持**

要使用基于XML的配置启用@AspectJ支持，请使用该`aop:aspectj-autoproxy` 元素，如以下示例所示：

```xml
<aop:aspectj-autoproxy/>
```



**想实现 AOP 注解编程，需要如下几步：**

**第一步： 声明切面类**

*   在类上使用 `@Component`  注解把切面类加入到IOC容器中 
*   在类上使用 `@Aspect` 注解 使之成为切面类

**第二步：声明切入点**

*   在方法上使用 `@Pointcut` 声明一个切入点，指定**连接点**类型 Execution
*   也可以将连接点类型，定义在通知类型中。不用声明切入点了

第三步：定义通知的处理方法

*   使用 @Before、@After、@AfterRunning、@AfterThrowing、@Around

    @**AfterRunning**: 返回通知, 在方法返回结果之后执行

      　@**AfterThrowing**: 异常通知, 在方法抛出异常之后

      　@**Around**: 环绕通知, 围绕着方法执行



## 6、切入点类型

*   execution`：用于匹配方法执行连接点。这是使用Spring AOP时使用的主要切入点指示符。
*   `within`：限制匹配某些类型中的连接点（使用Spring AOP时在匹配类型中声明的方法的执行）。
*   `this`：限制与连接点的匹配（使用Spring AOP时执行方法），其中bean引用（Spring AOP代理）是给定类型的实例。
*   `target`：限制与连接点的匹配（使用Spring AOP时执行方法），其中目标对象（被代理的应用程序对象）是给定类型的实例。
*   `args`：限制与连接点的匹配（使用Spring AOP时执行方法），其中参数是给定类型的实例。
*   `@target`：限制与连接点的匹配（使用Spring AOP时执行方法），其中执行对象的类具有给定类型的注释。
*   `@args`：限制与连接点的匹配（使用Spring AOP时执行方法），其中传递的实际参数的运行时类型具有给定类型的注释。
*   `@within`：限制匹配到具有给定注释的类型中的连接点（使用Spring AOP时在具有给定注释的类型中声明的方法的执行）。
*   `@annotation`：限制连接点的匹配，其中连接点的主题（在Spring AOP中执行的方法）具有给定的注释。



以使用`&&,` `||`组合切入点表达式

```java
@Pointcut("execution(public * *(..))")
private void anyPublicOperation() {} 

@Pointcut("within(com.xyz.someapp.trading..*)")
private void inTrading() {} 

@Pointcut("anyPublicOperation() && inTrading()")
private void tradingOperation() {} 
```

`anyPublicOperation` 如果方法执行连接点表示任何公共方法的执行，则匹配。

`inTrading` 如果方法执行在交易模块中，则匹配。

`tradingOperation` 如果方法执行表示交易模块中的任何公共方法，则匹配。



## 7、切入点表达式

*   执行任何公共方法：

    ```java
    execution(public * *(..))
    ```

*   执行名称以以下开头的任何方法`set`：

    ```java
    execution(* set*(..))
    ```

*   执行`AccountService`接口定义的任何方法：

    ```java
    execution(* com.xyz.service.AccountService.*(..))
    ```

*   执行`service`包中定义的任何方法：

    ```java
    execution(* com.xyz.service.*.*(..))
    ```

*   执行服务包或其子包中定义的任何方法：

    ```java
    execution(* com.xyz.service..*.*(..))
    ```

*   服务包中的任何连接点（仅在Spring AOP中执行方法）：

    ```java
    within(com.xyz.service.*)
    ```

*   服务包或其子包中的任何连接点（仅在Spring AOP中执行方法）：

    ```java
    within(com.xyz.service..*)
    ```

*   代理实现`AccountService`接口的任何连接点（仅在Spring AOP中执行方法） ：

    ```java
    this(com.xyz.service.AccountService)
    ```

*   目标对象实现`AccountService`接口的任何连接点（仅在Spring AOP中执行方法）：

    ```
    target(com.xyz.service.AccountService)
    ```

*   采用单个参数的任何连接点（仅在Spring AOP中执行的方法）以及在运行时传递的参数是`Serializable`：

    ```java
    args(java.io.Serializable)
    ```

*   目标对象具有`@Transactional`注释的任何连接点（仅在Spring AOP中执行方法） ：

    ```java
    @target(org.springframework.transaction.annotation.Transactional)
    ```

*   任何连接点（仅在Spring AOP中执行方法），其中目标对象的声明类型具有`@Transactional`注释：

    ```java
    @within(org.springframework.transaction.annotation.Transactional)
    ```

*   任何连接点（仅在Spring AOP中执行方法），其中执行方法具有 `@Transactional`注释：

    ```java
    @annotation(org.springframework.transaction.annotation.Transactional)
    ```

*   任何连接点（仅在Spring AOP中执行的方法），它接受一个参数，并且传递的参数的运行时类型具有`@Classified`注释：

    ```java
    @args(com.xyz.security.Classified)
    ```

*   名为的Spring bean上的任何连接点（仅在Spring AOP中执行方法） `tradeService`：

    ```java
    bean(tradeService)
    ```

*   具有与通配符表达式匹配的名称的Spring bean上的任何连接点（仅在Spring AOP中执行方法）`*Service`：

    ```java
    bean(*Service)
    ```

  

## 8、JoinPoint

任何通知方法都可以声明一个类型的参数作为其第一个参数 `org.aspectj.lang.JoinPoint`（注意，需要在通知周围声明类型的第一个参数`ProceedingJoinPoint`，它是一个子类`JoinPoint`。 `JoinPoint`接口提供了许多有用的方法：

*   `getArgs()`：返回方法参数。
*   `getThis()`：返回代理对象。
*   `getTarget()`：返回目标对象。
*   `getSignature()`：返回正在建议的方法的描述。
*   `toString()`：打印建议方法的有用说明。



## 9、AOP示例

**基于注解**

```java
@Aspect
@Component
public class SysLogAspect {
    @Autowired
    private ISysLogService sysLogService;

    @Pointcut("@annotation(com.husy.annotation.SysLogAnnotation)")
    public void controllerPointCut() { }

    @Around("controllerPointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        //执行目标方法
        Object result = point.proceed();
        //执行时长(毫秒)
        long time = System.currentTimeMillis() - beginTime;
        //保存日志
        saveSysLog(point, time);
        return result;
    }
    
    private void saveSysLog(ProceedingJoinPoint joinPoint, long time) {
        //从切面织入点处通过反射机制获取织入点处的方法
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        //获取切入点所在的方法
        Method method = signature.getMethod();

        //保存日志
        SysLog sysLog = new SysLog();
        //获取操作
        SysLogAnnotation sysLogAnnotation = method.getAnnotation(SysLogAnnotation.class);
        if (sysLogAnnotation != null) {
            String value = sysLogAnnotation.value();
            //注解上的描述
            sysLog.setOperation(value);//保存获取的操作
        }

        //获取请求的类名
        String className = joinPoint.getTarget().getClass().getName();
        //获取请求的方法名
        String methodName = method.getName();
        sysLog.setMethod(className + "." + methodName + "()");

        //请求的参数
        Object[] params = joinPoint.getArgs();
        JSON json = (JSON) JSON.toJSON(params);
        sysLog.setParams(json.toJSONString());

        // 获取token
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();


        //设置IP地址
        sysLog.setIp(IPUtils.getIpAddr(request));

        // 设置操作人
        SysUser sysUser = UserTool.getUser();

        String userId = sysUser.getSysUserId();
        String username = sysUser.getUsername();
        sysLog.setOperator(userId);
        sysLog.setUsername(username);

        sysLog.setTime(time);
        sysLog.setCreateTime(new Date());

        //调用service保存SysLog实体类到数据库
        sysLogService.save(sysLog);
    }   
}
```

**基于XML 的AOP**

需要引入  xmlns:aop="http://www.springframework.org/schema/aop"

您可以使用 `<aop：aspect>` 元素声明方面，并使用该`ref`属性引用支持bean ，如以下示例所示：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- this is the object that will be proxied by Spring's AOP infrastructure -->
    <bean id="personService" class="x.y.service.DefaultPersonService"/>

    <!-- this is the actual advice itself -->
    <bean id="profiler" class="x.y.SimpleProfiler"/>

    <aop:config>
        <aop:aspect ref="profiler">
            <aop:pointcut id="theExecutionOfSomePersonServiceMethod"
                expression="execution(* x.y.service.PersonService.getPerson(String,int))
                and args(name, age)"/>
            <aop:around pointcut-ref="theExecutionOfSomePersonServiceMethod"
                method="profile"/>
        </aop:aspect>
    </aop:config>
    
</beans>
```



# 四、Spring MVC

## 1、了解SpringMVC

Spring MVC是基于Servlet API构建的原始Web框架

Spring MVC是一个基于Java的实现了MVC设计模式的轻量级Web框架，通过把Model，View，Controller分离，将web层进行职责解耦，把复杂的web应用分成逻辑清晰的几部分，简化开发，减少出错，方便组内开发人员之间的配合。



**springMVC&Struts2 区别**

*   拦截机制：Struts2 是类级别拦截，SpringMVC是方法级别的拦截。
*   底层框架：Struts2 是采用过滤器实现的filter，springmvc 采用 servlet 实现的
*   性能方面：Struts2 每次请求都会实例化一个Action；SpringMVC的Controller Bean默认**单例模式**
*   配置方面：spring MVC和Spring是无缝的。从这个项目的管理和安全上也比Struts2高。

## 2、SpringMVC工作原理

前端控制 --> 处理器映射器-->处理器适配器-->后端控制层-->视图解析-->渲染

*   用户请求-->**前端控制器**DispatcherServlet。
*   DispatcherServlet-->调用HandlerMapping **处理器映射器**。解析请求对应的Handler
*   处理器映射器根据地址找到具体的处理器，**生成处理器对象及处理器拦截器对象**-->并返回给DispatcherServlet。
*   DispatcherServlet-->调用HandlerAdapter **处理器适配器**。
*   HandlerAdapter 根据Handler来调用后端控制器**Controller进行业务处理**
*   Controller-->**返回ModelAndView** 给 HandlerAdapter处理器适配器
*   HandlerAdapter-->ModelAndView返回给DispatcherServlet。
*   DispatcherServlet将ModelAndView-->传给ViewReslover**视图解析器**进行解析成具体View。
*   DispatcherServlet根据View进行**渲染视图**
*   DispatcherServlet响应用户。

### 1> DispatcherServlet  

DispatcherServlet  是前端控制器，通过使用Java配置或在Servlet说明书中声明和映射`web.xml`通过使用Java配置或在Servlet说明书中声明和映射`web.xml`，反过来，`DispatcherServlet`使用Spring的配置来发现它需要请求映射，视图解析，异常处理，委托组件

以下`web.xml`配置示例注册并初始化`DispatcherServlet`：

```xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/app-context.xml</param-value>
    </context-param>

    <servlet>
        <servlet-name>app</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value></param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app</servlet-name>
        <url-pattern>/app/*</url-pattern>
    </servlet-mapping>

</web-app>
```

Spring Boot遵循不同的初始化顺序。Spring Boot使用Spring配置来引导自身和嵌入式Servlet容器，而不是挂钩到Servlet容器的生命周期。`Filter`和`Servlet`声明在Spring配置中检测到并在Servlet容器中注册。

![mvc上下文层次结构](assets/mvc-context-hierarchy.png)

### 2> 视图解析器

Spring MVC与JSP和JSTL一起使用

使用JSP进行开发时，可以声明一个`InternalResourceViewResolver`或一个`ResourceBundleViewResolver`。

*   `ResourceBundleViewResolver`依赖于属性文件来定义映射到类和URL的视图名称
*   `InternalResourceViewResolver`也可以用于JSP。作为最佳实践，
*   建议将JSP文件放在目录下的`'WEB-INF'`目录中，以便客户端无法直接访问。

```xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.ResourceBundleViewResolver">
    <property name="basename" value="views"/>
</bean>
```

```xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```

使用JSP标准标记库（JSTL）时，必须使用特殊的视图类 `JstlView`

且JSP 页面需要引入

```xml
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
```



## 3、控制层

### 1>请求映射

使用`@RequestMapping`注释将请求映射到控制器方法。它具有各种属性，可通过URL，HTTP方法，请求参数，标头和媒体类型进行匹配。您可以在类级别使用它来表示共享映射，或者在方法级别使用它来缩小到特定的端点映射。

还有HTTP方法特定的快捷方式变体`@RequestMapping`：

*   `@GetMapping`
*   `@PostMapping`
*   `@PutMapping`
*   `@DeleteMapping`
*   `@PatchMapping`

**URI模式**

使用以下全局模式和通配符映射请求：

*   `?` 匹配一个字符
*   `*` 匹配路径段中的零个或多个字符
*   `**` 匹配零个或多个路径段

您还可以使用声明URI变量并访问它们的值`@PathVariable`，如以下示例所示：

```java
@GetMapping("/owners/{ownerId}/pets/{petId}")
public Pet findPet(@PathVariable Long ownerId, @PathVariable Long petId) {
    // ...
}
```

您可以在类和方法级别声明URI变量，如以下示例所示：

```java
@Controller
@RequestMapping("/owners/{ownerId}")
public class OwnerController {

    @GetMapping("/pets/{petId}")
    public Pet findPet(@PathVariable Long ownerId, @PathVariable Long petId) {
        // ...
    }
}
```

### 2> 重定向属性  

定义重定向：

```java
@PostMapping("/files/{path}")
public String upload(...) {
    // ...
    return "redirect:files/{path}";
}
```

### 3> 代码演示

```java
package com.husy.controller;

import com.husy.model.UserVo;
import org.springframework.web.bind.annotation.*;

/**
 * @author hsy
 */
@RestController
// 请求地址映射类级别
@RequestMapping("/home")
public class IndexController {

	/**
	 * 将请求映射到方法
	 * @return
	 */
	@RequestMapping("index")
	public String index(){
		return "index";
	}
	/**
	 * 将多个请求映射到一个方法
	 * @return
	 */
	@RequestMapping(value = {"","/page","page*","view/*,**/msg"	})
	public String indexMultipleMapping() {
		return "Hello from index multiple mapping.";
	}
	/**
	 * 定义请求方式 post
	 * @return
	 */
	@RequestMapping(value ="type"  ,method = RequestMethod.POST)
	public String postMapping() {
		return "Hello from post";
	}

	/**
	 * 使用 @RequestParam 注解的传递参数，personId 必须传递
	 * @param inputStr
	 * @return
	 */
	 @RequestMapping(value = "/id")
	 public String getId(@RequestParam("paramId") String inputStr  ) {
		return "Get Param value element,then id is "+ inputStr;
	}

	/**
	 * 使用json 对象传递参数
	 * @param userVo
	 * @return
	 */
	@RequestMapping(value = "/user")
	public UserVo getIdByJson(@RequestBody UserVo userVo ) {
		return  userVo;
	}

	/**
	 * 	使用 @RequestParam 注解的 传递参数，参数可选是否传参。
	 * @param username
	 * @return
	 */
	@RequestMapping(value = "/name")
	public String getIdByValue(@RequestParam(value ="name", required = false) String username) {
		return "Get Param value element ,then id is "+ username;
	}
	/**
	 * 处理动态 URI，动态url 传参
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/fetch/{id}", method = RequestMethod.GET)
	public String getDynamicUriValue(@PathVariable String id) {
		return "Dynamic URI parameter fetched,then id is "+id;
	}
}


```



## 4、启用MVC注解

在Java配置中，您可以使用`@EnableWebMvc`批注来启用MVC配置，如以下示例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig {
}
```

在XML配置中，您可以使用该`<mvc:annotation-driven>`元素启用MVC配置，如以下示例所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd">
    <mvc:annotation-driven/>
</beans>
```



## 5、过滤器

可参考资料：https://www.jianshu.com/p/3d421fbce734

如果是springboot项目，在pom.xml 中配置`spring-boot-starter-web` 依赖即可

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

实现 Filter 接口。

```java
@WebFilter(filterName="MyFilter",urlPatterns="/*")
public class MyFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("开始进行过滤处理");
        //调用该方法后，表示过滤器经过原来的url请求处理方法
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}

```

**内置容器**

如果使用的容器是Springboot 的内置容器，需要使用`@ServletComponentScan`注解，注册到嵌入式servlet容器。这个@ServletComponentScan最好配置在 Apllication 这个上面，通用配置。

默认情况下，`@ServletComponentScan`从带注释的类的包中进行扫描。

```java
@SpringBootApplication
@ServletComponentScan
public class WebApplication {
	public static void main(String[] args) {
		SpringApplication.run(WebApplication.class, args);
	}
}
```

也可以直接使用**@Component** 修饰，将Filter 注入到容器中，这同样有效果

```java
@Component
@WebFilter(filterName="myFilter",urlPatterns="/*")
public class MyFilter implements Filter {
    ...  省略
}
```



**外部容器**

对于Springboot 使用外部容器，需要进行扩展`SpringBootServletInitializer`并覆盖其`configure`方法；

如果没有重写 configure 方法，Tomcat是支持不了Spring 注解的，但是 @WebFilter  属于Servlet 3 的注解，所以 Tomcat 在启动时，是可以允许@WebFilte 在容器中注册的



**注意：**在Tomcat 7 时， 已经支持Servlet 3 的使用， 允许在servlet容器启动时配置应用程序。

Springboot使用外部容器如以下示例所示：

```java
@SpringBootApplication
public class DemoApplication extends SpringBootServletInitializer {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
    /**
     * 实现SpringBootServletInitializer可以让spring-boot项目在web容器中运行
     */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(DemoApplication.class);
    }
}
```

最后为了确保嵌入式servlet容器不会干扰部署war文件的servlet容器。为此，您需要将嵌入式servlet容器依赖项标记为

<scope>provided</scope>

并且pom.xml 中需要修改为

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```

注：<scope>provided</scope>表示在编译和测试时使用（不加它，打的包中会指定tomcat，用tomcat部署时会因tomcat版本报错；而加上它，打包时不会把内置的tomcat打进去）

同时移除内置Tomcat

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```



## 6、拦截器

**应用场景**
1、日志记录，可以记录请求信息的日志，以便进行信息监控、信息统计等。

2、权限检查：如登陆检测，进入处理器检测是否登陆，如果没有直接返回到登陆页面。

3、性能监控：典型的是慢日志。



所有`HandlerMapping`实现都支持处理程序拦截器，拦截器必须`HandlerInterceptor`从 `org.springframework.web.servlet`包中实现三种方法

- `preHandle(..)`：在执行实际处理程序之前
- `postHandle(..)`：处理程序执行后
- `afterCompletion(..)`：完成请求完成后



一般使用继承`HandlerInterceptorAdapter`的方式，

代码如下：

```java
@Component
public class IndexInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("------------------成功潜入拦截器中---------------");
        return super.preHandle(request, response, handler);
    }
}
```





在Java配置中，您可以注册拦截器以应用传入请求，如以下示例所示：

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private  IndexInterceptor indexInterceptor;
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        System.out.println("------------------准备注册拦截器---------------");
        
        // addPathPatterns("/**") 表示拦截所有的请求，
        // excludePathPatterns("/login", "/register") 表示除了登陆与注册之外，因为登陆注册不需要登陆也可以访问
        registry.addInterceptor(indexInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/login", "/register");
    }
}
```

以下示例显示如何在XML中实现相同的配置：

```xml
<mvc:interceptors>
    <bean class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor"/>
    <mvc:interceptor>
        <mvc:mapping path="/**"/>
        <mvc:exclude-mapping path="/admin/**"/>
        <bean class="org.springframework.web.servlet.theme.ThemeChangeInterceptor"/>
    </mvc:interceptor>
    <mvc:interceptor>
        <mvc:mapping path="/secure/*"/>
        <bean class="org.example.SecurityInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
```



## 7、监听器

1、使用servlet 3.0 注解 @WebListener

```java
@WebListener
public class RequestListenter implements ServletRequestListener {
    @Override
    public void requestDestroyed(ServletRequestEvent servletRequestEvent) {
        System.out.println("---------------------------->请求销毁监听器");
    }
    @Override
    public void requestInitialized(ServletRequestEvent servletRequestEvent) {
        System.out.println("---------------------------->请求创建监听器");
    }
}
```



## 8、全局异常处理

全局异常处理一般可使用如下方式：

*   通过使用  @ControllerAdvice
*   通过实现 HandlerExceptionResolver



Spring官方推荐`@ControllerAdvice`的写法，理由主要有下面几点：

1、使用注解的方式代码看上去更加的清晰。
2、对于自定义异常的捕获会很方便。
3、适用于对于返回json格式的情况（可以使用@ResponseBody注解方法对特定异常进行处理），使用HandlerExceptionResolver的话如果是ajax的请求，出现异常就会很尴尬，ajax并不认识ModelAndView。

### 1> 使用`@ControllerAdvice`

通过`@ControllerAdvice`以自定义要为特定控制器和/或异常类型返回的JSON文档

```java
@ControllerAdvice
public class WebExceptionHandler {
    /**
     * 全局异常捕捉处理
     * @param ex
     * @return
     */
    @ResponseBody
    @ExceptionHandler(value = Exception.class)
    public Map errorHandler(Exception ex) {
        System.out.println("--------全局异常捕捉处理---------");
        Map map = new HashMap();
        map.put("code", 100);
        map.put("msg", ex.getMessage());
        //当然也可以直接返回ModelAndView等类型，然后跳转相应的错误页面，这都根据实际的需要进行使用
        return map;
    }
}
```



### 2> 实现HandlerExceptionResolver

通过`HandlerExceptionResolver`实现

```java
public interface HandlerExceptionResolver {
    @Nullable
    ModelAndView resolveException(HttpServletRequest request, 
                                  HttpServletResponse response, 
                                  @Nullable Object handler, 
                                  Exception ex);

}
```

代码实现如下：

```java
@Configuration
public class GlobalException  implements HandlerExceptionResolver {
    @Override public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        ModelAndView mv = new ModelAndView();
        System.out.println("--------全局异常捕捉处理---------");
        //判断不同异常类型，做不同视图跳转
        if(ex instanceof ArithmeticException){
            mv.setViewName("error1");
        }
        if(ex instanceof RuntimeException){
            mv.setViewName("error2"); }
        mv.addObject("index", ex.toString());
        return mv;
    }
}

```



HandlerExceptionResolver常用实现类如下：

- SimpleMappingExceptionResolver：异常类名称和错误视图名称之间的映射。用于在浏览器应用程序中呈现错误页面。
- DefaultHandlerExceptionResolver：解决Spring MVC引发的异常并将它们映射到HTTP状态代码。
- ResponseStatusExceptionResolver：使用`@ResponseStatus`注释解析异常，并根据注释中的值将它们映射到HTTP状态代码。
- ExceptionHandlerExceptionResolver：通过调用或 类中的`@ExceptionHandler`方法来解决异常。



# 五、Spring 注解

在spring 中开启注解，首先需要引入  xmlns:context="http://www.springframework.org/schema/context"

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>
	<context:component-scan base-package="com.husy"/> 
</beans>
```

*   `<context:annotation-config/>`的作用：是用于激活那些已经在spring容器里注册过的bean（无论是通过xml的方式还是通过package sanning的方式）上面的注解。
*   `<context:component-scan />`的作用：除了具有<context:annotation-config>的功能之外，<context:component-scan>还可以在指定的package下扫描以及注册javabean 。

可参考资料：https://blog.csdn.net/qq_21439971/article/details/51462268



## 1、常用注解

在 Spring 中要使用，需要注解开启自动扫描功能。其中base-package 为需要扫描的包，可以使用模糊匹配

```java
<context:component-scan base-package="com.husy"/> 
```

常用注解如下：

Java 配置：

*   **@Configuration**  ：声明当前类是一个配置类，相当于一个Spring配置的xml文件
*   把一个类作为一个IoC容器，如果某方法上使用了@Bean，就会作为这个Spring容器中的Bean。
*   **@Bean** ：注解在方法上，声明当前方法的返回值为一个@Bean。@Lazy(true) 可以表示延迟初始化，@Scope 用于指定scope作用域的（用在类上）



**声明 Bean 的注解：**

*   **@Controller**	用于标注控制层组件（如struts中的action）
*   **@Service**	用于标注业务层组件
*   **@Repository**	用于标注数据访问组件，即DAO组件。
*   **@Component**	泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注。



**注入bean 的注解**

*   **@Autowired** 默认按类型装配，如果我们想使用按名称装配，可以结合@Qualifier注解一起使用。
*   **@Qualifier**("personDaoBean")   **按名称装配**
    *   如下：@Autowired + @Qualifier("personDaoBean") 存在多个实例配合使用

*   **@Resource ** **默认按名称装配**，当找不到与名称匹配的bean才会按类型装配。
*   **@Inject** ：（不常用）根据**类型**进行自动装配，按名称装配需要@Named结合使用时

**区别：**

*   @Autowired 默认按照byType方式进行bean匹配，
*   @Resource 默认按照byName方式进行bean匹配，找不到再按type去匹配
*   @Autowired是Spring的注解，@Resource是J2EE的注解，建议使用@Resource注解，以减少代码和Spring之间的耦合。



**AOP 注解**

*   @Aspect 声明一个切面
*   @After、@Before、@Around 定义建言（advice），可直接将拦截规则(切点) 作为参数
*   @PointCut 定义拦截规则

*   @EnableAspectAutoProxy  表示开启*AOP*代理自动配置，如果配@EnableAspectJAutoProxy表示使用*cglib*进行代理对象的生成



**多线程注解：**

@EnableAsync 注解开启异步任务支持

@Async 声明该方法是个异步方法



**定时任务注解**

@EnableSching 开启计划任务支持

@Scheduled 声明一个计划任务





其他：

*   @Transcational  事务处理
*   @Cacheable  数据缓存

*   **@Async**异步方法调用
*   **`@SpringBootApplication`**  申明启动类

*   @AliasFor	用于属性限制
*   @ComponentScan
*   @PostConstruct  用于指定初始化方法（用在方法上）
*   @PreDestory  用于指定销毁方法（用在方法上）
*   @DependsOn：定义Bean初始化及销毁时的顺序
*   @Primary：自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常
*   @PreDestroy 摧毁注解 默认 单例  启动就加载





------

## 2、Controller层注解

SpringMVC 中控制层的类一般在 控制层注解用 **`@Controller`**  修饰，

SpringBoot 中，可以在的控制层用 **`@RestController`** 修饰

**区别如下**：

*   @Controller 注解，在对应的方法上，视图解析器可以解析return 的jsp,html页面，并且跳转到相应页面，若返回 json 等内容到页面，则需要加@ResponseBody注解
*   @RestController注解，相当于@Controller+@ResponseBody两个注解的结合，返回json数据不需要在方法前面加@ResponseBody注解了，但使用@RestController这个注解，就不能返回jsp，html页面，视图解析器无法解析jsp，html页面



### 1> @Controller  & @RestController

源码如下

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Controller {
    @AliasFor(annotation = Component.class)
    String value() default "";
}
```



源码如下

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController {
    @AliasFor(annotation = Controller.class)
    String value() default "";
}
```

### 2> @RequestMapping

源码如下

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Mapping
public @interface RequestMapping {
    String name() default "";
    @AliasFor("path")
    String[] value() default {};
    @AliasFor("value")
    String[] path() default {};
    RequestMethod[] method() default {};
    String[] params() default {};
    String[] headers() default {};
    String[] consumes() default {};
    String[] produces() default {};
}
```

用法：

*   作用于控制器类或其方法级别
*   映射多请求地址：可以将多个请求映射到一个方法上去
*   绑定参数：可以配合 **`@RequestParam`** 一起使用，可以将请求的参数同处理方法的参数绑定在一起。 
    *   **@RequestParam** 的参数
        *   defaultValue ：定义默认值
        *   required ：参数是否必传
*   处理动态URL：可以同 **`@PathVaraible`** 注解一起使用，用来处理动态的 URI，URI 的值可以作为控制器中处理方法的参数。你也可以使用正则表达式来只处理可以匹配到正则表达式的动态 URI。 
*   定义请求方式，请求的方法比如 GET （默认）, PUT, POST, DELETE 以及 PATCH。 
    *   方法级别的注解变体有如下几个： 
        *   **@GetMapping**
        *   **@PostMapping**
        *   @PutMapping
        *   @DeleteMapping
        *   @PatchMapping

### 3> @ResponseBody 

作用在类或方法上，方法将数据转为 json 数据直接写入 HTTP response body 中

```java
@RequestMapping("/login")
@ResponseBody
public User login(User user){
    return user;
}

//User字段：userName pwd
//那么在前台接收到的数据为：'{"userName":"xxx","pwd":"xxx"}'

// 效果等同于如下代码：
@RequestMapping("/login")
public void login(User user, HttpServletResponse response){
    response.getWriter.write(JSONObject.fromObject(user).toString());
}
```

### 4> @RequestBody

作用在形参列表上，用于将前台发送过来固定格式的数据【xml 格式或者 json等】封装为对应的 JavaBean 对象

```java
@RequestMapping(value = "user/login")
@ResponseBody
// 将ajax（datas）发出的请求写入 User 对象中
public User login(@RequestBody User user) {   
// 这样就不会再被解析为跳转路径，而是直接将user对象写入 HTTP 响应正文中
    return user;    
}
```





## 3、Service层注解

使用 **`@Service`**   指定这是一个 service 类，该类可以使用 @Resource 或者 @Autowired +@Qualifier("DataDao") 装配

```
@Service("userService")
@Scope("prototype")
public class UserServiceImpl extends implements userService{

}
// 相当于applicationContext.xml文件里面的：
<bean id="userService" class="com.husy.service.UserServiceImpl" scope="prototype">
 
</bean>
```



## 4、Configuration 注解

### 1> @Configuration

@Configuration 注解主要用于定义配置类，配置spring容器(应用上下文)，可替换xml配置文件

可以使用 @ComponentScan 开启自动扫描

被注解的类内部包含一个或多个被 @Bean 注解的方法

```java
//开启注解配置
@Configuration
//添加自动扫描注解，basePackages为TestBean包路径
@ComponentScan(basePackages = "com.test.spring.support.configuration")
public class TestConfiguration {
    public TestConfiguration(){
         System.out.println("spring容器启动初始化。。。");
    }

    //取消@Bean注解注册bean的方式
    @Bean
    @Scope("prototype")
    public TestBean testBean() {
          return new TestBean();
    }
}

```

### 2> @SpringBootConfiguration

**SpringBoot 也可以使用 @SpringBootConfiguration**

@SpringBootConfiguration继承自@Configuration，二者功能也一致，标注当前类是配置类，
并会将当前类内声明的一个或多个以@Bean注解标记的方法的实例纳入到spring容器中，并且实例名就是方法名。

源码如下：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Configuration
public @interface SpringBootConfiguration {
}
```



### 3> @ConfigurationProperties

SpringBoot还可以使用@ConfigurationProperties注解可以注入在application.properties配置文件中的属性，和@Bean 或者 @Component 能生成spring bean 的注解结合起来使用

```java
@Bean(name = "dataSource")
@ConfigurationProperties(prefix = "spring.datasource.druid") 
public DataSource testDataSource( ) {
    return DruidDataSourceBuilder.create().build();
}
```



## 5、Aspact 注解

### 1> AOP 依赖

Spring 实现注解的方式需要引入如下包依赖：

使用AspectJ注解需要依赖于以下几个类库
aspectjweaver-1.6.10.jar

spring-aop-4.3.10.RELEASE.jar

spring-aspects-4.3.10.RELEASE.jar



SpringBoot 依赖引入 spring-boot-starter-aop 包依赖就可以了

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

spring-boot-starter-aop 进去上面源码查看，你会发现其内部已经依赖了spring-aop 和 aspectjweaver 包

```xml
<!--如下-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aop</artifactId>
    <version>5.1.2.RELEASE</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.2</version>
    <scope>compile</scope>
</dependency>
```



### 2> Execution 表达式类型

在方法上使用 `@Pointcut` 申明一个连接点，表示该切面切入的位置，一般该方法不需要实现

连接点类型有 9种： execution()、@annotation()、args()、@args()、within()、target()、@within()、@target()、this()

| 类型            | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| **execution**   | 参数为方法匹配模式串，表示以目标类方法为连接点，<br />如 execution(*.greetTo())表示所有目标类中的greetTo()方法 |
| **@annotation** | 参数为方法注解类名，表示以特定注解的目标类方法为连接点，<br />如 @annotation(com.annotation.SysLog) 表示任何标注了@SysLog注解的目标类方法。 |
| args            | 参数为类名，表示以特定目标类方法的入参对象类型为连接点<br />如 args(com.husy.Waiter) 表示所有有且仅有一个按类型匹配于Waiter的入参的方法。 |
| @args           | 参数为类型注解类名，表示以特定的目标类方法入参对象是否标准特定注解为连接点<br />如：@args(com.husy.Monit)表示匹配的方法的参数对象只有一个由@Monit注解 |
| within          | 参数为类名匹配串，表示特定域下的所有连接点<br />如 within(com.baobaotao.service.*) 表示该包名下的所有连接点，也即包中所有类的所有方法 |
| @within         | 参数为类型注解类名，假如目标类按类型匹配于某个类A，且类A标注了特定注解，则目标类的所有连接点匹配这个切点。 <br /> 如@within(com.baobaotao.Monitorable)定义的切点，假如Waiter类标注了 |
| target()        | 参数为类名，假如目标类按类型匹配于指定类，则目标类的所有连接点匹配这个切点，<br />如通过target(com.baobaotao.Waiter)定义的切点，Waiter、以及Waiter实现类NaiveWaiter中所有连接点都匹配该切点。 |
| @target()       | 参数为注解类名，目标类标注了特定注解，则目标类所有连接点匹配该切点。<br />如@target(com.baobaotao.Monitorable)，假如NaiveWaiter标注了@Monitorable，则NaiveWaiter所有连接点匹配切点。 |
| this()          | 参数为类名，代理类按类型匹配于指定类，则被代理的目标类所有连接点匹配切点 |

一般使用最多的是 execution 和 @annotation 两种，其他的笔者也不是特别熟悉。



### 3> 通知类型

AOP由 5 种通知分类： 

*   @**Before**: 前置通知, 在方法执行之前执行
*   @**After**: 后置通知, 在方法执行之后执行，不能访问目标方法的执行结果
*   @**AfterRunning**: 返回通知, 在方法返回结果之后执行，不管正常返回还是异常退出
*   @**AfterThrowing**: 异常通知, 在方法抛出异常之后
*   @**Around**: 环绕通知, 围绕着方法执行，
    *   连接点的参数类型必须是 `ProceedingJoinPoint`，它是JoinPoint子接口，
    *   **在环绕通知中需要明确调用其 proceed() 来执行倍代理的方法。如果忘记，会导致通知执行了，但目标方法没有被执行**
    *   如果需要返回目标方法执行后的结果，即调用 proceed() 的返回值。否则会出现空指针异常

### 4> 代码范例

想实现 AOP 注解编程，需要如下几步：

**第一步： 申明切面类**

*   在类上使用 `@Component`  注解把切面类加入到IOC容器中 
*   在类上使用 `@Aspect` 注解 使之成为切面类

**第二步：申明连接点**

*   在方法上使用 `@Pointcut` 申明一个切入点，指定连接点类型 Execution
*   也可以将连接点类型，定义在通知类型中。不用申明切入点了

第三步：定义通知的处理方法

*   使用 @Before、@After、@AfterRunning、@AfterThrowing、@Around

    @**AfterRunning**: 返回通知, 在方法返回结果之后执行

     　@**AfterThrowing**: 异常通知, 在方法抛出异常之后

     　@**Around**: 环绕通知, 围绕着方法执行



如下代码，系统日志注解解析切面

```java
@Aspect
@Component
public class SysLogAspect {
    @Autowired
    private ISysLogService sysLogService;

    @Pointcut("@annotation(com.husy.annotation.SysLogAnnotation)")
    public void controllerPointCut() { }

    @Around("controllerPointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        //执行目标方法
        Object result = point.proceed();
        //执行时长(毫秒)
        long time = System.currentTimeMillis() - beginTime;
        //保存日志
        saveSysLog(point, time);
        return result;
    }
    
    private void saveSysLog(ProceedingJoinPoint joinPoint, long time) {
        //从切面织入点处通过反射机制获取织入点处的方法
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        //获取切入点所在的方法
        Method method = signature.getMethod();

        //保存日志
        SysLog sysLog = new SysLog();
        //获取操作
        SysLogAnnotation sysLogAnnotation = method.getAnnotation(SysLogAnnotation.class);
        if (sysLogAnnotation != null) {
            String value = sysLogAnnotation.value();
            //注解上的描述
            sysLog.setOperation(value);//保存获取的操作
        }

        //获取请求的类名
        String className = joinPoint.getTarget().getClass().getName();
        //获取请求的方法名
        String methodName = method.getName();
        sysLog.setMethod(className + "." + methodName + "()");

        //请求的参数
        Object[] params = joinPoint.getArgs();
        JSON json = (JSON) JSON.toJSON(params);
        sysLog.setParams(json.toJSONString());

        // 获取token
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();


        //设置IP地址
        sysLog.setIp(IPUtils.getIpAddr(request));

        // 设置操作人
        SysUser sysUser = UserTool.getUser();

        String userId = sysUser.getSysUserId();
        String username = sysUser.getUsername();
        sysLog.setOperator(userId);
        sysLog.setUsername(username);

        sysLog.setTime(time);
        sysLog.setCreateTime(new Date());

        //调用service保存SysLog实体类到数据库
        sysLogService.save(sysLog);
    }   
}
```



## 6、Entity 注解

## 7、自定义注解

自定义注解运用场景：一般用于请求拦截（如：权限拦截）、或者切面处理（如：日志记录）等

范例：

```java
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
public @interface SysLog {
    String value();
    int type() default 0;  //0:查询、1:添加、2:修改、3:删除
}
```



### 1> 格式规范

在Java中创建自定义注解与编写接口很相似，除了它的接口关键字前有个@符号进行申明。

**如 `@interface` **

创建自定义注解注意以下几点：

*   注解方法不能有参数。
*   注解方法的返回类型：只能为基本数据类型，和 String、Enum、Class、Annotation 等数据类型
*   注解方法可以包含默认值，使用  default 修饰。
*   注解可以包含与其绑定的元注解，元注解为注解提供信息



### 2> 元注解

*   **`@Target`**：	   说明了Annotation被修饰的范围，即注解可以作用的地方
*   **`@Retention`**： 什么时候使用该注解
*   **`@Document`**：   注解是否将包含在JavaDoc中
*   **`@Inherited`**：表示注解是否可以被继承



**@Target**

```java
ElementType.ANNOTATION_TYPE // 可以给一个注解进行注解
ElementType.CONSTRUCTOR 	// 可以给一个构造方法进行注解
ElementType.FIELD 			// 可以给一个属性进行注解
ElementType.LOCAL_VARIABLE  // 可以给一个局部变量进行注解
ElementType.METHOD 			// 可以给一个方法进行注解
ElementType.PACKAGE 		// 可以给一个包进行注解
ElementType.PARAMETER 		// 可以给一个方法内的参数进行注解
ElementType.TYPE 			// 可以给一个类型进行注解，比如类、接口、枚举
```

**@Retention**

```java
RetentionPolicy.SOURCE   // 注解仅存在于源码中，在class字节码文件中不包含
RetentionPolicy.CLASS    // 默认的保留策略，注解会在class字节码文件中存在，但运行时无法获得
RetentionPolicy.RUNTIME  // 注解会在class字节码文件中存在，在运行时可以通过反射获取到
```

**@Inherited**：注解可以被继承

**@Document**：能够将注解中的元素包含到 Javadoc 中去。



### 3> 注解解析器

注解解析主要运用反射方式获取注解类信息

```java
 method.getAnnotation(SysLog.class)
 class.getAnnotation(SysLog.class);  
```

**方式一：普通方式解析**

```java
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Document
@Inherited
public @interface SysLog {
    String value();
    int type() default 0;  //0:查询、1:添加、2:修改、3:删除
}

//获得该包下这个类所有信息
Class clazz=Class.forName("com.bjsxt.annotation.SxtStudent");
//获得该类的所有注解
Annotation[]annotation = clazz.getAnnotations();
//获取注解类           根据注解名获取注解
SysLog sysLog =(SysLog) clazz.getAnnotation(SysLog.class);  
//获得类的属性的注解
Field field = clazz.getDeclaredField("studentName");
SxtField sxtField = field.getAnnotation(SysLog.class);
System.out.println(sxtField.columName()+"--"+sxtField.type()+"--"+sxtField.length());
```



**方式 二：通过 Aop 切面处理**

```java
// 申明一个系统操作日志注解
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Document
@Inherited
public @interface SysLog {
    String value();
    int type() default 0;  //0:查询、1:添加、2:修改、3:删除
}

// 系统操作日志注解 处理类
@Aspect
@Component
public class SysLogAspect {
    @Autowired
    private SysLogService sysLogService;

    @Pointcut("@annotation(com.husy.annotation.SysLog)")
    public void controllerPointCut() {}

    @Around("controllerPointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        //执行方法
        Object result = point.proceed();
        //执行时长(毫秒)
        long time = System.currentTimeMillis() - beginTime;

        //保存日志
        saveSysLog(point, time);
        return result;
    }

    private void saveSysLog(ProceedingJoinPoint joinPoint, long time) {
        //从切面织入点处通过反射机制获取织入点处的方法
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        //获取切入点所在的方法
        Method method = signature.getMethod();

        // 实例化一个日志对象
        SysLogDo sysLogDo = new SysLogDo();
        //获取操作
        SysLogAnnotation sysLogAnnotation = method.getAnnotation(SysLog.class);
        if (sysLogAnnotation != null) {
            String value = sysLogAnnotation.value();
            //注解上的描述
            sysLogDo.setOperation(value);//保存获取的操作
        }

        //获取请求的类名
        String className = joinPoint.getTarget().getClass().getName();
        //获取请求的方法名
        String methodName = method.getName();
        sysLogDo.setMethod(className + "." + methodName + "()");

        //请求的参数
        Object[] params = joinPoint.getArgs();
        JSON json = (JSON) JSON.toJSON(params);
        sysLogDo.setParams(json.toJSONString());

        // 获取token
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();


        //设置IP地址
        sysLogDo.setIp(IPUtils.getIpAddr(request));

        // 设置操作人
        SysUser sysUser = UserTool.getUser();

        String userId = sysUser.getSysUserId();
        String username = sysUser.getUsername();
        sysLogDo.setOperator(userId);
        sysLogDo.setUsername(username);

        sysLogDo.setTime(time);
        sysLogDo.setCreateTime(new Date());

        //调用service保存SysLog实体类到数据库
        sysLogService.save(sysLogDo);
    }
}
```









# 资料参考

*   [Spring常用注解总结](https://www.cnblogs.com/xiaoxi/p/5935009.html)
*   [Aspect的Execution表达式](https://zhuchengzzcc.iteye.com/blog/1504014)