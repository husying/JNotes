

每个公司都有不同的标准，目的是为了保持统一，减少沟通成本，提升团队研发效能。

但，在实际开发中，我们阅读代码时，常说别人写的代码惨目忍睹，总认为自己的最好的，所以本文为自我总结，仅供参考



# 规约律令

**通用**

*   强制：类使用大驼峰命名，方法和局部变量使用小驼峰命名
*   强制：不能使用以下划线或美元符号开始，也不能以下划线或美元符号结束
*   强制：严禁使用拼音与英文混合的方式，更不允许直接使用中文的方式，杜绝完全不规范的缩写，避免望文不知义

**特定对象**

*   项目名：全部小写，多个单词以中划线  '-'  分隔，统一使用单数形式，但是类名如果有复数含义，类名可以使用复数形式。
*   包名：统一使用小写，使用单数形式，仅有小写字母和数组组成，以英文点分隔，取对应的形容词为接口名
*   类名：类命通常时名词或名词短语；接口名还可以使用形容词或形容词短语（通常是–able 的形容词）。如Cloneable等，抽象类命名使用 Abstract 或 Base 开头；异常类命名使用 Exception 结尾；测试类命名以它要测试的类的名称开始，以 Test 结尾。
*   方法名：小驼峰命名，杜绝完全不规范的缩写、拼音等
*   变量名：POJO 类中布尔类型变量都不要加 is 前缀，否则部分框架解析会引起序列化错误。
*   常量名：命名应该全部大写，单词间用下划线隔开，力求语义表达完整清楚，不要嫌名字长 



# 包名规约

一个单词或者多个单词自然连接到一块（如 springframework，deepspace不需要使用任何分割）；统一使用单数形式，如果类命有复数含义，则可以使用复数形式。

包名构成可以分为以下几四部分【前缀】 【发起者名】【项目名】【模块名】。

前缀：常见的可以分为以下几种：

>   indi：多人完成，版权属于发起者
>
>   pers ：独自完成，公开，版权主要属于个人。
>
>   priv ： 独自完成，非公开，版权属于个人。
>
>   team：团队项目指由团队发起，并由该团队开发的项目，版权属于该团队所有。

顶级域名：如：com，cn，org，edu，gov，net 等

>   com：由公司发起，版权由项目发起的公司所有。
>
>   org：标志这是个开源的包

以下是自己常用来进行区分的模块名，仅供参考：

>   api：存放对外提供接口服务类
>
>   common：放工具类
>
>   config：放配置类
>
>   constants：放常量类
>
>   domain：放领域对象类
>
>   service：放接口类类
>
>   tasks：放定时器类类



# 类名规约

特殊特有名词缩写也可以使用全大写命名，比如XMLHttpRequest；

建议：三个字母以内都大写，超过三个字母则按照要给单词算

常见类名规则：

*   抽象类：以 Abstract 或者 Base  为前缀；
*   接口：取对应的形容词为接口名（通常是–able 的形容词）。
*   接口实现类：以接口名称 + Impl 
*   工具类：以 Utils 或 Tool 为后缀，Utils 是通用业务无关可供其他程序使用的，Tool 是通用的部分业务相关的，只能在本系统使用，Helper 也有帮助类的意思，单其一般用于功能辅助，如：SqlHelper 封装数据库连接操作，提供数据库操作对象
*   枚举类：以 Enum 为后缀，枚举成员名称需要全大写，单词间用下划线隔开
*   异常类：以 Exception 为后缀
*   领域模型类：以 DO/DOT/VO/DAO 为后缀，切记别 Do,Vo 此类错误写法
*   测试类：以 Test 为后缀
*   MVC 分层：分别以 Controller、Service、ServiceImpl、Mapper 为后缀
*   设计模式相关类：以  Builder 、Factory 等为后缀
*   特殊功能类：以 Hander、Validate 等为后缀

**分层领域模型规约：**

*   **DO**（Data Object）：此对象与数据库表结构一一对应，通过 DAO 层向上传输数据源对象。一般放置在 entity 包下
*   **DTO**（Data Transfer Object）：数据传输对象，Service 或 Manager 向外传输的对象。
*   BO（Business Object）：业务对象，由 Service 层输出的封装业务逻辑的对象。
*   AO（Application Object）：应用对象，在 Web 层与 Service 层之间抽象的复用对象模型，极为贴近展示层，复用度不高。
*   **VO**（View Object）：显示层对象，通常是 Web 向模板渲染引擎层传输的对象。
*   **Query**：数据查询对象，各层接收上层的查询请求。注意超过 2 个参数的查询封装，**禁止使用 Map 类来传输。**实际开发中我们可能直接我们也不会每层都这么新增这种对象，所以一般用于接收 web 发起的查询封装
*   POJO 是 DO/DTO/BO/VO 的统称，禁止命名成 xxxPOJO

以上一般放置于 domain 包下，domain 国外很多项目经常用到，字面意思是域；model 是模型的意思，当用model当包名的时候，其内部的实体类一般是用来给前端用的；小公司也不会分的那么细，一般定义目录结构如下：

>   domain
>
>   ├─entity
>
>   │ ├─xxxDO，xxx 即为数据表名
>
>   ├─dto
>
>   │ ├─xxxDTO，xxx 为业务领域相关的名称。
>
>   ├─model
>
>   │ ├─vo，xxxVO，xxx 一般为网页名称。
>
>   │ ├─query，xxxQuery，xxx 一般为查询对象的名字，经常用于封装前端的表单的查询条件。





# 方法名规约

首字小写，往后的每个单词首字母都要大写，禁止拼音或简写（常见的除外）

**DAO 层方法命名规约（阿里规约）**

*   获取单个对象的方法用 get 做前缀。
*   获取多个对象的方法用 list 做前缀，复数形式结尾如：listObjects。
*   获取统计值的方法用 count 做前缀。
*   插入的方法用 save/insert 做前缀。
*   删除的方法用 remove/delete 做前缀。
*   修改的方法用 update 做前缀



以下是常用 Mybatis 的Mapper类命名，仅供参考

```java
public interface BaseMapper {
    //======= 新增
    int insert(T entity);
    int insertBatch(@Param("entityList") Collection<? extends Serializable> entityList);
    int insertSelective(@Param("paramsMap") Map<String, Object> paramsMap);
    //======= 修改
    int updateById(T entity);
    int updateByMap(@Param("paramsMap") Map<String, Object> paramsMap);
    //======= 删除
    int delete(T entity);
    int deleteById(Serializable id);
    int deleteByMap(@Param("paramsMap") Map<String, Object> paramsMap);
    int deleteBatchByIds(@Param("idList") Collection<? extends Serializable> idList);
    
    //======= 对象查询
    T getOne(@Param("paramsMap") Map<String, Object> paramsMap);
    T getOneById(Serializable id);
    List<T> listObjects(@Param("paramsMap") Map<String, Object> paramsMap);
    
    //======= 统计
    long count();
    long count(T entity);
    long countByMap(@Param("paramsMap") Map<String, Object> paramsMap);
    List<Map<String,Object>> group(@Param("paramsMap") Map<String, Object> paramsMap);
    
    //=======特定查询
    // 需要 IPage 对象
    IPage<T> listPage(IPage<T> page, @Param("paramsMap") Map<String, Object> paramsMap);
    // 格式 findXXXByYYY，XXX 获取字段名，YYY为条件对象
    String findXXXByYYY( YYY param);
    // 获取业务数据 ,XXX 为 DTO、VO 对象
    List<XXX> listXXXByYYY(YYY params);
    List<XXX> listXXXDTO(@Param("paramsMap") Map<String, Object> paramsMap); 
}
```

控制层的方法命名：前缀

*   select：列表查询，分页以 Page 为后缀
*   find：单字段查找
*   save：保存数据，可以指新增或更新，用 add 或 update 代替
*   remove：移除，并不一定真删数据，如果确定真删除可以用 delete
*   edit：编辑
*   view：视图显示

**返回布尔类型的方法，前缀：**

*   is：表示对象是否符合
*   can：表示能否执行某操作
*   has：表示是否持有
*   need：表示是否需要执行
*   validate/ensure：验证或确认是否符合某状态

操作对象什么生命周期的方法，前缀

*   initial：表示初始化，可以简写为 init 
*   pause：表示暂停
*   stop：表示停止
*   destroy：表示销毁

操作某事件动作的方法

*   create：创建
*   start/stop：开始执行和结束执行
*   open：打开控制
*   load：载入
*   import：导入
*   split：分隔
*   read：读取
*   backup：备份
*   bing：绑定

操作数据相关方法，前缀

*   create：新增
*   update：更新
*   delete：删除
*   remove：移除
*   save：保存
*   insert：插入
*   add：添加
*   commit：提交
*   copy：拷贝

回调方法，前缀

*   on：某事件发生时执行
*   before：某事件发生前执行，可用 pre、will  替代
*   after：某事件发生后执行，可用 post 替代



# 资料参考

*   阿里巴巴Java开发手册（华山版）