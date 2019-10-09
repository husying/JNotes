# springboot(二) 配置文件

# @Value读取配置文件

我们最常见读取配置文件内的信息时，通常使用@Value ，如下：

application.properties：

```properties
my.name=husy
```

java 代码

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class HusyDemoApplicationTests {
	@Value("${my.name}")
	private String name;
	@Test
	public void contextLoads() {
		System.out.println(name);
	}
}
```

该方式有个不好的地方，就是在使用时，需要注意@Value注解是否生效的问题。一般使用有以下注意事项

* 不能作用于静态变量（static）
* 不能作用于常量（final）
* 不能在非注册的类中使用（类需要被注册在spring上下文中，如用@Service,@RestController,@Component等）
* 使用这个类时，只能通过依赖注入的方式，用new的方式是不会自动注入这些配置的



为什么呢？ 我们可以通过Spring在初始化Bean的过程了解

![img](assets/9770936-3d0012126b210ec2.webp)

解释一下：

1. 读取定义
2. Bean Factory Post Processing
3. 实例化
4. 属性注入
5. Bean Post Processing

这个问题的原因就很明显了。@Value注入是在第四步，而初始化变量是在第三部，这个使用变量还没有被注入，自然为null了。



# Environment读取配置文件

Environment会加载application.properties和application-$(profile).properties文件

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class HusyDemoApplicationTests {
	@Autowired
	private Environment environment;

	@Test
	public void contextLoads() {
		System.out.println("name:"+environment.getProperty("my.name")
                           +",age:"+environment.getProperty("my.age"));
	}
}
```



# 将配置文件装配到实体类

当有读取很多配置属性时，如果逐个读取属性会非常麻烦，通常会把这些属性作为一个变量名来创建一个JavaBean 的变量

如在application.yml 中属性如下：

> my:
>
> ​	name: husy
>
> ​	age: ${random.int}

如何赋值给JavaBean 对象，代码如下：

```java
@Data
@Component
@ConfigurationProperties(prefix = "my")
public class ConfigBean {
	private  String name;
	private  int age;
}
```

@ConfigurationProperties 表明该类为配置属性类，并配置前缀为prefix对应的属性

@Component 将bean注入容器，如果没有，可在启动类上加上@EnableConfigurationProperties注解

如下：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
@EnableConfigurationProperties({ConfigBean.class})
public class HusyDemoApplicationTests {
	@Autowired
	ConfigBean configBean;
	@Test
	public void contextLoads() {
		System.out.println(configBean.toString());
	}
}
```



# 多个配置文件读取

当我们有多个配置文件时，通过@PropertySource指定读取的配置文件，如下：

```java
@Data
@Component
@PropertySource(value = "classpath:test.properties")
@ConfigurationProperties(prefix = "my")
public class ConfigBean {
	private  String name;
	private  int age;
}
```



# 多环境的配置文件

在实际开发过程中，可能有多个不同的环境配置文件，Spring Boot 支持启动时在配置文件application.yml中指定环境的配置环境，配置文件格式为application-{profile}.properties，其中{profile}对应环境标识，例如：

>application-test.properties     测试环境
>
>application-dev.properties     开发环境
>
>application-prod.properties   生产环境

如何指定使用哪个环境配置文件，只需要在application.yml 中配置上spring.Profiles.active，该配置标识系统将采用哪个profiles。



当然我们也可以通过  java -jar 这种方式启动程序，并指定程序的配置文件，启动命令如下：

> java -jar springbootdemo.jar --spring.profiles.acitve=dev