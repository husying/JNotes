# Spring  Action

# 一、切面编程 AOP 

# 二、注解 Annotation

Annontation是 Java 5 开始引入的新特性，是一种安全的类似注释的机制，用来将任何的信息或元数据与程序元素（类、方法、成员变量等）进行关联

**jdk的自带注解**（了解即可）

```java
@Override：告诉编译器我重写了接口方法
@Deprecated：告诉编译器这个方法过时了，不建议使用，Ide会在方法上划横线
@SuppressWarnings("unchecked"):关闭方法中出现的警告
```



## 1、常用注解

在 Spring 中要使用，需要注解开启自动扫描功能。其中base-package 为需要扫描的包，可以使用模糊匹配

```java
<context:component-scan base-package="com.husy"/> 
```

常用注解如下：

* **@Configuration**  把一个类作为一个IoC容器，如果某方法上使用了@Bean，就会作为这个Spring容器中的Bean。

* **@ComponentScan**

* **@Bean** ：通过该注解实现依赖注入，@Lazy(true) 可以表示延迟初始化

* **@Scope** 用于指定scope作用域的（用在类上）

* **@Controller**	用于标注控制层组件（如struts中的action）

* **@Service**	用于标注业务层组件

* **@Repository**	用于标注数据访问组件，即DAO组件。

* **@Component**	泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注。

* **@Autowired** 默认按类型装配，如果我们想使用按名称装配，可以结合@Qualifier注解一起使用。

  如下：@Autowired + @Qualifier("personDaoBean") 存在多个实例配合使用

* **@Qualifier**("personDaoBean")   **按名称装配**

* **@Resource**  **默认按名称装配**，当找不到与名称匹配的bean才会按类型装配。

* **@Async**异步方法调用

* **`@SpringBootApplication`**  申明启动类



* @AliasFor	用于属性限制

* @PostConstruct  用于指定初始化方法（用在方法上）
* @PreDestory  用于指定销毁方法（用在方法上）
* @DependsOn：定义Bean初始化及销毁时的顺序
* @Primary：自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常
* @PreDestroy 摧毁注解 默认 单例  启动就加载



### 1> 组件注解

* @Controller 控制层组件申明
* @Service ：服务层组件申明 
* @Repository ：数据访问层组件申明  （表示没怎么用到过:sweat_smile::sweat_smile:）
* @Component ：通用组件申明

如果某个类的头上带有特定的注解【@Component/@Repository/@Service/@Controller】，就会将这个对象作为Bean注册进Spring容器



这些注解的类还可以其他注解进行修饰

* @Scope：对象在spring容器（IOC容器）中的生命周期



* @Configuration：





### 2>自动装配注解

* @Autowired + @Qualifier()
* @Resource



**@Autowired**

* 就是自动装配，其作用是为了消除代码Java代码里面的getter/setter与bean属性中的property。

* 默认按类型匹配的方式，在容器查找匹配的Bean，当**有且仅有一个匹配的Bean**时，Spring将其注入@Autowired标注的变量中，否则需要与 @Qualifier() 搭配使用

**@Qualifier()**

* 容器中有一个以上匹配的Bean，则可以通过@Qualifier注解限定Bean的名称

代码如下：

```java
public class BMWCar implements ICar{
    public String getCarName(){
        return "BMW car";
    }
}
public class BenzCar implements ICar{
    public String getCarName(){
        return "Benz car";
    }
}
public class CarFactory {
    @Autowired
    private ICar car; 
}

```

```xml
<!-- Autowired注解配合Qualifier注解 -->
<bean id="carFactory" class="com.spring.model.CarFactory" />
<bean id="bmwCar" class="com.spring.service.impl.BMWCar" />
<bean id="benz" class="com.spring.service.impl.BenzCar" />
```

通过 @Autowired + @Qualifier() 搭配 代替上述配置，如下：

```java
public class CarFactory { 
    @Autowired
    @Qualifier("bmwCar")
    private ICar car;
}


```

**@Resource**

* @Resource注解与@Autowired注解作用非常相似
* @Resource的装配顺序：
  * 默认通过name属性去匹配bean，找不到再按type去匹配
  * 指定了name或者type则根据指定的类型去匹配bean
  * 指定了name和type则根据指定的name和type去匹配bean，任何一个不匹配都将报错



**@Autowired 和 @Resource 的区别：**

* @Autowired 默认按照byType方式进行bean匹配，
* @Resource 默认按照byName方式进行bean匹配
* @Autowired是Spring的注解，@Resource是J2EE的注解，建议使用@Resource注解，以减少代码和Spring之间的耦合。

---

## 2、Controller层注解

SpringMVC 中控制层的类一般在 控制层注解用 **`@Controller`**  修饰，

SpringBoot 中，可以在的控制层用 **`@RestController`** 修饰

**区别如下**：

* @Controller 注解，在对应的方法上，视图解析器可以解析return 的jsp,html页面，并且跳转到相应页面，若返回 json 等内容到页面，则需要加@ResponseBody注解
* @RestController注解，相当于@Controller+@ResponseBody两个注解的结合，返回json数据不需要在方法前面加@ResponseBody注解了，但使用@RestController这个注解，就不能返回jsp，html页面，视图解析器无法解析jsp，html页面



### 1> @Controller  

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

### 2> @RestController

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

### 3> @RequestMapping

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

* 作用于控制器类或其方法级别
* 映射多请求地址：可以将多个请求映射到一个方法上去
* 绑定参数：可以配合 **`@RequestParam`** 一起使用，可以将请求的参数同处理方法的参数绑定在一起。 
  * **@RequestParam** 的参数
    * defaultValue ：定义默认值
    * required ：参数是否必传
* 处理动态URL：可以同 **`@PathVaraible`** 注解一起使用，用来处理动态的 URI，URI 的值可以作为控制器中处理方法的参数。你也可以使用正则表达式来只处理可以匹配到正则表达式的动态 URI。 
* 定义请求方式，请求的方法比如 GET （默认）, PUT, POST, DELETE 以及 PATCH。 
  * 方法级别的注解变体有如下几个： 
    - **@GetMapping**
    - **@PostMapping**
    - @PutMapping
    - @DeleteMapping
    - @PatchMapping



```java
@RestController  
@RequestMapping("/home")   // 请求地址映射类级别
public class IndexController {  
    // 请求地址映射类方法级别
    // 将多个请求映射到一个方法
    @RequestMapping(value = {  
        "",  
        "/page",  
        "page*",  
        "view/*,**/msg"  
    })  
    String indexMultipleMapping() {  
        return "Hello from index multiple mapping.";  
    } 
    // 绑定请求参数
    // @RequestParam 注解的 required 这个参数定义了参数值是否是必须要传的。 
	@RequestMapping(value = "/id")  
    String getIdByValue(@RequestParam("id", required = false) String personId) {  
        System.out.println("ID is " + personId);  
        return "Get ID from query string of URL with value element";  
    }  

    // 绑定请求参数
    @RequestMapping(value = "/personId")  
    String getId(@RequestParam String personId) {  
        System.out.println("ID is " + personId);  
        return "Get ID from query string of URL without value element";  
    }
    // 定义请求方式
    @RequestMapping(method = RequestMethod.POST)  
    String post() {  
        return "Hello from post";  
    } 
    // 处理动态 URI 
    @RequestMapping(value = "/fetch/{id}", method = RequestMethod.GET)  
    String getDynamicUriValue(@PathVariable String id) {  
        System.out.println("ID is " + id);  
        return "Dynamic URI parameter fetched";  
    }  
}  

```



### 4> @ResponseBody 

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

### 5> @RequestBody

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

* @**Before**: 前置通知, 在方法执行之前执行

* @**After**: 后置通知, 在方法执行之后执行，不能访问目标方法的执行结果
* @**AfterRunning**: 返回通知, 在方法返回结果之后执行，不管正常返回还是异常退出
* @**AfterThrowing**: 异常通知, 在方法抛出异常之后
* @**Around**: 环绕通知, 围绕着方法执行，
  * 连接点的参数类型必须是 `ProceedingJoinPoint`，它是JoinPoint子接口，
  * **在环绕通知中需要明确调用其 proceed() 来执行倍代理的方法。如果忘记，会导致通知执行了，但目标方法没有被执行**
  * 如果需要返回目标方法执行后的结果，即调用 proceed() 的返回值。否则会出现空指针异常

### 4> 代码范例

想实现 AOP 注解编程，需要如下几步：

**第一步： 申明切面类**

- 在类上使用 `@Component`  注解把切面类加入到IOC容器中 
- 在类上使用 `@Aspect` 注解 使之成为切面类

**第二步：申明连接点**

- 在方法上使用 `@Pointcut` 申明一个切入点，指定连接点类型 Execution
- 也可以将连接点类型，定义在通知类型中。不用申明切入点了

第三步：定义通知的处理方法

- 使用 @Before、@After、@AfterRunning、@AfterThrowing、@Around

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
@Document
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

* 注解方法不能有参数。
* 注解方法的返回类型：只能为基本数据类型，和 String、Enum、Class、Annotation 等数据类型
* 注解方法可以包含默认值，使用  default 修饰。
* 注解可以包含与其绑定的元注解，元注解为注解提供信息



### 2> 元注解

* **`@Target`**：	   说明了Annotation被修饰的范围，即注解可以作用的地方
* **`@Retention`**： 什么时候使用该注解
* **`@Document`**：   注解是否将包含在JavaDoc中
* **`@Inherited`**：表示注解是否可以被继承



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



---



# 四、配置 Configuration 

1、多数据源配置

2、Mybatis-Plus 配置

3、事务管理配置

4、异步线程配置

5、线程池配置

 



# 资料参考

* [Spring常用注解总结](https://www.cnblogs.com/xiaoxi/p/5935009.html)
* [Aspect的Execution表达式](https://zhuchengzzcc.iteye.com/blog/1504014)

