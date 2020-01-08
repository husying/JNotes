# JAVA-JDBC

# 一、JDBC概念

JDBC（Java DataBase Connectivity,java数据库连接）是一种用于执行SQL语句的Java API，是Java十三个规范之一；提供了一种基准，据此可以构建更高级的工具和接口，使数据库开发人员能够编写数据库应用程序，同时，JDBC也是个商标名。



[Java十三个规范参考博文](https://blog.csdn.net/u010168160/article/details/46883089)

# 二、JDBC 操作步骤

使用jdbc操作数据库，一般分为：

第一步：加载数据库驱动

第二步：建立数据库连接

第三步：获取Statement  或者PreparedStatement 执行器对象，执行SQL脚本

第四步：处理结果集ResultSet

第五步：关闭连接，释放资源



## 1、加载数据库驱动

### 1> 常用数据库驱动

**MySQL驱动：**

* 驱动版本在6.0时之前使用：com.mysql.jdbc.Driver；

  * ```properties
    jdbc.driverClassName=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/database?useUnicode=true&characterEncoding=utf8&useSSL=false
    ```

    

* 驱动版本是6.0之后使用 ：com.mysql.cj.jdbc.Driver，且要求连接时加上时区

  * ```properties
    jdbc.driverClassName=com.mysql.cj.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/database?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&useSSL=false
    ```

  * 如果设定serverTimezone=UTC，会比中国时间早8个小时，如果在中国，可以选择Asia/Shanghai或者Asia/Hongkong

  * ```properties
    jdbc.url=jdbc:mysql://localhost:3306/database?serverTimezone=Shanghai&useUnicode=true&characterEncoding=utf8&useSSL=false
    ```

**SQLserver驱动：**

* com.microsoft.jdbc.sqlserver.SQLServerDriver

* ```properties
  jdbc.driverClassName=com.microsoft.jdbc.sqlserver.SQLServerDriver
  jdbc.url=jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=database
  ```

**Oracle驱动：**

* oracle.jdbc.driver.OracleDriver

* ```properties
  jdbc.driverClassName=oracle.jdbc.driver.OracleDriver
  jdbc.url=jdbc:oracle:thin:@localhost:1521:database
  ```



### 2> 数据库加载方式

数据库驱动有3种加载方式，具体如下：

* DriverManager.registerDriver(new com.mysql.jdbc.Driver()); 
* System.setProperty("jdbc.drivers","com.mysql.jdbc.Driver"); 
* **Class.forName("com.mysql.jdbc.Driver");**



**Class.forName()：（推荐）** 

* 优点：不会对具体的驱动类产生依赖

**DriverManager.registerDriver**

* 缺点：会造成DriverManager中产生两个一样的驱动，并会对具体的驱动类产生依赖

加载两次原因：加载的时候注册一次驱动，实例化驱动对象时又注册一次。所以两次

```java 
//如：new com.mysql.jdbc.Driver类中有如下代码
static {
    try {
        java.sql.DriverManager.registerDriver(new Driver());
    } catch (SQLException E) {
        throw new RuntimeException("Can't register driver!");
    }
}

```

**System.setProperty()**

通过系统的属性设置注册驱动，如果要注册多个驱动，则System.setProperty("jdbc.drivers","com.mysql.jdbc.Driver:com.oracle.jdbc.Driver"); 
缺点：注册不太方便，所以很少使用。



---

## 2、建立数据库连接

数据库连接方式分两种：DriverManager 和 DataSource（推荐）

### 1> 使用DriverManager 连接

DriverManager是传统的jdbc连接 ，通过Class.forName("XXX")来注册，然后使用DriverManager.getConnection()获得连接了

通常我们为了避免频繁的创建连接对象，浪费cpu资源和内存资源，通常会使用**单例模式**，如下：

```java
private static Connection connection；
public Connection getConnection() {
    try {
        connection = DriverManager.getConnection(properties.getProperty("jdbc.url")
        ,properties.getProperty("jdbc.username")
        ,properties.getProperty("jdbc.password"));
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return connection;
}
```

但此时我们需要注意了： **Connection不是线程安全的**，它在多线程环境中使用时，会导致数据操作的错乱，特别是有事务的情况，所以我们将他修改为线程安全的单例模式：如双检索单例，静态内部类单例，饿汉模式单例，枚举单例。

但这够了吗？不够的，这并不满足高并发的要求，我们希望每一个线程都有自己的connection对象。怎么做？是的，使用ThreadLocal 对象。如下：

```java
private static ThreadLocal<Connection> threadLocal = new ThreadLocal<Connection>();
/**
* 获取连接
*/
private Connection getConnection() {
    Connection conn = threadLocal.get();
    if (conn == null) {
        try {
            conn = DriverManager.getConnection(properties.getProperty("jdbc.url")
                   ,properties.getProperty("jdbc.username")
                   ,properties.getProperty("jdbc.password"));
            threadLocal.set(conn);
        } catch (Exception e) {
            throw new RuntimeException("建立数据库连接异常", e);
        }
    }
    return conn;
}
```



### 2> 使用DataSource 连接

这是一个可以获取数据库连接的接口，支持连接池dbcp、c3p0、Druid等，来获取到数据库连接Connection

[数据库连接池性能比对(hikari druid c3p0 dbcp jdbc)](https://blog.csdn.net/qq_31125793/article/details/51241943)



这里采用阿里的Druid，跟着阿里爸爸走，不会差的，废话不多说，代码如下：

```java
private static DruidDataSource dataSource;
private static ThreadLocal<Connection> threadLocal = new ThreadLocal<>();
static {
    Properties properties = new Properties();
    try {
        properties.load(JDBCPoolUtil.class.getResourceAsStream("/properties/jdbc.properties"));
        dataSource = new DruidDataSource();
        // 设置数据库连接驱动、用户名、密码、连接地址
        dataSource.setDriverClassName(properties.getProperty("jdbc.driverClassName"));
        dataSource.setUsername(properties.getProperty("jdbc.username"));
        dataSource.setPassword(properties.getProperty("jdbc.password"));
        dataSource.setUrl(properties.getProperty("jdbc.url"));
        // 初始化时创建的连接数,应在minPoolSize与maxPoolSize之间取值
        dataSource.setInitialSize(0);
        // 连接池中保留的最大连接数据
        dataSource.setMaxActive(20);
        // 连接池最小空闲
        dataSource.setMinIdle(0);
        // 获取连接最大等待时间 毫秒
        dataSource.setMaxWait(60000);
        dataSource.setValidationQuery("SELECT 1");
        dataSource.setTestOnBorrow(false);
        dataSource.setTestWhileIdle(true);
        dataSource.setPoolPreparedStatements(false);
    } catch (Exception e) {
        throw new RuntimeException("加载配置文件异常", e);
    }
}

private static Connection getConnection() {
    // 声明线程共享变量
    Connection conn = threadLocal.get();
    if (conn == null) {
        try {
            conn = dataSource.getConnection();
            threadLocal.set(conn);
        } catch (Exception e) {
            throw new RuntimeException("建立数据库连接异常", e);
        }
    }
    return conn;
}
```

## 3、获取Statement执行器对象

jdbc 提供三个执行器对象：Statement、PreparedStatement 、CallableStatement

### 1> Statement

* 用于执行静态 SQL 语句并返回它所生成结果的对象。

* 缺点：不安全，可以进入注入攻击。



**获取与执行方式：**

```java
Statement stmt = conn.createStatement();
stmt.executeQuery(sql);
```

### 2> PreparedStatement 

* 继承Statement，它采用预编译的方式加载SQL脚本。可以有效的防止注入攻击

* 执行的脚本时，采用占位符  ？的方式代替SQL语句中的参数，所以在执行前，需要设置参数值

  ```sql
  # SQL脚本格式如下：
  UPDATE table4 SET m = ? WHERE x = ?
  ```

**获取方式：**

```java 
PreparedStatement  pstmt = conn.prepareStatement(sql);
```



**常见参数值设置：**

第一个参数是 1，从1开始设置

```java
void    setString(int parameterIndex,String x)//转换成一个 SQL VARCHAR 或 LONGVARCHAR 值
void	setBigDecimal(int parameterIndex, BigDecimal x) //转换成一个 SQL NUMERIC 值
void	setInt(int parameterIndex, int x)
void	setFloat(int parameterIndex, float x) //换成一个 SQL FLOAT 值
void	setDouble(int parameterIndex, double x) //转换成一个 SQL DOUBLE 值。
void	setLong(int parameterIndex, int x)
void	setDate(int parameterIndex, Date x) //转换成一个 SQL DATE 值。
void	setTime(int parameterIndex, Time x) 
void	setTimestamp(int parameterIndex, Timestamp x) 
void	setClob(int parameterIndex, Clob x) 
void	setObject(int parameterIndex, Object x) 
```



**常用执行方法：**

```java
boolean execute() //执行任何类型 SQL 语句 如：数据查询语言DQL，数据操纵语言DML，数据定义语言DDL，数据控制语言DCL
ResultSet executeQuery()//执行查询 SQL 语句，如：DQL
int executeUpdate() //执行DML语句和无返回的DDL，如：INSERT、 UPDATE 或 DELETE 语句
```



### 3> CallableStatement

* 继承PreparedStatement；用于执行 SQL 存储过程的接口

---

## 4、处理结果ResultSet

**ResultSet**

我们通常使用`ResultSet` 表示数据库结果集的数据表，在 `while` 循环中使用它来迭代结果集，具体如下：

```java
ResultSet rs = ps.executeQuery();  
While(rs.next()){  
    rs.getString(“col_name”);  
    rs.getInt(1);  
}  
```

**ResultSetMetaData**

用于获取关于 `ResultSet` 对象中列的类型和属性信息的对象



## 5、释放资源

* 数据库连接（Connection）非常耗资源，尽量晚创建，尽量早的释放

一般性写法在finally 中进行关闭操作，每个对象都要加try catch 以防前面关闭出错，后面的就不执行了

```java
/**
 * 关闭的方法
 */
public void closeAll(Connection con,PreparedStatement pstmt,ResultSet rs,CallableStatement cs){
    if(rs!=null){
        try {
            rs.close();
        } catch (SQLException e) {
            throw new RuntimeException("关闭ResultSet 对象异常", e);
        }
    }

    if(cs!=null){
        try {
            cs.close();
        } catch (SQLException e) {
            throw new RuntimeException("关闭CallableStatement 对象异常", e);
        }
    }

    if(pstmt!=null){
        try {
            pstmt.close();
        } catch (SQLException e) {
            throw new RuntimeException("关闭PreparedStatement 对象异常", e);
        }
    }

    if(conn!=null){
        try {
            con.close();
        } catch (SQLException e) {
            throw new RuntimeException("关闭Connection 对象异常", e);
        }
    }
}
```



**注意：** 

* JDK1.7 后开始，java引入了 try-with-resources 声明，将 try-catch-finally 简化为 try-catch

* 使用的是try-with-resources 语句， 它可以自动关闭，释放资源，无需在finally中写每一个对象的关闭操作

* try-with-recourse 中，try 块中抛出的异常，在 e.getMessage() 可以获得，而调用 close() 方法抛出的异常在e.getSuppressed() 获得。



---

# 三、JDBC 常见操作

## 1、获取自动生成的主键

自动生成主键通过先设置Statement.RETURN_GENERATED_KEYS，然后getGeneratedKeys() 获取，具体代码如下：

```java 
int key = 0; // 主键

//使用Statement对象操作
Statement st = conn.createStatement();
st.executeUpdate(sql, Statement.RETURN_GENERATED_KEYS);
ResultSet rs = st.getGeneratedKeys();
if (rs.next()) {
	key = rs.getInt(1);
}
//使用PreparedStatement 对象操作
PreparedStatement pstmt= conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
ResultSet rs = pstmt.getGeneratedKeys();
if (rs.next()) {
    key = rs.getInt(1);
}
```



## 2、批处理

批处理 通常使用  executeBatch() 实现，PreparedStatement 对象可以使用addBatch(String sql) 方法，批量设置参数值，代码如下：

```java
String sql = "update content set introtext=? where id=?";
PreparedStatement pstmt = conn.prepareStatement(sql);
for(int i=0; i<10000; i++){
    pstmt.setString(1, "abc"+i);
    pstmt.setInt(2, id);
    pstmt.addBatch();//添加到同一个批处理中
}
int[] result = pstmt.executeBatch();//执行批处理

/*result 中 值
1、大于等于0 ，成功处理了命令，是给出执行命令所影响数据库中行数的更新计数
2、如果为SUCCESS_NO_INFO ：-2， 成功执行了命令，但受影响的行数是未知的
3、如果为EXECUTE_FAILED ：-3  ，指示未能成功执行命
*、
```

**注意了**： 

JDBC中rewriteBatchedStatements对批量插入也有影响，如果不开启rewriteBatchedStatements=true，那么jdbc会把批量插入当做一行行的单条处理，也即没有达到批量插入的效果 

需要数据库连接URL后面加上这个参数，代码如下：

```java
String url =  "jdbc:mysql://localhost:3306/database?rewriteBatchedStatements=true";
```



## 3、开启事务

jdbc 事务开启只需要操作Connection对象，方式如下：

```java
conn.setAutoCommit(false);//将自动提交关闭
conn.commit();//执行完后，手动提交事务

//true 表示启用自动提交模式；false 表示禁用自动提交模式
```



# 四、操作工具类

这里写了两个操作工具类，一个使用原生的JDBC ，一个使用Druid 连接池

[原生的JDBCUtil 源码地址]()

[Druid 连接池 JDBCPoolUtil 源码地址]()