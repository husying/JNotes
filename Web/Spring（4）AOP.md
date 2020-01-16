



> 在软件业，AOP为Aspect Oriented Programming的缩写，意为：面向切面编程，通过预编译方式和运行期间动态代理实现程序功能的统一维护的一种技术。AOP是OOP的延续，是软件开发中的一个热点，也是Spring框架中的一个重要内容，是函数式编程的一种衍生范型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。
>
> ------------- 以上来自百度百科

Spring AOP 是通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术；利用AOP可以对业务逻辑的各个部分进行隔离，降低耦合度，提高程序的可重用性，同时提高了开发的效率；您只需更改配置文件即可添加/删除关注点，而无需重新编译完整的源代码（如果您要使用要求XML配置的方面）。

**主要应用场景**：日志记录，性能统计，安全控制，事务处理，异常处理等等。



# AOP 术语

* **通知（Advice）**：定义了在 Pointcut 里面定义的程序点具体要做的操作，换句话说就是你想要的功能
* **连接点（Joinpoint）** ：通俗点就是spring允许你使用通知的地方
* **切面（Aspect）**： 是通知和切入点的结合；简单的就是：通知说明了干什么和什么时候干（什么时候通过方法名中的before,after，around等就能知道），而切入点说明了在哪干（指定到底是哪个方法），这就是一个完整的切面定义
* **切入点（Pointcut）** ：通知将要发生的地方
* **引入（Intruduction）** ： 在不修改类代码的前提下，为类添加新的方法和属性
* **目标（Target）** ： 引入中所提到的目标类，也就是要被通知的对象
* **代理（Proxy）** ：一个类被AOP织入后生成出了一个结果类，它是融合了原类和增强逻辑的代理类。
* **织入（Weaving）** ：织入就是将增强添加到目标类具体连接点上的过程。



# 通知类型

Spring AOP总共有 5 种通知分类，如下： 

1. **Before**： 前置通知，在方法执行之前执行
2. **After**：后置通知，在方法执行之后执行，不能访问目标方法的执行结果
3. **AfterRunning**： 返回通知，在方法返回结果之后执行，不管正常返回还是异常退出
4. **AfterThrowing**：异常通知，在方法抛出异常之后
5. **Around**：环绕通知， 围绕着方法执行，连接点的参数类型必须是 ProceedingJoinPoint，它是JoinPoint子接口，在环绕通知中需要明确调用其 proceed() 来执行倍代理的方法。如果忘记，会导致通知执行了，但目标方法没有被执行如果需要返回目标方法执行后的结果，即调用 proceed() 的返回值。否则会出现空指针异常



# 切入点类型

* execution：用于匹配方法执行连接点。这是使用Spring AOP时使用的主要切入点指示符。
* within：限制匹配某些类型中的连接点（使用Spring AOP时在匹配类型中声明的方法的执行）。
* this：限制与连接点的匹配（使用Spring AOP时执行方法），其中bean引用（Spring AOP代理）是给定类型的实例。
* target：限制与连接点的匹配（使用Spring AOP时执行方法），其中目标对象（被代理的应用程序对象）是给定类型的实例。
* args：限制与连接点的匹配（使用Spring AOP时执行方法），其中参数是给定类型的实例。
* @target：限制与连接点的匹配（使用Spring AOP时执行方法），其中执行对象的类具有给定类型的注释。
* @args：限制与连接点的匹配（使用Spring AOP时执行方法），其中传递的实际参数的运行时类型具有给定类型的注释。
* @within：限制匹配到具有给定注释的类型中的连接点（使用Spring AOP时在具有给定注释的类型中声明的方法的执行）。
* @annotation：限制连接点的匹配，其中连接点的主题（在Spring AOP中执行的方法）具有给定的注释。



以使用&&, ||组合切入点表达式，如下：

```java
@Pointcut("execution(public * *(..))")
 private void anyPublicOperation() {}
 ​
 @Pointcut("within(com.xyz.someapp.trading..*)")
 private void inTrading() {}
 ​
 @Pointcut("anyPublicOperation() && inTrading()")
 private void tradingOperation() {}
```

anyPublicOperation 如果方法执行连接点表示任何公共方法的执行，则匹配。

inTrading 如果方法执行在交易模块中，则匹配。

tradingOperation 如果方法执行表示交易模块中的任何公共方法，则匹配。



# AOP代理

AOP代理主要分为**静态代理**和**动态代理**；静态代理的代表为AspectJ；而动态代理则以Spring AOP为代表。

动态代理分为：**JDK的动态代理和CGLIB动态代理**；Spring AOP默认会采用JDK的动态代理实现AOP

注意：

> 如果目标对象实现了接口，默认情况下会采用JDK动态代理实现AOP；可以强制使用CGLIB实现AOP
>
> 如果目标对象没有实现了接口，必须采用CGLIB库，Spring会自动在JDK动态代理和CGLIB之间转换

JDK动态代理要比cglib代理执行速度快，但性能不如cglib，一般单例模式用cglib比较好



## JDK动态代理实现

原理使用反射机制，通过InvocationHandler.invoke() 接口实现

这里先定义接口和实现类

```java
public interface TestService {
    public int add();    
}
```

```java
public class TestServiceImpl implements TestService {
    @Override
    public int add() {
        System.out.println("开始执行add..."); 
        return 0;
    }
}
```

定义代理类

```java
public class JDKDynamicProxy implements InvocationHandler {
     //被代理的目标对象
    private Object proxyObj;  

    public Object newProxy(Object proxyObj){  
       this.proxyObj = proxyObj;
        //返回一个代理对象  
       return Proxy.newProxyInstance(proxyObj.getClass().getClassLoader(),proxyObj.getClass().getInterfaces(),this);  
   }  

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {       
         before(); 
         Object object = method.invoke(this.proxyObj,args);  // 通过反射机制调用目标对象的方法
         after();       
         return object;  
     }

     public void before(){
          System.out.println("开始执行目标对象之前..."); 
     }

     public void after(){
         System.out.println("开始执行目标对象之后..."); 
     }
 }
```

测试

```java
public static void main(String[] args) {
      //我们要代理的真实对象
      TestService testService = new TestServiceImpl();        
      //testJDKProxyService.add();//不是用代理    
    
     JDKDynamicProxy JDKDynamicProxyTarget = new JDKDynamicProxy();
     TestService testServiceProxy = (TestService) JDKDynamicProxyTarget.newProxy(testService);
     //执行代理类的方法  
     testServiceProxy.add();
 }
```

JDK动态代理源码分析可以参考 https://blog.csdn.net/yhl_jxy/article/details/80586785 写的非常详细



## CGLIB代理

**cglib 代理需要集成 cglib 依赖，主要通过MethodIntercepto接口实现**

定义一个实现类

```java
public class TestCGLIBServiceImpl {
    public int add() {
        System.out.println("开始执行add..."); 
        return 0;
    }
}
```

定义cglib代理类

```java
public class CGLIBProxy implements MethodInterceptor{
    @Override
    public Object intercept(Object object, Method method, Object[] args,MethodProxy methodproxy) throws Throwable {        
        System.out.println("======插入前置通知======");
        Object object = methodProxy.invokeSuper(sub, objects);
        System.out.println("======插入后者通知======");
        return object;
    }   
}
```



测试

```java
public static void main(String[] args) {
    // 通过CGLIB动态代理获取代理对象的过程
    Enhancer enhancer = new Enhancer();
    // 设置enhancer对象的父类
    enhancer.setSuperclass(HelloService.class);
    // 设置enhancer的回调对象
    enhancer.setCallback(new MyMethodInterceptor());
    // 创建代理对象
    HelloService proxy= (HelloService)enhancer.create();
    // 通过代理对象调用目标方法
    proxy.add();
}
```

CGLIB动态代理源码分析可以参考：https://blog.csdn.net/yhl_jxy/article/details/80633194

## AOP代码示例

```java
@Aspect
@Component
public class MyAspect {
    /** 前置通知：目标方法执行之前执行以下方法体的内容 */ 
    @Before("execution(* com.qcc.beans.aop.*.*(..))")   
    public void beforeMethod(JoinPoint jp){        
        String methodName = jp.getSignature().getName();        
        System.out.println("【前置通知】the method 【" + methodName + "】 begins with " + Arrays.asList(jp.getArgs()));  
    }    
    /** 后置通知：目标方法执行之后执行以下方法体的内容，不管是否发生异常。*/    
    @After("execution(* com.qcc.beans.aop.*.*(..))")    
    public void afterMethod(JoinPoint jp){        
        System.out.println("【后置通知】this is a afterMethod advice...");   
    }  
    /** 返回通知：目标方法正常执行完毕时执行以下代码*/  
    @AfterReturning(value="execution(* com.qcc.beans.aop.*.*(..))",returning="result") 
    public void afterReturningMethod(JoinPoint jp, Object result){        
        String methodName = jp.getSignature().getName();        
        System.out.println("【返回通知】the method 【" + methodName + "】 ends with 【" + result + "】");    
    }    
       
    /**异常通知：目标方法发生异常的时候执行以下代码*/   
    @AfterThrowing(value="execution(* com.qcc.beans.aop.*.*(..))",throwing="e")   
    public void afterThorwingMethod(JoinPoint jp, NullPointerException e){     
        String methodName = jp.getSignature().getName();    
        System.out.println("【异常通知】the method 【" + methodName + "】 occurs exception: " + e);  
    }
}
```



# 资料参考

* https://blog.csdn.net/q982151756/article/details/80513340
* https://blog.csdn.net/ctwy291314/article/details/82017408