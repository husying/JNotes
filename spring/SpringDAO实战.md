# Spring DAO实战

# 一、Mybatis 整合

**Mybatis 整合只需要4个步骤：**

*   **引入依赖**
*   **配置datasource**
*   **Dao 接口配置**
*   **接口类实现**

## 1、引入依赖

整合mybatis 需要引入`mybatis-spring-boot-starter`的 Pom 文件

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.0.1</version>
</dependency>
```

这里使用mysql进行数据源存储，所以需要引入`mysql-connector-java`

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```



## 2、datasource配置

**数据源基本配置：**

这里使用`application.properties` 添加相关配置

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/test?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

Spring Boot 会自动加载 `spring.datasource.*` 相关配置，数据源就会自动注入到 sqlSessionFactory 中，sqlSessionFactory 会自动注入到 Mapper 中



## 3、Dao 接口配置

mybatis Mapper接口类扫描有两种方式：

*   `@MapperScan注解`：一般配置在启动类上
*   `@Mapper注解`：一般配置在接口类上

原理可查看：[mybatis源码-@Mapper @MapperScan配置及注入原理](https://www.jianshu.com/p/dba49fc5a741)

## 4、接口类实现

### 1、全注解方式

```java
/**
 * Created by tengj on 2017/4/22.
 * Component注解不添加也没事，只是不加service那边引入LearnMapper会有错误提示，但不影响
 */
@Component
@Mapper
public interface LearnMapper {
    @Insert("insert into learn_resource(author, title,url) values(#{author},#{title},#{url})")
    int add(LearnResouce learnResouce);

    @Update("update learn_resource set author=#{author},title=#{title},url=#{url} where id = #{id}")
    int update(LearnResouce learnResouce);

    @DeleteProvider(type = LearnSqlBuilder.class, method = "deleteByids")
    int deleteByIds(@Param("ids") String[] ids);

    @Select("select * from learn_resource where id = #{id}")
    @Results(id = "learnMap", value = {
            @Result(column = "id", property = "id", javaType = Long.class),
            @Result(property = "author", column = "author", javaType = String.class),
            @Result(property = "title", column = "title", javaType = String.class)
    })
    LearnResouce queryLearnResouceById(@Param("id") Long id);

    @SelectProvider(type = LearnSqlBuilder.class, method = "queryLearnResouceByParams")
    List<LearnResouce> queryLearnResouceList(Map<String, Object> params);

    class LearnSqlBuilder {
        public String queryLearnResouceByParams(final Map<String, Object> params) {
            StringBuffer sql =new StringBuffer();
            sql.append("select * from learn_resource where 1=1");
            if(!StringUtil.isNull((String)params.get("author"))){
                sql.append(" and author like '%").append((String)params.get("author")).append("%'");
            }
            if(!StringUtil.isNull((String)params.get("title"))){
                sql.append(" and title like '%").append((String)params.get("title")).append("%'");
            }
            System.out.println("查询sql=="+sql.toString());
            return sql.toString();
        }

        //删除的方法
        public String deleteByids(@Param("ids") final String[] ids){
            StringBuffer sql =new StringBuffer();
            sql.append("DELETE FROM learn_resource WHERE id in(");
            for (int i=0;i<ids.length;i++){
                if(i==ids.length-1){
                    sql.append(ids[i]);
                }else{
                    sql.append(ids[i]).append(",");
                }
            }
            sql.append(")");
            return sql.toString();
        }
    }
}
```

有些复杂点需要动态SQL语句，就需要使用@InsertProvider、@UpdateProvider、@DeleteProvider、@SelectProvider等注解。就比如上面方法中根据查询条件是否有值来动态添加sql的

### 2、 xml 配置文件方式

**properties文件：**

```properties
# datasource 
spring.datasource.url=jdbc:mysql://localhost:3306/db_local?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# mapper.xml 文件扫描路径
mybatis.mapper-locations=classpath:mapper/*.xml
```

注意了：很多博文中都配置了 `mybatis.type-aliases-package=com.husy.domain`这类路径，但是笔者发现，不配置也是可以的。经过笔者查阅资料，只要mapper.xml 中使用的是全限定名，就不需要别名

别名的具体使用带研究…



**接口类：**

```java
public interface SystemUserMapper {
	int insert(SystemUser user);
	List<SystemUser> findSystemUsers(@Param("params") HashMap<String,Object> map);
}
```



**mapper.xml :**

在springboot中，需要将该类文件放置在resource目录下（原因未知，待研究），这里放在resource/mapper 下

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.husy.mapper.SystemUserMapper">
    <resultMap id="systemUserMap" type="com.husy.domain.SystemUser" >
        <id column="user_id" property="userId"  />
        <result column="user_account" property="userAccount" />
        <result column="user_password" property="userPassword"  />
        <result column="user_phone" property="userPhone"  />
    </resultMap>

    <select id="findSystemUsers" resultMap="systemUserMap">
         SELECT
            user_id,
            user_account,
            user_password,
            user_phone
         FROM t_system_user
    </select>
    <insert id="insert" parameterType="com.husy.domain.SystemUser" 
            useGeneratedKeys="true" keyProperty="userId">
        INSERT INTO t_system_user(user_account,user_password,user_phone)
        VALUES(#{userAccount}, #{userPassword}, #{userPhone})
    </insert>
</mapper>
```



# 二、分页插件

mybatis 分页有4种方式：

*   **数组分页**：查出所有的数据，然后通过截取；缺点：一次返回所有数据，当数据量较大时，影响性能
*   **SQL脚本分页**：通过limit 在SQL中进行分页查询，缺点：维护性查，不利于统一管理
*   **拦截器分页**：目前最佳分页方式，适应于大量数据的场景
*   **RowbBounds分页**：最简单的一种分页方式；缺点，不适用与大量数据分页



这里使用拦截器分页方式

*   Mybatis-PageHelper插件分页，如果你使用 Spring Boot 可以参考： [pagehelper-spring-boot-starter](https://github.com/pagehelper/pagehelper-spring-boot)
*   Mybatis-plus 插件分页
*   自定义拦截器分页

## 1、PageHelper 插件分页

## 2、Mybatis-plus 插件分页

## 3、自定义拦截器分页

分页错误：

```java
MyBatis3.4.0以上的分页插件错误：Could not find method on interface org.apache.ibatis.executor.statement.StatementHandler named prepare. Cause: java.lang.NoSuchMethodException: org.apache.ibatis.executor.stateme
```

官方的解释如下：

```java
In 3.4.0, StatementHandler#prepare(Connection) has been changed to StatementHandler#prepare(Connection,Integer).

See https://github.com/mybatis/mybatis-3/blob/master/src/main/java/org/apache/ibatis/executor/statement/StatementHandler.java#L33-L34 .

```

MyBatis3.4.0以上分页 **多了一个Interger.class的参数**

```java
@Intercepts({ @Signature(type = StatementHandler.class, method = "prepare", args = { Connection.class, Integer.class }) })  //3.40之后的写法
```