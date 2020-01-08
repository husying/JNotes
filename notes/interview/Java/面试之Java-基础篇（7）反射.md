

# 反射

## 定义

在 Java 中的反射机制是指在运行状态中，对于任意一个类都能够知道这个类所有的属性和方法；并且对于任意一个对象，都能够调用它的任意一个方法；

这种动态获取信息以及动态调用对象方法的功能成为 Java 语言的反射机制。



`Class` 和 `java.lang.reflect` 一起对反射提供了支持，`java.lang.reflect` 类库主要包含了以下三个类：

-  Field 类：表示类的成员变量，可以用来获取和设置类之中的属性值。
-  Method 类：表示类的方法，它可以用来获取类中的方法信息或者执行方法。
-  Constructor 类： 表示类的构造方法。



**反射的优点：**

- **能够运行时动态获取类的实例，大大提高系统的灵活性和扩展性。**
- 与Java动态编译相结合，可以实现无比强大的功能

**反射的缺点：**

- **性能开销** ：反射涉及了动态类型的解析，所以 JVM 无法对这些代码进行优化。因此，反射操作的效率要比那些非反射操作低得多。
- **安全限制** ：使用反射技术要求程序必须在一个没有安全限制的环境中运行。如果一个程序必须在有安全限制的环境中运行，如 Applet，那么这就是个问题了。
- **内部暴露** ：破坏了类的封装性，可以通过反射获取这个类的私有方法和属性



## 实现方式

* 在 Java 中反射有 3 中获取 `Class` 的实现方式，如下：

1. 调用某个对象的 `getClass()`方法，

  ```java
  Person p=new Person();
  Class clazz=p.getClass();
  ```

2. 调用某个类的 class 属性来获取该类对应的 Class 对象，

```java
Class clazz=Person.class;
```

3. 使用 Class 类中的 `forName()`静态方法是最安全、性能最好，最常用的一种方式

```java
Class clazz=Class.forName("类的全路径"); 
```



* Class 创建对象的 2 种方式

1. 使用 Class 对象的 `newInstance()`
2. 先使用 Class 对象获取指定的 Constructor 对象，再调用 Constructor 对象的 newInstance()



# 实战演练

```java
//获取 Person 类的 Class 对象
Class clazz=Class.forName("reflection.Person");
//获取 Person 类的所有方法信息
Method[] method=clazz.getDeclaredMethods();
for(Method m:method){
    System.out.println(m.toString());
}
//获取 Person 类的所有成员属性信息
Field[] field=clazz.getDeclaredFields();
for(Field f:field){
    System.out.println(f.toString());
}
//获取 Person 类的所有构造方法信息
Constructor[] constructor=clazz.getDeclaredConstructors();
for(Constructor c:constructor){
    System.out.println(c.toString());
}
//使用.newInstane 方法创建对象
Person p=(Person) clazz.newInstance();
//获取构造方法并创建对象
Constructor c=clazz.getDeclaredConstructor(String.class,String.class,int.class);
//创建对象并设置属性
Person p1=(Person) c.newInstance("李四","男",20);
```

