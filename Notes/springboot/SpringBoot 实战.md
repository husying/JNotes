SpringBoot 实战



# Spring Boot 简介

- 使用 Spring 项目引导页面可以在几秒构建一个项目
- 方便对外输出各种形式的服务，如 REST API、WebSocket、Web、Streaming、Tasks
- 非常简洁的安全策略集成
- 支持关系数据库和非关系数据库
- 支持运行期内嵌容器，如 Tomcat、Jetty
- 强大的开发包，支持热启动
- 自动管理依赖
- 自带应用监控
- 支持各种 IED，如 IntelliJ IDEA 、NetBeans

Spring Boot 的这些特性非常方便、快速构建独立的微服务。所以我们使用 Spring Boot 开发项目，会给我们传统开发带来非常大的便利度，可以说如果你使用过 Spring Boot 开发过项目，就不会再愿意以以前的方式去开发项目了。

总结一下，使用 Spring Boot 至少可以给我们带来以下几方面的改进：

- Spring Boot 使编码变简单，Spring Boot 提供了丰富的解决方案，快速集成各种解决方案提升开发效率。
- Spring Boot 使配置变简单，Spring Boot 提供了丰富的 Starters，集成主流开源产品往往只需要简单的配置即可。
- Spring Boot 使部署变简单，Spring Boot 本身内嵌启动容器，仅仅需要一个命令即可启动项目，结合 Jenkins 、Docker 自动化运维非常容易实现。
- Spring Boot 使监控变简单，Spring Boot 自带监控组件，使用 Actuator 轻松监控服务各项状态。

总结，Spring Boot 是 Java 领域最优秀的微服务架构落地技术，没有之一。

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



# Springboot AOP配置

@EnableAspectAutoProxy  表示开启*AOP*代理自动配置，如果配@EnableAspectJAutoProxy表示使用*cglib*进行代理对象的生成



使用过Spring注解配置方式的人会问是否需要在程序主类中增加@EnableAspectJAutoProxy来启用，实际并不需要。

因为在AOP的默认配置属性中，spring.aop.auto属性默认是开启的，也就是说只要引入了AOP依赖后，默认已经增加了@EnableAspectJAutoProxy。





# Springboot MVC配置

## 1、Mvc 配置

@EnableWebMvc 注解会开启一些默认配置，如一些ViewResolver或者MessageConverter等

使用 @EnableWebMvc 注解，需要以编程的方式指定视图文件相关配置；

使用 @EnableAutoConfiguration 注解，会读取 application.properties 或 application.yml 文件中的配置。

```java
@Configuration
@EnableWebMvc
@ComponentScan
public class MvcConfig extends WebMvcConfigurationSupport {
    /**
    * 配置视图解析器
    */
    @Bean
    public InternalResourceViewResolver setupViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        /** 设置视图路径的前缀 */
        resolver.setPrefix("/WEB-INF/classes/views");
        /** 设置视图路径的后缀 */
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        return resolver;
    }
    /**
     * 静态文件（js、css、图片）等需要直接访问，重写addResourceHandlers
     * @param registry
     */
    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("classpath:/assets/");
        super.addInterceptors(registry);
    }
}
```

Spring MVC 定制配置需要继承WebMvcConfigurerAdapter 类（springboot2.0  已过期，通过实现WebMvcConfigurer 或者继承WebMvcConfigurationSupport  实现），此类需要@EnableWebMvc 注解开启 SpringMVC 配置支持



**WebMvcConfigurationSupport  比较常用的重写接口**

```java
/** 解决跨域问题 **/
public void addCorsMappings(CorsRegistry registry) ;
/** 添加拦截器 **/
void addInterceptors(InterceptorRegistry registry);
/** 这里配置视图解析器 **/
void configureViewResolvers(ViewResolverRegistry registry);
/** 配置内容裁决的一些选项 **/
void configureContentNegotiation(ContentNegotiationConfigurer configurer);
/** 视图跳转控制器 **/
void addViewControllers(ViewControllerRegistry registry);
/** 静态资源处理 **/
void addResourceHandlers(ResourceHandlerRegistry registry);
/** 默认静态资源处理器 **/
void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer);
```



## 2、web.xml替代配置

* WebApplicationInitializer 是Spring 提供用来配置Servlet 3.0+ 配置的接口，以此来实现**代替web.xml**的位置

* 创建WebApplicationContext，注册配置类，并将其和当前servletContext关联
* 注册Spring MVC 的DispatchServlet

```java
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;

/**
 * @Description: TODO
 * @Author: husy
 * @Date:2019/7/14 13:47
 * @Version 1.0
 */
public class WebInitializer  implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext container) {
        // 创建Spring的root配置环境
        AnnotationConfigWebApplicationContext rootContext =
            new AnnotationConfigWebApplicationContext();
        rootContext.register(MvcConfig.class);
        // 将Spring的配置添加为listener
        container.addListener(new ContextLoaderListener(rootContext));
        // 创建SpringMVC的分发器
        AnnotationConfigWebApplicationContext dispatcherContext =
            new AnnotationConfigWebApplicationContext();
        dispatcherContext.register(DispatcherConfig.class);
        // 注册请求分发器
        ServletRegistration.Dynamic servlet =
            container.addServlet("dispatcher", new DispatcherServlet(dispatcherContext));
        servlet.setLoadOnStartup(1);
        servlet.addMapping("/");
        servlet.setAsyncSupported(true);// 开启异步方法制成
    }
}
```

## 3、拦截器配置

拦截器（Interceptor）实现对每个请求处理前后进行相关业务处理，类似Servlet的Filter

* 通过实现HanlderInterceptor 接口或者继承HandlerInterceptorAdapter类实现自定义拦截器
* 通过重写WebMvcConfigurationSupport 的addInterceptors 方法来注册自定义拦截器

```java
public class DempInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        long startTime = System.currentTimeMillis();
        request.setAttribute("startTime",startTime);
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        long startTime = (long) request.getAttribute("startTime");
        request.removeAttribute("startTime");
        long entTime = System.currentTimeMillis();
        System.out.println("本次请求处理时间为："+ new Long(entTime-startTime)+"ms");
        request.setAttribute("handlingTime",entTime-startTime);
    }
}
```



注册拦截器

见1、Mvc 配置

```java
@Bean
public DempInterceptor dempInterceptor(){
    return new DempInterceptor();
}
@Override
public void addInterceptors(InterceptorsRegistry registry){
    registry.addInterceptors(dempInterceptor());
}
```



## 4、控制器全局建言

通过@ControllerAdvice，可以将控制器的全局配置放置在同一个位置，注解@Controller 的类可以使用@ExceptionHandler、@InitBinder、@ModelAttribute注解到方法上，对所有注解了@RequestMapping的控制器内的方法有效。

```java
@ControllerAdvice
public class ExceptionHandlerAdvice {
    /**
     * 全局异常处理
     * @param exception
     * @return
     */
    @ExceptionHandler(value = Exception.class)
    public ModelAndView exception(Exception exception){
        ModelAndView modelAndView = new ModelAndView("error");
        modelAndView.addObject("errorMessage",exception.getMessage());
        return modelAndView;
    }

    /**
     * 将键值对添加到全局
     * @param model
     */
    @ModelAttribute
    public void addAttributes(Model model){
        model.addAttribute("msg","额外信息");
    }

    /**
    * 过滤掉 某字段
    */
    @InitBinder
    public void initBinder(WebDataBinder webDataBinder){
        webDataBinder.setDisallowedFields("id");
    }
}

```

## 5、 文件上传配置

SpringMvc 可通过MultipartResolver 来上传文件，

在Spring控制器中，通过MultipartFile file 来接收文件，通过MultipartFile[] files 接收多个文件

```java
@Bean
public MultipartResolver multipartResolver (){
    CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
    multipartResolver.setMaxUploadSize(1000);
    return multipartResolver;
}
```



## 6、服务器端推送技术

WebSocket ：双向通信技术

SSE(server send event )：服务器发送事件 和基于Servlet3.0+的异步方法特性





# 注册Servlet、Filter、Listener

当使用嵌入式的Servlet容器（tomcat\jetty等）时，我们通过将Servlet、Filter、Listener声明为SpringBean， 注册通过将ServletRegistrationBean、FilterRegistrationBean、ServletListenerRegistrationBean声明为SpringBean

```java
@Bean
public XxServlet xxServlet(){
	return new XxServlet（）；
}
@Bean
public XxFilter xxFilter(){
	return new XxFilter（）；
}
@Bean
public XxListener xxListener(){
	return new XxListener（）；
}
```



```java
@Bean
public ServletRegistrationBean servletRegistrationBean(){
	return new ServletRegistrationBean(new XxServlet（）,"/xx/*")；
}
@Bean
public XxFilter xxFilter(){
    FilterRegistrationBean registrationBean = new FilterRegistrationBean();
    registrationBean.setFilter(new XxFilter());
    registrationBean.setOrder(2);
	return registrationBean；
}
@Bean
public ServletListenerRegistrationBean<XxListener> servletListenerRegistrationBean(){
	return new ServletListenerRegistrationBean<XxListener>（new XxListener（））；
}
```



# Springboot 事务

Spring 通过`@EnableTransactionManagement` 注解支持声名式事务，使用该注解后，Spring 容器会自动扫描注解**@Transactional** 注解



Spring的事务机制提供一个`PlatformTransactionManager` 接口，不同的数据访问技术的事务使用不同的接口实现

![1563413836956](assets/1563413836956.png)



```java
@Bean(name = "transactionManager")
public DataSourceTransactionManager transactionManager(@Qualifier("dataSource") DataSource dataSource) {
    return new DataSourceTransactionManager(dataSource);
}
@Bean(name = "dataSource")
public DataSource dataSource( ) {
    return DruidDataSourceBuilder.create().build();
}
```





# Springboot Cache

Springboot 支持多种不同的CacheManager

![1563415103412](assets/1563415103412.png)

**注册实现的CacheManager 的 Bean**

```java
@Bean
public EhCacheCacheManager cacheManager(CacheManager ehCacheCacheManager){
    return new EhCacheCacheManager(ehCacheCacheManager)
}
```



**声名式缓存注解**

Spring 开启声名式缓存，只需要在配置类上使用@EnableCaching 注解

```java
@Configuration
@EnableCaching 
public class appConfig{

}
```

![1563415298386](assets/1563415298386.png)

```java
public class DemoServiceImpl {

    /**
     * 新增缓存
     * @param person
     * @return
     */
    @CachePut(value = "person",key = "#person.id")
    public Person save(Person person){
        Person p = demoMapper.save(person);
        System.out.println("为id,key 为："+p.getId()+"数据做了缓存");
        return p;
    }

    /**
     * 删除缓存
     * @param id
     */
    @CacheEvict(value = "person")
    public void save(Long id){
        System.out.println("删除为id,key 为："+id+"的数据缓存");
        demoMapper.delete(person);
    }

    /**
     * 更新缓存
     * @param person
     * @return
     */
    @Cacheable(value = "person",key = "#person.id")
    public Person save(Person person){
        Person p = demoMapper.save(person);
        System.out.println("为id,key 为："+p.getId()+"数据做了缓存");
        return p;
    }
}
```



# Springboot MongoDB

正在建设中----------

# Springboot Redis

正在建设中-----------



# Springboot Batch

正在建设中-----------

# Springboot  异步消息

正在建设中-----------

