# **Spring** 介绍

它是一个全面的、企业应用开发一站式的解决方案，贯穿表现层、业务层、持久层。但是 Spring仍然可以和其他的框架无缝整合。

![](Spring（1）介绍/2019-06-08_113939.png)

**Spring 的优势**

* 低侵入 / 低耦合 （降低组件之间的耦合度，实现软件各层之间的解耦）
* 支持声明式事务管理（基于切面和惯例）
* 方便集成其他框架（如MyBatis、Hibernate）
* 降低 Java 开发难度



# Bean 生命周期

> 1. 容器寻找Bean的定义信息并将其实例化
> 2. 使用依赖注入，spring按照Bean定义信息配置Bean的所有属性
> 3. 如果Bean实现了BeanNameAware接口，工厂调用Bean的SetBeanName()方法传递Bean的ID
> 4. 如果Bean实现了BeanFactoryAware接口，工厂调用setBeanFactory()方法传入工厂自身
> 5. 如果BeanPostProcessor和Bean关联，那么其postProcessBeforeInitialization()方法将被调用
> 6. 如果Bean指定了init-method方法，将被调用
> 7. 最后，如果有BeanPostProcessor和Bean关联,那么其postProcessAfterInitialization()方法将被调用



此时，Bean已经可以被应用系统使用，并将被保留在BeanFactory中知道他不再被需要。有两种可以将其从BeanFactory中删除掉的方法

①　如果Bean实现了DisposableBean接口，destroy()方法将被调用

②　如指定了定制的销毁方法，就调用这个方法