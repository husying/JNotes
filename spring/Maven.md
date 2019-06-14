# Maven 

# Maven 基础概念

*   Project：指功能，被定义为工程对象模型（Project Object Model，POM）
*   POM：maven 核心文件，位于工程跟目录
*   GroupId：指一个工程在全局中的唯一标识符，一般是工程名
*   Artifact：指构建，需要被使用的 Artifact 都要放在仓库中，否则Maven 无法找到
*   Dependency：依赖
*   Plug-in：maven的插件集合
*   Repository：仓库，即放置Artifact的地方

# 常用maven依赖

## 图片验证码

1、Google Kaptcha

```xml
<dependency>
    <groupId>com.github.axet</groupId>
    <artifactId>kaptcha</artifactId>
    <version>${kaptcha.version}</version>
</dependency>
```





# SpringBoot 依赖

[全部依赖](https://docs.spring.io/spring-boot/docs/2.2.0.BUILD-SNAPSHOT/reference/html/using-spring-boot.html#using-boot-maven)

常用依赖如下





<scope>

在POM 4中，<dependency>中还引入了<scope>，它主要管理依赖的部署。目前<scope>可以使用5个值： 

* compile，缺省值，适用于所有阶段，会随着项目一起发布。 
* provided，类似compile，期望JDK、容器或使用者会提供这个依赖。如servlet.jar。 
* runtime，只在运行时使用，如JDBC驱动，适用运行和测试阶段。 
* test，只在测试时使用，用于编译和运行测试代码。不会随项目发布。 
* system，类似provided，需要显式提供包含依赖的jar，Maven不会在Repository中查找它。