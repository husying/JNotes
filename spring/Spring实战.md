SpringBoot 实战



# Springboot线程池

声明：

```java
@Configuration
@EnableAsync
public class BeanConfig {

    @Bean
    public TaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        // 设置核心线程数
        executor.setCorePoolSize(5);
        // 设置最大线程数
        executor.setMaxPoolSize(10);
        // 设置队列容量
        executor.setQueueCapacity(20);
        // 设置线程活跃时间（秒）
        executor.setKeepAliveSeconds(60);
        // 设置默认线程名称
        executor.setThreadNamePrefix("hello-");
        // 设置拒绝策略
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 等待所有任务结束后再关闭线程池
        executor.setWaitForTasksToCompleteOnShutdown(true);
        return executor;
    }
}
```

调用：

```java
@Component
public class Hello {
    @Async
    public void sayHello(String name) {
        LoggerFactory.getLogger(Hello.class).info(name + ":Hello World!");
    }
}
```

进阶，异步线程，返回值

springboot也提供了此类支持，使用实现了ListenableFuture接口的类如AsyncResult来作为返回值的载体

```java
@Async
public ListenableFuture<String> sayHello(String name) {
    String res = name + ":Hello World!";
    LoggerFactory.getLogger(Hello.class).info(res);
    return new AsyncResult<>(res);
}
```

调用返回值：

```java
@Autowired
private Hello hello;

// 阻塞调用
hello.sayHello("yan").get();
// 限时调用
hello.sayHello("yan").get(1, TimeUnit.SECONDS)
```





# Springboot定时任务

```java
@EnableScheduling
@Component
public class ScheduledTask {

    @Scheduled(cron="0 0/1 * * * ?")
    public void testOne() {
        log.info("每分钟执行一次");
    }

    @Scheduled(fixedRate=30000)
    public void testTwo() {
        log.info("每30秒执行一次");
    }
}
```



# Springboot  切面

@EnableAspectAutoProxy  表示开启*AOP*代理自动配置，如果配@EnableAspectJAutoProxy表示使用*cglib*进行代理对象的生成



使用过Spring注解配置方式的人会问是否需要在程序主类中增加@EnableAspectJAutoProxy来启用，实际并不需要。

因为在AOP的默认配置属性中，spring.aop.auto属性默认是开启的，也就是说只要引入了AOP依赖后，默认已经增加了@EnableAspectJAutoProxy。