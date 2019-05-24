# RESTful风格

REST全称是REpresentational State Transfer 直接翻译：表现层状态转移，通俗的说法是：URL定位资源，

RESTful 的核心思想就是，客户端发出的数据操作指令都是"动词 + 宾语"的结构

* 动词通常就是五种 HTTP 方法，对应 CRUD 操作

```java
GET：读取（Read）
POST：新建（Create）
PUT：更新（Update）
PATCH：更新（Update），通常是部分更新
DELETE：删除（Delete）
```

* 宾语就是 API 的 URL，**必须是名词，不能是动词**

名词：名词是复数还是单数，没有统一的规定，建议使用复数，如：

```java
/articles
```

动词：一般指get、set、create、insert等，如：

```java
/getAllCars
/createNewCar
/deleteAllRedCars
```



**扩展：**

**HTTP 幂等性：**

定义：**是指无论调用这个url多少次，都不会有不同的结果的HTTP方法**

* 幂等性：GET、PUT、DELETE
* 非幂等性：POST、PATCH







**响应的数据报文格式：**

数据格式，应该是 **JSON** 对象，HTTP 请求头和响应头的`Content-Type`属性要设为`application/json`。

```
{
    code:0,
    msg:’’
    data:{}||[],  
}
```

