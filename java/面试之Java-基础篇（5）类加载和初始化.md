---
title: 面试之Java 基础篇（5）类加载和初始化
typora-root-url: 面试之Java 基础篇（5）类加载和初始化
categories:
- 技术栈
- Java 
tags:
- 面试
- Java
---

虚拟机将描述类的数据从.class文件加载到内存，并对数据进行校验、转换解析和初始化，最终形成可以被虚拟机直接使用的Java类型



# 类加载

在类的加载阶段，即生命周期分：加载，验证，准备，解析，初始化，调用，卸载等七个时期，其中验证、准备、解析3个部分统称为连接。

结束生命周期方式：

*   执行了System.exit()方法
*   程序正常执行结束
*   程序在执行过程中遇到了异常或错误而异常终止
*   由于操作系统出现错误而导致Java虚拟机进程终止



## 加载阶段

指获取二进制字节流，类的静态信息存储至方法区，在内存中生成一个class类对象；加载方式一般分2种，静态加载和动态加载：

*   **静态加载** ：编译时刻加载的类是静态加载类；通过**new关键字来实例对象**，编译时执行
*   **动态加载** ：运行时刻加载的类是动态加载类。通过**反射、序列化、克隆等方式**加载，运行期执行

**所以创建对象方式**有4种：使用new关键字、反射、克隆（clone方法）、序列化

数组类本身不通过类加载器创建，由Java虚拟机直接创建，但数组类的元素类型由加载创建（基本数据类型除外）



## 验证阶段

校验二进制字节流是否符合JVM标准，大致分 4 阶段：文件格式验证、元数据验证、字节码验证、符号引用验证



## 准备阶段

该阶段是将类的**静态变量分配内存，并设置类变量的初始值**，数据类型默认零值，**final修饰过的直接赋值**

>   假设上面的类变量value被定义为： public static final int value = 3；
>
>   编译时Javac将会为value生成ConstantValue属性，在准备阶段虚拟机就会根据ConstantValue的设置将value赋值为3。这种情况。我们可以理解为static final常量在编译期就将其结果放入了调用它的类的常量池中

## 解析阶段

**把类中的符号引用转换为直接引用**；主要针对类或接口、字段、类方法、接口方法、方法类型、方法句柄、调用点限定符等 7 类符号引用

符号引用：以一组符号（任一形式字面值）描述目标的引用

直接引用：句柄或直接指针描述目标引用



## 初始化阶段

该阶段就是执行类构造器`<clinit>（）`的方法过程；`<clinit>（）`是由编译期收集类中的所有类变量的赋值动作和静态语句块中的语句合并产生的





---



# 类初始化

## 类初始化时机

在 Java 代码运行中，什么时候开始初始化一个类呢？一般有以下5种情景，都会进行类初始化

1.  使用 new 实例化对象时
2.  调用静态变量时（常量除外）、静态方法
3.  通过反射调用
4.  初始化一个类如果父类没有初始化，先触发父类的初始化
5.  执行main方法的启动类

**但是值得注意的是，以上情景中，以下情况是不会触发初始化的**

*   子类调用父类的静态变量，子类不会被初始化，只有父类被初始化
*   通过数组定义来引用类，不会触发类的初始化
*   访问类的常量(包含静态常量)，不会初始化类



举例说明：

```java
class SuperClassA {
     static {
         System.out.println("superclassA init");
     }
     public static int value = 123;
 }
 class SuperClassB extends SuperClassA {
     static {
         System.out.println("superclassB init");
     }
     public static int value = 1;// 如果注释此代码
 }
  class SuperClassC extends SuperClassB {
     static {
         System.out.println("superclassC init");
     }
 }
 class SubClass extends SuperClassC {
     static {
         System.out.println("subclass init");
     }
 }
  
 public class Test {
     public static void main(String[] argc) {
         System.out.println(SubClass.value);
         new SubClass();
     }
 }
```

执行结果：

```java
superclassA init
superclassB init
1
--------
superclassC init
subclass init
```

分析一下为什么出现以上结果呢？：

1.  当调用 `SubClass.value`，`SubClass` 本身没有定义`value`变量，但是通过继承的规则：子类会继承或覆盖父类属性，因此我们这里应该取`SubClassB.value`，所以预初始化`SuperClassB`，但是根据类初始化顺序规则：**初始化一个类如果父类没有初始化，先触发父类的初始化**，所以先初始化`SuperclassA`，再初始化 `SuperClassB` ；由于**子类调用父类的静态变量，子类不会被初始化，只有父类被初始化**的原则，因此并不会初始化 `SubClass` 自己
2.  当调用`new SubClass()` 时，根据 **初始化一个类如果父类没有初始化，先触发父类的初始化** 的原则，所以预初始化`SuperClassC`、`SuperClassB`、`SuperClassA`，但是此时只有`SuperClassC`没有初始化，所以这里会 初始化 `SuperClassC`、`SubClass`



**调用静态常量不出进行类初始化**

```java
class ConstClass {
	static {
		System.out.println("ConstClass init");
	}
	public static final String HELLOWORLD = "hello world";
}
 
public class Test {
	public static void main(String[] args) {
		System.out.println(ConstClass.HELLOWORLD);// 调用类常量
	}
}
```

执行结果：

```java
hello world
```



---

## 类初始化顺序

我们在笔试时经常遇到根据类初始化顺序，确认结果的面试题，因此我们非常有必要掌握该知识点。先上代码，我们在分析

父类SuperClass：

```java
package com.hsy.demo;

public class SuperClass {
	// 普通变量
	private String field = getField();
	// 静态变量
	private static String staticField = getStaticField();

	// 构造函数
	public SuperClass() {
		System.out.println("父类SuperClass > 构造函数 SuperClass()");
	}

	// 普通方法块
	{
		System.out.println("父类SuperClass > 普通方法块{}");
	}

	// 静态方法块
	static {
		System.out.println("父类SuperClass > 静态方法块 static{}");
	}

	// ----------------------相反顺序-----------------------------

	// 静态方法块
	static {
		System.out.println("父类SuperClass > 静态方法块static {} > 顺序：第2个");
	}

	// 普通方法块
	{
		System.out.println("父类SuperClass > 普通方法块 {} > 顺序：第2个");
	}

	// 构造函数
	public SuperClass(int n) {
		System.out.println("父类SuperClass > 构造函数 SuperClass(int n)");
	}

	// 静态变量
	private static String staticField2 = getStaticField2();

	// 普通变量
	private String field2 = getField2();

	// =====================================
	public static String getStaticField() {
		String statiFiled = "Static Field Initial";
		System.out.println("父类SuperClass > 静态变量staticField");
		return statiFiled;
	}

	public static String getStaticField2() {
		String statiFiled = "Static Field Initial";
		System.out.println("父类SuperClass > 静态变量staticField > 顺序第2个 ");
		return statiFiled;
	}

	public static String getField() {
		String filed = "Field Initial";
		System.out.println("父类SuperClass > 普通变量：field");
		return filed;
	}

	public static String getField2() {
		String filed = "Field Initial";
		System.out.println("父类SuperClass > 普通变量：field > 顺序第2个");
		return filed;
	}
}

```

子类SubClass：

```java
package com.hsy.demo;

public class SubClass extends SuperClass {
	// 普通变量
	private String field = getField();
	// 静态变量
	private static String staticField = getStaticField();

	// 构造函数
	public SubClass() {
		System.out.println("子类SubClass > 构造函数 SuperClass()");
	}

	// 普通方法块
	{
		System.out.println("子类SubClass > 普通方法块{}");
	}

	// 静态方法块
	static {
		System.out.println("子类SubClass > 静态方法块 static{}");
	}

	// ----------------------相反顺序-----------------------------

	// 静态方法块
	static {
		System.out.println("子类SubClass > 静态方法块static {} > 顺序：第2个");
	}
	// 普通方法块
	{
		System.out.println("子类SubClass > 普通方法块 {} > 顺序：第2个");
	}

	// 构造函数
	public SubClass(int n) {
		System.out.println("子类SubClass > 构造函数 SuperClass(int n)");
	}

	// 静态变量
	private static String staticField2 = getStaticField2();

	// 普通变量
	private String field2 = getField2();
	

	// =====================================
	public static String getStaticField() {
		String statiFiled = "Static Field Initial";
		System.out.println("子类SubClass > 静态变量staticField");
		return statiFiled;
	}
	public static String getStaticField2() {
		String statiFiled = "Static Field Initial";
		System.out.println("子类SubClass > 静态变量staticField > 顺序第2个 ");
		return statiFiled;
	}

	public static String getField() {
		String filed = "Field Initial";
		System.out.println("子类SubClass > 普通变量：field");
		return filed;
	}

	public static String getField2() {
		String filed = "Field Initial";
		System.out.println("子类SubClass > 普通变量：field > 顺序第2个");
		return filed;
	}
}

```

执行结果：

```
父类SuperClass > 静态变量staticField
父类SuperClass > 静态方法块 static{}
父类SuperClass > 静态方法块static {} > 顺序：第2个
父类SuperClass > 静态变量staticField > 顺序第2个 
子类SubClass > 静态变量staticField
子类SubClass > 静态方法块 static{}
子类SubClass > 静态方法块static {} > 顺序：第2个
子类SubClass > 静态变量staticField > 顺序第2个 
父类SuperClass > 普通变量：field
父类SuperClass > 普通方法块{}
父类SuperClass > 普通方法块 {} > 顺序：第2个
父类SuperClass > 普通变量：field > 顺序第2个
父类SuperClass > 构造函数 SuperClass()
子类SubClass > 普通变量：field
子类SubClass > 普通方法块{}
子类SubClass > 普通方法块 {} > 顺序：第2个
子类SubClass > 普通变量：field > 顺序第2个
子类SubClass > 构造函数 SuperClass(int n)

```

通过以上代码你找到规律了吗？是否和以下规则一样

**存在继承的情况下，初始化顺序如下依次进行：**

**存在继承的情况下，初始化顺序如下依次进行：**

1.  父类（静态变量、静态语句块），初始化顺序取决于它们在代码中定义的先后顺序
2.  子类（静态变量、静态语句块），初始化顺序取决于它们在代码中定义的先后顺序
3.  父类（普通变量、普通语句块），初始化顺序取决于它们在代码中定义的先后顺序
4.  父类（构造函数），默认初始化父类无参构造函数
5.  子类（普通变量、普通语句块），初始化顺序取决于它们在代码中定义的先后顺序
6.  子类（构造函数），调谁用谁



知道以上规则了，我们在看看以下代码：

```java
class SingleTon {
	private static SingleTon singleTon = new SingleTon();
	public static int count1;
	public static int count2 = 0;
 
	private SingleTon() {
		count1++;
		count2++;
	}
 
	public static SingleTon getInstance() {
		return singleTon;
	}
}
 
public class Test {
	public static void main(String[] args) {
		SingleTon singleTon = SingleTon.getInstance();
		System.out.println("count1=" + singleTon.count1);
		System.out.println("count2=" + singleTon.count2);
	}
}
```

以上代码会有啥结果呢？这里我们先不着急揭秘，先分析一下

1.  当调用`SingleTon.getInstance();` 时，根据初始化规则，由于`getInstance`是静态方法，`SingleTon`还没有初始化，所以会先初始化该类
2.  根据类加载过程，在类准备阶段会将非`final` 的静态属性，赋上初始值，也就是说`count1` 和 `count2` 先赋上 0 值；然后在类初始化阶段赋予实际程序员定义的值，所以过程如下：
    1.  第1步准备阶段：即singleton=null count1=0,count2=0
    2.  第2步初始化阶段：根据执行的属性，静态变量，谁先定义，谁先初始化。即过程为：先初始化 SingleTon ；这里是构造方法赋值。执行后count1=1,count2=1；然后初始化count1和count2，由于count1 没有赋值动作，则不执行。最后给count2 赋值，即：count2=0。

所以执行结果如下

```java
count1=1
count2=0
```

注意：如果singleTon 属性放在count2 后， 则结果就不一样了。而是count1=1,count2=1；