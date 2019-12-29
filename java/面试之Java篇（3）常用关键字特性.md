---
title: 面试之Java篇（3）常用关键字特性
typora-root-url: 面试之Java篇（3）常用关键字特性
categories:
- 技术栈
- Java
tags:
- 面试
- Java
---

本章中主要了解一下我们在开发过程中常用，也必须掌握的一些特殊关键字的作用。



# 访问权限

在Java中有4中访问权限的修饰符：**private**、**default**（(默认一般省略）、**public**、**protected**。一般用于对类或类中的成员（字段以及方法）加上访问修饰符

权限的主要作用范围：同一个类中、同一个包下、父子类、不同的包

可被修饰对象：类和成员变量；类可见表示其它类可以用这个类创建实例对象；成员可见表示其它类可以用这个类的实例对象访问到该成员。

**4种修饰符的权限范围：**

>   *   private：指”私有的”。被其修饰的属性以及方法只能被该类的对象访问，其子类不能访问，更不能允许跨包访问
>   *   default：即不加任何访问修饰符，通常称为“默认访问权限“或者“包访问权限”。该模式下，只允许在同一个包中进行访问。
>   *   protected: 介于public 和 private 之间的一种访问修饰符，一般称之为“保护访问权限”。被其修饰的属性以及方法只能被类本身的方法及子类访问，即使子类在不同的包中也可以访问。
>   *   public： Java语言中访问限制最宽的修饰符，一般称之为“公共的”。被其修饰的类、属性以及方法不仅可以跨类访问，而且允许跨包访问。

| 修饰符    | 同类 | 同包 | 子类 | 不同包非子类 |
| --------- | ---- | :--- | ---- | ------------ |
| private   | √    | ×    | ×    | ×            |
| default   | √    | √    | ×    | ×            |
| protected | √    | √    | √    | ×            |
| public    | √    | √    | √    | √            |

从上表中我们很容易看出，权限范围从小到大依次为：**private < default < protected < public**

------------------------------------------------


# final 和 static

## final

在Java中，final关键字可以用来修饰类、方法和变量（包括成员变量和局部变量）

*   **修饰变量**：表示常量，对于基本类型，final 使数值不变；对于引用类型，final 使引用地址不变，但对象本身的属性是可以被修改的。
*   **修饰方法**：不能被子类的方法重写，但可以被继承，**不能修饰构造方法**。。
*   **修饰类** ：该不能被继承，没有子类，final类中的方法默认是final的。Java中的String类就是一个final类



## static

在Java语言中，static 可以用来修饰成员变量和成员方法，当然也可以是静态代码块

*   **静态变量**：又称为类变量，该类的所有实例都共享本类的静态变量，且在内存中只存在一份
*   **静态方法**：在类加载的时候就存在了，它不依赖于任何实例，只能访问所属类的静态字段和静态方法，方法中不能有 this 和 super 关键字（此时可能没有实例）。
*   **静态语句块**：在类初始化时运行一次。
*   **静态内部类**：非静态内部类依赖于外部类的实例，而静态内部类不需要。静态内部类不能访问外部类的非静态的变量和方法。



**使用时注意：**

1.  静态变量，静态方法可以通过类名直接访问
2.  初始化顺序：静态变量和静态语句块优先于实例变量和普通语句块，静态变量和静态语句块的初始化顺序取决于它们在代码中的顺序。（此处不演示，在类初始化篇章中演示）



**问：在一个静态方法内调用一个非静态成员为什么是非法的?**

由于静态方法可以不通过对象进行调用，因此在静态方法里，不能调用其他非静态变量，也不可以访问非静态变量成员。



## **成员变量、静态变量、局部变量的区别**

从生命周期比较：

*   静态变量可以被对象调用，也可以被类名调用。以static关键字申明的变量，其独立在对象之外，有许多对象共享的变量。在对象产生之前产生，存在于**方法区静态区中**。
*   成员变量只能被对象调用。随着对象创建而存在，随对象销毁而销毁。存在于**堆栈内存中**
*   局部变量在方法或语句块中申明的变量，生命周期只在定义的{}之中，不能跨方法或语句块使用。

从访问权限比较：

*   **静态变量称为对象的共享数据**，成员变量可以称为对象的特有数据，局部变量为方法所有
*   成员变量可以被 public,private,static 等修饰符所修饰，而局部变量不能被访问控制修饰符及 static 所修饰；但是，成员变量和局部变量都能被 final 所修饰。

---



#  abstract 和 interface

## abstract

在 Java 中 abstract 即抽象，一般使用 `abstract` 关键字修饰的类或方法

修饰的类时

>   1.  不能被实例化，需要继承抽象类才能实例化其子类。
>   2.  访问权限可以使用`public`、`private`、`protected`，其表达形式为：（public）abstract class 类名{} 
>   3.  抽象类不能使用final关键字修饰，因为final修饰的类是无法被继承
>   4.  可以定义构造方法、静态方法、普通方法；非抽象的普通成员变量、静态成员变量

修饰的方法时

>   1.  含有该抽象方法的类必须定义为抽象类，但抽象类可以没有抽象方法。
>   2.  访问权限可以使用`public`、`default`、`protected`，不能为`private`，因为抽象方法必须被子类实现（覆写），而private权限对于子类来 说是不能访问的，所以就会产生矛盾，
>   3.  不能用static修饰，因为没有主体

```java
public abstract  class  MyAbstract {
	public String name="小米";
	private static int price= 1800;
	
	MyAbstract(String name){
		this.name = name;
	}
	
	public void test() {
		System.out.println(name);
	}
	public static void fun() {
		System.out.println(price);
	}
	public abstract void print();//权限不能为 private
}
```



## interface

在 Java中 interface 即接口，是抽象类的延伸，在 Java 8 之前，它可以看成是一个完全抽象的类，Java 8 开始，接口也可以拥有`default`的方法实现，是因为不支持默认方法的接口的维护成本太高

>   1.  接口的方法访问权限只能为 `public `，Java 8可以为`default`，但是必须有方法体
>   2.  接口的方法默认`public abstract` 也可以由 static 修饰
>   3.  接口的方法可以定义为 `public static` ，但是必须有方法体，且只能有接口类名调用
>   4.  成员变量默认为`public staic final`

```java
public interface  MyInterface {
	int price = 1800;

	void outName();

	default void print() {
		System.out.println("MyInterface print： default Method");
	}

	public static void price() {
		System.out.println("MyInterface price="+price);
	}
}
public class MyInterfaceImpl implements MyInterface {
	@Override
	public void outName() {
		 System.out.println("I'm a MyInterfaceImpl");
	}
    public static void main(String[] args) {
		MyInterface my = new MyInterfaceImpl();
		my.outName();
		my.print();
//		MyInterfaceImpl.print();// 实现类类名调用时， 提示编译错误
		MyInterface.price();
	}
}

```



##  abstract 和 interface 的区别

**从定义分析**

*   抽象类和接口都不能直接实例化；抽象方法必须由子类来进行重写
*   抽象类单继承，接口多实现
*   抽象类可有构造方法，普通成员变量，非抽象的普通方法，静态方法
*   抽象类的抽象方法访问权限可以为：public、protected 、default
*   接口中变量类型默认public staic final，
*   接口中普通方法默认public abstract，没有具体实现
*   jdk1.8 中接口可有**静态方法和default（有方法体）方法**

**从应用场合分析**

*   接口：需要将一组类视为单一的类，而调用者只通过接口来与这组类发生联系。
*   抽象类：1、在既需要统一的接口，又需要实例变量或缺省的方法的情况下就可以使用它；2、定义了一组接口，但又不想强迫每个实现类都必须实现所有的接口