# IOC

即“**控制反转**”，指将对象的创建交给外部容器控制。之前自己手动的创建对象，现在变成由Spring容器帮助创建生成新的对象

分析一下：

　　●谁控制谁，控制什么：当然是IoC 容器控制了对象；控制什么？那就是主要控制了外部资源获取（不只是对象包括比如文件等）。

　　●为何是反转，哪些方面反转了：原来是主动获取对象，现在通过容器帮我们查找及注入依赖对象，对象只是被动的接受依赖对象，所以依赖对象的获取被反转了。



```java
Peron p1 = new Person();    ----->自己手动完成
Person p2 = spring容器.get***();  ----->由spring容器创建
```



# DI

即“**依赖注入**”，由容器动态的将某个依赖关系注入到组件之中。目的是为了提升组件重用的频率，并为系统搭建一个灵活、可扩展的平台。



分析一下：

　　●谁依赖于谁：应用程序依赖于IoC容器；

　　●为什么需要依赖：应用程序需要IoC容器来提供对象需要的外部资源；

　　●谁注入谁：IoC容器注入应用程序某个对象，应用程序依赖的对象；

　　●注入了什么：注入某个对象所需要的外部资源（包括对象、资源、常量数据）。



 依赖注入一般注入可以是基本类型、字符串、对象的引用、集合（List,Set,Map）



# Bean的获取方式

1. 通过读取XML文件反射生成对象 
2. 通过Spring提供的utils类获取ApplicationContext对象 
3. 继承自抽象类ApplicationObjectSupport 
4. 继承自抽象类WebApplicationObjectSupport 
5. 实现接口ApplicationContextAware（推荐）



**通过读取XML文件**

```xml
<bean id="userService" class="com.cloud.service.impl.UserServiceImpl"></bean>
```

```java
ApplicationContext context= new FileSystemXmlApplicationContext("applicationContext.xml");
context.getBean("userService");
```



**通过Spring提供的utils类获取ApplicationContext对象** 

```java
ApplicationContext context1= WebApplicationContextUtils.getRequiredWebApplicationContext(ServletContext sc);
ApplicationContext context2= WebApplicationContextUtils.getWebApplicationContext(ServletContext sc);
context1.getBean("beanId");
context2.getBean("beanId");
```

这样的方式适合于Spring框架的B/S系统，通过ServletContext对象获取ApplicationContext对象。

上面两个工具方式的差别是，前者在获取失败时抛出异常。后者返回null。





**继承自抽象类ApplicationObjectSupport** 

抽象类ApplicationObjectSupport提供getApplicationContext()方法

```java
@Component
public class SpringBeanUtil extends ApplicationObjectSupport {
    //提供一个接口，获取容器中的Bean实例，根据名称获取
    public Object getBean(String beanName){
        return getApplicationContext().getBean(beanName);
    }
}
```



**继承自抽象类WebApplicationObjectSupport**

类似ApplicationObjectSupport 的方法。调用getWebApplicationContext()获取WebApplicationContext



**实现接口ApplicationContextAware**

实现该接口的setApplicationContext(ApplicationContext context)方法，并保存ApplicationContext 对象。Spring初始化时，扫描到该类，就会通过该方法将ApplicationContext对象注入

```java
/**
 * @description: Spring Bean 对象工具
 * @author: husy
 * @date 2020/1/13
 */
@Component
public class SpringBeanUtil implements ApplicationContextAware {
   private static ApplicationContext applicationContext;
   @Override
   public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
      SpringBeanUtil.applicationContext=applicationContext;
   }

   public static <T> T getBean(String beanName) {
      if(applicationContext.containsBean(beanName)){
         return (T) applicationContext.getBean(beanName);
      }else{
         return null;
      }
   }

   public static <T> Map<String, T> getBeansOfType(Class<T> baseType){
      return applicationContext.getBeansOfType(baseType);
   }
}
```



# Bean的创建方式

* 通过构造方法创建对象（默认）
* 通过静态工厂创建对象（必须要有静态方法）
* 通过实例工厂创建对象--先实例工厂，再创建对象



**构造方法创建对象**

```xml
<bean id="accountService" class="com.husy.service.impl.AccountServiceImpl"/>
```



**静态工厂创建对象**

```xml
<bean id="staticBeanFactory " class="com.husy.factory.StaticBeanFactory" factory-method="createInstance"/>
```

```java
public class StaticBeanFactory {
    public static ClientService createInstance() {
        return clientService;
    }
}
```



**实例工厂创建对象**

```xml
<!-- 实例工厂创建 -->
<bean id="instanceBeanFactory" class="com.husy.factory.InstanceBeanFactory"/>
<bean id="accountService" factory-bean="instanceBeanFactory" factory-method="getBean"/>
```

```java
public class InstanceBeanFactory {
    public AccountService getBean(){
        return new AccountServiceImpl();
    }
}
```

