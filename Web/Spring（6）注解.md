



在Spring中的注解有很多，如下进行分类说明一下



### 用于标注组件

@Controller：用于标注控制层组件

@Service	：用于标注业务层组件

@Repository：用于标注数据访问组件，即DAO组件。

@Component：泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注。

@Configuration ：声明当前类是一个配置类



### 用于依赖注入

@Autowired 默认按类型装配，如果我们想使用按名称装配，可以结合@Qualifier注解一起使用。

@Qualifier("personDaoBean")   按名称装配，如下：@Autowired + @Qualifier("personDaoBean") 存在多个实例配合使用

@Resource  默认按名称装配，当找不到与名称匹配的bean才会按类型装配。

@Inject ：（不常用）根据类型进行自动装配，按名称装配需要@Named结合使用时



**Autowired 和 Resource  的区别**

@Autowired 默认按照byType方式进行bean匹配，

@Resource 默认按照byName方式进行bean匹配，找不到再按type去匹配

@Autowired是Spring的注解，@Resource是J2EE的注解，建议使用@Resource注解，以减少代码和Spring之间的耦合。



### 用于控制层

**@RequestMapping**：映射多请求地址，作用于控制器类或其方法级别

**@RequestParam**：将请求的参数同处理方法的参数绑定

**@PathVariable**：用来处理动态的 URI，URI 的值可以作为控制器中处理方法的参数，可以使用正则表达式

**@RequestBody**：作用在形参列表上，用于将前台发送过来固定格式的数据【xml 格式或者 json等】封装为对应的 JavaBean 对象

**@ReponseBody**：方法将数据转为 json 数据直接写入 HTTP response body

注意：@RequestMapping 可用@GetMapping、@PostMapping、@PutMapping、@DeleteMapping、@PatchMapping 替代，这5种 是指用相应的请求方式进行映射



### 用于AOP 注解

@Aspect 声明一个切面

@After、@Before、@Around 定义建言（advice），可直接将拦截规则(切点) 作为参数

@PointCut 定义拦截规则

@EnableAspectAutoProxy  表示开启AOP代理自动配置，如果配@EnableAspectJAutoProxy表示使用cglib进行代理对象的生成



### 用于多线程注解

@EnableAsync 注解开启异步任务支持

@Async 声明该方法是个异步方法



### 用于定时任务注解

@EnableSching 开启计划任务支持

@Scheduled 声明一个计划任务



### 其他

@Transcational  事务处理

@Cacheable  数据缓存

@Async异步方法调用

@SpringBootApplication  申明启动类

@AliasFor	用于属性限制

@ComponentScan

@PostConstruct  用于指定初始化方法（用在方法上）

@PreDestory  用于指定销毁方法（用在方法上）

@DependsOn：定义Bean初始化及销毁时的顺序

@Primary：自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常

@PreDestroy 摧毁注解 默认 单例  启动就加载