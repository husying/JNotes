# SpringAnnotation

开启注解，首先需要引入  xmlns:context="http://www.springframework.org/schema/context"

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

</beans>
```









@ConstructorProperties：不推荐

*   该注释用于构造函数上，显示该构造函数的参数与getter方法相对应

```java
public class Point {
    private final int x，y;
    @ConstructorProperties（{“x”，“y”}）  --> 相当于xml中的注入
    public Point（int x，int y）{
        this.x = x;
        this.y = y;
    }
    public int getX（）{ return x; }
    public int getY（）{ return y; } 
}
```
```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg name="years" value="7500000"/>
    <constructor-arg name="ultimateAnswer" value="42"/>
</bean>
```

@Required : 表示是否必须。5.1开始被弃用

### `@Autowired`

应用于构造函数，setter方法、具有任意名称和多个参数的方法、或者**引入bean依赖**

在`@Autowired`，`@Inject`，`@Value`，和`@Resource`注释由Spring处理 `BeanPostProcessor`实现。这意味着您无法在自己的类型`BeanPostProcessor`或`BeanFactoryPostProcessor`类型（如果有）中应用这些注释。必须使用XML或Spring `@Bean`方法显式地“连接”这些类型。



### `@Primary`

自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常



### `@Qualifier`

在各个构造函数参数或方法参数上指定注释



### `@Configuration`

 `@Bean`



### `@Resource`

### `@Component`

`@Component`，`@Service`，和 `@Controller`、`@Repository`， `@Configuration`

`@Repository`，`@Service`和，`@Controller`是`@Component`更具体的用例的专业化（分别在持久性，服务和表示层）

`@Component`是任何Spring管理组件的通用构造型

`@RestController`Spring MVC 的注释由`@Controller`和 组成`@ResponseBody`。



自动检测，`@ComponentScan`到您的`@Configuration`类

可代替

```xml
<context:component-scan base-package="org.example"/>
```

使用`<context:component-scan>`隐式启用功能 `<context:annotation-config>`。`<context:annotation-config>`使用时通常不需要包含 元素`<context:component-scan>`。



### `@Import`

### `@Profile`

### `@PropertySource`

该`@PropertySource` 注解提供便利和声明的机制添加`PropertySource` 到Spring的`Environment`。



### `@Async`

### `@ModelAttribute`

### @Validated

@RequestBody

@ResponseBody

@RequestParam 