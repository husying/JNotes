在 Java中泛型占具着很重要的地位，在面向对象编程及各种设计模式中有非常广泛的应用。

**泛型的本质是参数化类型**，也就是说将类型由原来的具体的类型转化为类似于方法中的变量参数形式

泛型有三种常用的使用方式：**泛型类**，**泛型接口**和**泛型方法**。



**泛型的标记符：**

- E - Element (在集合中使用，因为集合中存放的是元素)
- T - Type（Java 类）
- K - Key（键）

- V - Value（值）

- N - Number（数值类型）

- ？ -  表示不确定的java类型

- S、U、V  - 2nd、3rd、4th types



# 泛型类

指具有一个或多个类型变量的类，泛型类定义如下：

```java
//此处T可以随便写为任意标识，常见的如T、E、K、V等形式的参数常用于表示泛型
class 类名 <泛型标识>{
  	/*（这里的泛型标识标识成员变量类型），由外部指定  */
  	private 泛型标识  变量名称; 
  	.....
	
    //get、set 省略
	
}
```

**注意**：泛型的类型参数只能是引用类型，不能是基本数据类型



举例：

```java
public class Generic<T>{ 
    private T key;
    public Generic(T key) { 
        this.key = key;
    }
    public T getKey(){ 
        return key;
    }
    public void setKey(T key){ 
        this.key = key;
    }
}
```

使用如下：

```java
Generic<Integer> genericInteger = new Generic<Integer>(123456);
```





# 泛型接口

泛型接口与泛型类的定义及使用基本相同。泛型接口常被用在各种类的生产器中，泛型接口格式如下：

```java
public interface 类名 <泛型标识> {
    public 泛型标识 getKey();
}
```

范例：

```java
public interface IGeneric<T> {
    public T getKey() {
        return null;
    }
}
```



# 泛型方法

在 Java 中，泛型方法是返回对象为泛型，如：

```java
//声明了一个泛型T，表明这是一个泛型方法
//这个T可以出现在这个泛型方法的任意位置.
public <T> T genericMethod(Class<T> tClass){
        T instance = tClass.newInstance();
        return instance;
}
```



以下方式不正确：

```java
//虽然我们声明了<T>,也表明了这是一个可以处理泛型的类型的泛型方法。
//但是只声明了泛型类型T，并未声明泛型类型E，因此编译器并不知道该如何处理E这个类型。
//编译器会为提示错误信息："UnKnown class 'E' "
public <T> T showKeyName(Generic<E> container){
        ...
} 
```

```java
//T这个类型并未项目中声明过，因此编译器也不知道该如何编译这个类，
//所以编译器会为提示错误信息："UnKnown class 'T' "
public void showkey(T genericObj){
    ...
}
```

