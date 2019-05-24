# 注解

# 持久层注解

配置文件设置，自动扫描持久层对象，具体配置详情见官网[MyBatis-Plus](https://mp.baomidou.com/)

```yml
#mybatis
mybatis-plus:
  mapper-locations: classpath*:mapper/**/*.xml
  #实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: com.ycxc.modules.*.entity
```

实体类：

```java
@TableName("t_user")
public Class Person{
	@TableId("user_name")
    private Long userId;
    @TableField("user_name")
    private String userName;
}
```



# 自定义注解

```java
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface Me {
    String value();
}
```

注解的定义：用@interface表示。

元注解：@interface上面按需要注解上一些东西，包括@Retention、@Target、@Document、@Inherited四种。

**@Target**

指定了注解运用的地方

```java
ElementType.ANNOTATION_TYPE // 可以给一个注解进行注解
ElementType.CONSTRUCTOR 	// 可以给构造方法进行注解
ElementType.FIELD 			// 可以给属性进行注解
ElementType.LOCAL_VARIABLE  // 可以给局部变量进行注解
ElementType.METHOD 			// 可以给方法进行注解
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



**注解解析器**

注解解析主要运用反射方式，一般用于请求拦截（如：权限校验）、或者切面处理（如日志记录）



