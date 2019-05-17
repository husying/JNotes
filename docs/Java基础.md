本篇章，基本上为笔试题方式出现。记清楚，理解了就没什么问题了

不过呢，还有一些没整理到的地方。日后继续吧。万丈高楼平地起，基础便是地基。

# JAVA基础

[TOC]



# 一、Java三大特性

* 封装、继承、多态

* 封装和继承目的都是为了代码重用，多态目的是为了接口重用。

* 封装：是把客观事物抽象成类，并且把自己的属性和方法让可信的类或对象操作，对不可性的隐藏。

* 继承：它可以使用现有类的所有功能，并在无需重新编写原来的类的情况下对这些功能进行扩展。
* 多态：允许将子类类型的指针赋值给父类类型的指针。 体现：方法重载、方法重写、抽象类、接口



# 二、Java约束

## 1、标识符

* 使用字母、下划线(_)、美元符($)、人民币符号(￥) 和数字（不能以数字开头）
* 大小写敏感，长度不限，不能使用关键字



## 2、命名规定

* 采用驼峰命名法，方法名、参数名、成员变量、局部变量名开头小写，禁止不规范简写
* 不以下划线或美元符开头或结束
* 常量大写，单词间以下划线拼接；如：SIZE_NAME

具体可参考：[阿里巴巴Java开发手册](https://github.com/alibaba/p3c/blob/master/%E9%98%BF%E9%87%8C%E5%B7%B4%E5%B7%B4Java%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C%EF%BC%88%E8%AF%A6%E5%B0%BD%E7%89%88%EF%BC%89.pdf)



## 3、访问级别

使用范围：本类、同一包、子类、无限制

**private < default < protected < public**

private 		：本类
default 		：本类、同一包
protected	：本类、同一包、被继承
public			:   本类、同一包、被继承、不同包



## 4、final 修饰符

* **final类**不能被继承，没有子类，final类中的方法默认是final的。
* **final方法**不能被子类的方法覆盖，但可以被继承。
* **final成员变量**表示常量，只能被赋值一次，赋值后值不再改变。
* final不能修饰构造方法。

## 5、static 修饰符 

* static修饰的方法或变量，**可以通过类名直接访问**
* static可以用来修饰类的成员方法、类的成员变量和代码块
  * **static变量：**静态变量被所有的对象所共享（同一个线程中定义的此类对象共享 ），在内存中只有一个副本，它当且仅当在类初次加载时会被初始化。
  * **static代码块：**在类初次被加载的时候，会按照static块的顺序来执行每个static块，并且只会执行一次。
  * **static方法：**静态方法中不能用this和super关键字（因为**this代表对象**，而静态在时，有可能没有对象），不能直接访问所属类的实例变量和实例方法，只能访问所属类的静态成员变量和成员方法。



**成员变量、静态变量、局部变量的区别**

* 静态变量可以被对象调用，也可以被类名调用。以static关键字申明的变量，其独立在对象之外，有许多对象共享的变量。在对象产生之前产生，存在于**方法区静态区中**。
* 成员变量只能被对象调用。随着对象创建而存在，随对象销毁而销毁。存在于**堆栈内存中**
* 局部变量在方法或语句块中申明的变量，生命周期只在定义的{}之中，不能跨方法或语句块使用。
* 成员变量可以称为对象的特有数据，**静态变量称为对象的共享数据**



## 6、类的关系

[参考](https://blog.csdn.net/xingjiarong/article/details/50193815)

在UML类图中，常见的有以下几种关系: **泛化**（Generalization）, **实现**（Realization），**关联**（Association)**，聚合**（Aggregation），**组合**(Composition)，**依赖**(Dependency)

**各种关系的强弱顺序：泛化 = 实现 > 组合 > 聚合 > 关联 > 依赖**



* 泛化：指继承；带三角箭头的实线，箭头指向父类
* 实现：指接口实现；带三角箭头的虚线，箭头指向接口
* 关联：指拥有，如：对象成员变量；带普通箭头的实心线，指向被拥有者
* 聚合：是整体与部分的关系；且部分可以离开整体而单独存在；
  * 在代码实现聚合关系时，成员对象通常作为构造方法、Setter方法或业务方法的参数注入到整体对象中。
  * 带空心菱形的实心线，菱形指向整体
* 组合：是整体与部分的关系，但部分不能离开整体而单独存在；如公司和部门是整体和部分的关系，没有公司就不存在部门。
  * 对象成员变量；
  * 带实心菱形的实线，菱形指向整体
* 依赖：是一种使用的关系，即一个类的实现需要另一个类的协助；
  * 局部变量、方法的参数或者对静态方法的调用
  * 带普通箭头的虚线，指向被使用者

---

# 三、数据类型

## 1、基本数据类型和引用类型

### 1> 基本数据类型

|类型| byte | short | int | long | float | double | char | boolean |
|---| --- | --- | --- | --- | --- | --- | --- | --- |
|字节数| 1 | 2 | 4 | 8 | 4 | 8 | 2 | 1 |
|取值范围| +- 2^7^ | +-2^15^ | +-2^31^ |+-2^63^| +-2^31^ | +-2^63^ || true/false |

byte：-128~127   short：-32768~32767

### 2> 引用数据类型

​	指类、接口、数组和字符串（String) 对象

**基本数据类型和引用数据类型区别**

* `基本数据类型`在被创建时，数值直接存储在栈上。
* `引用数据类型`在被创建时，对象的具体信息都存储在堆内存上，对象的引用地址存储在栈上



### 3> 自动装箱和拆箱

自动拆箱：故名思议就是`将对象重新转化为基本数据类型`：

```java
//装箱
Integer num = 10;
//拆箱
int num1 = num;
```

java对于Integer与int的自动装箱与拆箱的设计，是一种模式：叫享元模式（flyweight）

**注意下面代码结果：Integer在超出-128到127 之后的变化**

```java
//在-128~127 之外的数
Integer num1 = 297;   Integer num2 = 297;           
System.out.println("num1==num2: "+(num1==num2));                    
// 在-128~127 之内的数 
Integer num3 = 97;   Integer num4 = 97;   
System.out.println("num3==num4: "+(num3==num4));

打印的结果是：num1==num2: false    num3==num4: true 
```

原因：java定义，**自动装箱的Integer在–128到127，会被重用**

* 在自动装箱时对于值从**–128到127**之间的值，它们被装箱为Integer对象后，会存在内存中被重用，始终只存在一个对象
* 如果超过了从–128到127之间的值，被装箱后的Integer对象并不会被重用，即相当于每次装箱时都新建一个 Integer对象



---

## 2、String类型

String 类型 是一个final修饰的类型。

### 1> String、StringBuffer、 StringBuilder的区别

* 从运行速度上说，StringBuilder>StringBuffer>String，因为String是不可变的对象

* String：是字符串常量（由final修饰），StringBuffer和StringBuilder 是字符串变量

* **StringBuffer：有同步锁，**但效率低，适用于多线程下字符缓冲区进行大量操作。 

* StringBuilder：效率高，线程不安全，适用于单线程下的字符缓冲区进行大量操作的情况；

  

String和StringBuffer中的value[]都用于存储字符序列。但是,

* String中的是常量(final)数组，只能被赋值一次
* StringBuffer中的value[]是一个很普通的数组，通过append()方法将新字符串加入value[]末尾。这样也就改变了value[]的内容和大小了

[参考博客](https://www.cnblogs.com/goody9807/p/6516374.html)

------

### 2> “==”和equals的区别

* “==”：用于基本类型的变量，“值”比较；用于引用类型的变量，对象的内存地址比较；
* equals：默认情况下，比较引用类型的地址值。一般重写都是自动生成，比较对象的成员变量值是否相同

```java
//代码1  
String sa = "ab";                                          
String sb = "cd";                                       
String sab=sa+sb;                                      
String s="abcd";  
System.out.println(sab==s); // false  

//当执行sa+sb时，JVM首先会在堆中创建一个StringBuilder类，将刚生成的String对象的堆地址存放在局部变量sab中
//局部变量 s 存储的是常量池中"abcd"所对应的拘留字符串对象的地址


//代码2  
String sc="ab"+"cd";  
String sd="abcd";  
System.out.println(sc==sd); //true  

//"ab"+"cd"会直接在编译期就合并成常量"abcd"， 因此相同字面值常量"abcd"所对应的是同一个拘留字符串对象，自然地址也就相同。
```

------

### 3> Sting 常用方法

```java 
String(byte[] bytes) 
String(byte[] bytes, Charset charset)  
    
public boolean endsWith(String suffix)；//测试此字符串是否以指定的后缀结束
public boolean endsWith(String prefix, int toffset)；
public boolean startsWith(String prefix)
public boolean startsWith(String prefix, int toffset) //指定索引开始的子字符串是否以指定前缀开始

public char charAt(int index);//返回指定索引处的 char 值
public int lastIndexOf(int ch)
public int lastIndexOf(int ch,int fromIndex)
public int indexOf(String str)    
public int indexOf(String str,int fromIndex) //指定的索引开始反向搜索；字符的方法也有

public String[] split(String regex)
public String[] split(String regex, int limit)//limit为数字的长度
public char[] toCharArray()//字符串转换为一个新的字符数组
public String substring(int beginIndex)    
public String substring(int beginIndex, int endIndex) 

public String replace(char oldChar,char newChar)
public String replace(CharSequence target, CharSequence replacement)//说白了也就是类型就是字符串
public String replaceAll(String regex, String replacement)
public String replaceFirst(String regex, String replacement)
//如果replaceAll()和replaceFirst()所用的参数据不是基于规则表达式的，则与replace()替换字符串的效果是一样的，即这两者也支持字符串的操作；
public byte[] getBytes(Charset charset)
public int length()
public String trim()
public boolean isEmpty()
public String toLowerCase()    
public String toUpperCase()
public boolean equalsIgnoreCase(String anotherString);
public static String valueOf(boolean b)//将参数转换成字符串，还支持char/char[]/double/float/int/long和Object；Object：null对象等于 "null"，否则，返回 obj.toString()

//修改编码
new String(str.getBytes("ISO-8859-1"), "GBK");
```

------

## 3、Integer 类

Integer 只需要注意**自动装箱的Integer在–128到127，会被重用**

```java
//在-128~127 之外的数
Integer num1 = 297;   Integer num2 = 297;           
System.out.println("num1==num2: "+(num1==num2));                    
// 在-128~127 之内的数 
Integer num3 = 97;   Integer num4 = 97;   
System.out.println("num3==num4: "+(num3==num4));

打印的结果是：num1==num2: false    num3==num4: true 
    
java定义：在自动装箱时对于值从–128到127之间的值，它们被装箱为Integer对象后，会存在内存中被重用，始终只存在一个对象

而如果超过了从–128到127之间的值，被装箱后的Integer对象并不会被重用，即相当于每次装箱时都新建一个 Integer对象    
```

**Integer需要几个字节**?

​	每个Integer占用了3*4bytes

* Integer在内存中有一个指向方法区里边类信息的指针，这个指针占用4bytes；

* 另外Integer中实例变量只有一个int类型的字段，所以为32位，4bytes。

* 有4bytes的指向对象池的指针

  

**Integer**

```java
public static int parseInt(String s)
```

**Math**

```java
//方法相同，支持double、float、int、long
public static double abs(double a) //绝对值；
public static float max(float a, float b)//支持：
public static int min(int a, int b) 
```



---

# 四、抽象和接口

## 1、抽象类和接口的区别

* 抽象类和接口都不能直接实例化；抽象方法必须由子类来进行重写
* 抽象类单继承，接口多实现
* 抽象类可有构造方法，普通成员变量，非抽象的普通方法，静态方法
* 抽象类的抽象方法访问权限可以为：public、protected 、default
* 接口中变量类型默认public staic final，接口中普通方法默认public abstract，没有具体实现
  jdk1.8 中接口可有静态方法和default（有方法体）方法



**应用场合**

* 接口应用场景：
  * 需要将一组类视为单一的类，而调用者只通过接口来与这组类发生联系。
* 抽象类应用场景：
  * 在既需要统一的接口，又需要实例变量或缺省的方法的情况下就可以使用它
    * 定义了一组接口，但又不想强迫每个实现类都必须实现所有的接口

## 2、方法重载和重写

**多态性体现**：方法重载、方法重写、抽象类、接口

**重写0veriding和重载Overloading**

* 重写：发生在继承类中，方法名和参数列表相同，权限修饰符大于等于父类、返回值类型小于等于父类、抛出异常小于等于父类
* 重载：发生在同一个类中，方法名相同，参数列表不同（个数、类型、顺序），与权限修饰、返回值类型、抛出异常无关

---

# 五、类加载

## 1、类加载方式和时机

### 1> 类加载方式

- **静态加载** ：编译时刻加载的类是静态加载类；通过**new关键字来实例对象**，编译时执行
- **动态加载** ：运行时刻加载的类是动态加载类。通过**反射、序列化、克隆等方式**加载，运行期执行



**所以创建对象有4种方式：使用new关键字、反射、克隆（clone方法）、序列化**



**克隆（clone方法）** 分浅拷贝、深拷贝

**1.浅拷贝： **对基本数据类型进行值拷贝，对引用数据类型的`引用地址进行拷贝`，此为浅拷贝。

**2.深拷贝： **对基本数据类型进行值拷贝，对引用数据类型的`内容进行拷贝`，此为深拷贝。

---

### 2> 类初始化时机

- 使用new 实例化对象时
- 调用静态变量时（常量除外）、静态方法 
- 通过反射调用 
- 初始化一个类如果父类没有初始化，先触发父类的初始化 
- 执行main方法的启动类

**注意：**

1. 子类调用父类的静态变量，子类不会被初始化，只有父类被初始化
2. 通过数组定义来引用类，不会触发类的初始化
3. 访问类的常量，不会初始化类



**1、子类调用父类的静态变量，子类不会被初始化。只有父类被初始化**

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
 
 class SubClass extends SuperClassB {
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
//输出
superclassA init
superclassB init
1
subclass init

----------分析----------
1、SubClass.value,依次向上，在父类中寻找此变量， 调用首次遇到的父类的静态属性，所以只初始化此父类；
2、new SubClass() 时，因为此时已经初始化过父类了， 即不再进行父类初始化，只初始化子类
3、如果注释superclassB 的value变量；则输出如下：
superclassA init
123
superclassB init
subclass init

此时： 调用的是superclassA 的属性，即先加载superclassA；
而后有new subclass（）； 即 初始化subclass 和其父类superclassB， superclassA 已经初始化过了，便不再初始化
```



**2、调用静态常量不出进行初始化**

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
//程序输出结果
hello world
```



## 2、 类初始化内容和顺序

### 1> 初始化内容

* 一个类的静态属性、静态块、普通属性、普通方法块、构造函数
* **构造函数：只有在new 关键字时是初始化**

```java
class SuperClass{
	// 构造函数
    public SuperClass() {
        System.out.println("构造函数---初始化");
    }
    // 静态方法块
    static {
        System.out.println("静态方法块--初始化");
    }
    // 静态属性
    public static String staticField = getStaticField();
    
    public static String getStaticField() {
        String statiFiled = "Static Field Initial";
        System.out.println("静态属性--初始化---");
        return statiFiled;
    }
}
 
public class Test {
    public static void main(String[] argc) {
        System.out.println(SuperClass.staticField);
    }
}
//输出
静态方法块1--初始化---父类
静态属性1--初始化---父类
Static Field Initial

// 没有用new 关键字，不会调用构造器
```



### 2> 初始化顺序

* 先加载静态的属性和静态块，此二者谁定义在前，先初始化谁
* 在加载普通属性、普通方法块，此二者谁定义在前，先初始化谁
* 然后加载构造函数，构造函数调new 谁，加载谁
* 最后调用普通方法



**有继承的子类：**

* 先加载静态的属性和静态块，不过先加载父类的，然后子类
* 再加载先加载父类的普通属性、普通方法块、构造函数
* 再加载先加载子类的普通属性、普通方法块、构造函数



```java
 public class SuperClass {
     // 普通方法块
     {
         System.out.println("普通方法块1--初始化---父类");
     }
     // 构造函数
     public SuperClass() {
         System.out.println("构造函数1---开始初始化---父类");
     }
     // 静态方法块
     static {
         System.out.println("静态方法块1--初始化---父类");
     }
     // 静态属性
     private static String staticField = getStaticField();
     
     // 静态方法块
     static {
         System.out.println("静态方法块2--初始化---父类");
     }
     // 普通属性
     private String field2 = getField2();

     // 普通方法块
     {
         System.out.println("普通方法块2--初始化---父类");
     }
     // 构造函数
     public SuperClass(int n) {
         System.out.println("构造函数2--开始初始化---父类");
     }
     // 静态属性
     private static String staticField2 = getStaticField2();
     // 普通属性
     private String field = getField();

     public static String getStaticField() {
         String statiFiled = "Static Field Initial";
         System.out.println("静态属性1--初始化---父类");
         return statiFiled;
     }
     public static String getStaticField2() {
         String statiFiled = "Static Field Initial";
         System.out.println("静态属性2--初始化---父类");
         return statiFiled;
     }

     public static String getField() {
         String filed = "Field Initial";
         System.out.println("普通属性1---初始化---父类");
         return filed;
     }   
     public static String getField2() {
         String filed = "Field Initial";
         System.out.println("普通属性2--初始化---父类");
         return filed;
     } 
 }



 public class Test extends SuperClass{
     // 普通方法块
     {
         System.out.println("普通方法块1--初始化");
     }
     // 构造函数
     public Test() {
         System.out.println("构造函数1---开始初始化");
     }
     // 静态方法块
     static {
         System.out.println("静态方法块1--初始化");
     }
     // 静态属性
     private static String staticField = getStaticField();
     
     // 静态方法块
     static {
         System.out.println("静态方法块2--初始化");
     }
     // 普通属性
     private String field2 = getField2();

     // 普通方法块
     {
         System.out.println("普通方法块2--初始化");
     }
     // 构造函数
     public Test(int n) {
         System.out.println("构造函数2--开始初始化");
     }
     // 静态属性
     private static String staticField2 = getStaticField2();
     // 普通属性
     private String field = getField();
     
     

     public static String getStaticField() {
         String statiFiled = "Static Field Initial";
         System.out.println("静态属性1--初始化");
         return statiFiled;
     }
     public static String getStaticField2() {
         String statiFiled = "Static Field Initial";
         System.out.println("静态属性2--初始化");
         return statiFiled;
     }

     public static String getField() {
         String filed = "Field Initial";
         System.out.println("普通属性1---初始化");
         return filed;
     }   
     public static String getField2() {
         String filed = "Field Initial";
         System.out.println("普通属性2--初始化");
         return filed;
     }   
     // 主函数
     public static void main(String[] argc) {
         new Test(2);
     }
 }

//输出
静态方法块1--初始化---父类
静态属性1--初始化---父类
静态方法块2--初始化---父类
静态属性2--初始化---父类
静态方法块1--初始化
静态属性1--初始化
静态方法块2--初始化
静态属性2--初始化
普通方法块1--初始化---父类
普通属性2--初始化---父类
普通方法块2--初始化---父类
普通属性1---初始化---父类
构造函数1---开始初始化---父类
普通方法块1--初始化
普通属性2--初始化
普通方法块2--初始化
普通属性1---初始化
构造函数2--开始初始化


```



以下代码也是一个初始化顺序的问题，你能得正确结果吗？

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
//输出
count1=1
count2=0
    
// 分析
    1、SingleTon.getInstance(); 是调用静态方法，因为SingleTon还没有初始化，则，此时需要初始化该类
    2、在类的加载阶段分：加载，验证，准备，解析，初始化，调用，卸载等七个时期，
    	准备阶段：则实将非final 的静态属性，赋 零值，
    	初始化阶段：执行的是静态属性赋值 和静态代码块 则实赋实际程序员定义的值
    所以：
    	1、第一步准备阶段：即singleton=null count1=0,count2=0
    	2、第2步初始化阶段，根据执行的属性，静态变量，谁先定义，谁先初始化。即过程如下：
    	-->先初始化 singleTon ；这里是构造方法的执行。此时：count1=1,count2=1；
    	--> 然后，由于count1 没有赋值动作，则不执行。
    	-->最后给count2 赋值，即：count2=0
    注意：如果singleTon 属性放在count2 后， 则结果就不一样了。而是count1=1,count2=1；
```



---

# 六、逻辑运算与位运算

## 1、位运算

## 2、逻辑运算

### 1> i++ 、 ++i和i+=1、i=i+1 的问题

* **i++ 和 ++i 的区别：**

  i++：先赋值，在相加，

  ++i：先相加，在赋值

```java
public class Test {
	public static int print1() {
	    int i = 0;
	    i++;
	    return i++;
	}
	public static int print2() {
		int i = 0;
		i++;
		return ++i;
	}
	public static void main(String[] args) {
		System.out.println(print1());
		System.out.println(print2());
        int i=0;
		System.out.println(i++);
        System.out.println(++i);
	}
}
//输出：1，2，0，2
i++,是先赋值后相加，所以返回或者输出时，都是之前赋过得值，不是相加后的值
++i,是先相加后赋值，所以最后一次的返回结果时进行了赋值
```

**i=i++到底是怎么执行的**

```java 
public class Inc {  
    public static void main(String[] args) {  
       Inc inc = new Inc();  
       int i = 0;  
       inc.fermin(i);  
       i= i ++;  
       System.out.println(i); 
   
    }  
    void fermin(int i){  
       i++;  
    }  
}  
//答案是0

原因是：

Java使用了中间缓存变量机制：
i=i++;等同于：
temp=i； (等号右边的i)
i=i+1;      (等号右边的i)
i=temp;   (等号左边的i)
而i=++i;则等同于：
i=i+1;
temp=i;
i=temp;

inc.fermin(i); 是一个干扰项，考值传递还是引用传递
	
```



- **i=i+1 和 i+=1 的区别**

  i+=1 会进行自动类型转换



### 2> finally代码对提前return的影响

1. **finally块的代码一定会执行，且只对提前return， 不会发生返回值修改**
2. **返回值是基本数据类型 和 String 类型** ：finally块的**不会改变**try块catch块的`返回值`
3. **返回值是引用类型**：finally块**会改变**try块catch块的返回对象的属性值，对象的引用地址并不改变

```java
//值传递
public class Test {
	public static int fun(int i) {
		try {
			System.out.println(i);
			i=i/0; 
			return i; 
		}catch (Exception e) {
			i=20;
			System.out.println(i);
			return i; 
		}finally {
			i=30;
			System.out.println(i=300);
		}
        //return i;
	}
    public static void main(String[] argc) {
    	System.out.println(fun(0));
    }
}
//输出
0
20
300
20

```

分析：最后一行的结果不是30和300， 这说明**finally的赋值不会对基本数据类型的返回值作出修改**
// 第3 个数返回300， 说明finally是一定会执行的，只是操作对返回结果无影响

**如果将return 放在fun() 的最后执行，如：注释位置。此时会怎么样？**

* 通过代码实现，输出：0、20、300、300
* 这说明什么？ **说明finally 操作只对提前return 不会产生影响，如果return在finally后执行，那么finally中的操作结果是有效的**

---

**如果将返回值得类型换成String类型呢？**

```java
public class Test {
	public static String fun(String s) {
		try {
			System.out.println(s);
			System.out.println(Integer.parseInt(s));
			return s; 
		}catch (Exception e) {
			s="2";
			System.out.println(s);
			return s; 
		}finally {
			s="3";
			System.out.println(s="30");
		}
	}
    public static void main(String[] argc) {
    	System.out.println(fun("B"));
    }
}
// 输出：
B
2
30
2
```

我们发现，String 类型的返回值。finally 块也不会对其返回值作出修改。



**那如果是其他的对象引用类型呢；**

```java
public class Test {
	public static int[] fun(int[] x ) {
	        try{
	            x[0] = 1;
	            x[1] = 1;
	            throw new Exception();
	        } catch (Exception e){
	            x[1] = 2;
	            return x;
	        }finally {
	            x[1] = 3;
	        }
	}
    public static void main(String[] argc) {
    	int[] x = {0,0};
        System.out.println(x==fun(x));
    	System.out.println(Arrays.toString(fun(x)));
    }
}
//输出
true
[1, 3]
```

从上面代码可以看出：

对象的引用地址，并没有发生变化。但是对象属性值却发生改变了。

这和方法的引用传递其实是一个道理！！

---

### 3> 方法参数值传递和引用传递

在方法参数传递过程中，其实是传递一个副本，所以：

* 基本数据类型和String 都是修改的副本值。所以，**对参数不会发生改变**
* 引用类型是其引用地址不会修改，但副本地址也指向了原来的值，因此**引用类型属性值是会发生修改的。**



```java
package com.hsy.demo;

import java.util.Arrays;

class Person {
	private String name;
	private int age;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
}

public class Test {
	public static void stringChange(String name, int age, Person person) {
		name = "-----";
		age = 0;
		person.setName("-----");
		person.setAge(0);
	}

	public static void main(String[] args) {
		Person person = new Person();
		person.setName("张三");
		person.setAge(10);

		String name = "张三";
		int age = 10;

		System.out.println("Person: " + person.getName() + "," + person.getAge());
		System.out.println("main : " + name + "," + age);
		
        System.out.println("==============================");
		stringChange(name,age,person);
		System.out.println("Person: " + person.getName() + "," + person.getAge());
		System.out.println("main : " + name + "," + age);
	}
}
//运行结果如下：
Person: 张三,10
main : 张三,10
==============================
Person: -----,0
main : 张三,10
```

由上代码得出：基本数据类型和String类型，不会改变；引用类型其属性会改变



### 4> for循环执行顺序

对于for循环中条件的执行顺序是怎么样的，你知道吗？

比如;  for(i=0;i<10;i++){}

其实很简单，普通for顺序如下：

1. 先对循环变量赋初始值，如：i=0
2. 在执行 循环判读是否满足条件
3. 满足条件，则执行循环体
4. 在执行循环变量，自增或自减操作
5. 再循环2，3，4步。知道不满足判读条件，跳出循环

测试如下：

```java
public class Test {
	static boolean foo(char c) {
		System.out.print(c);
		return true;
	}

	public static void main(String[] args) {
		int i=0;
		for(foo('A');foo('B')&&i<2;foo('C')) {
			i++;
			foo('D');
		}
	}
}
// 输出如下：
ABDCBDCB
```

输出结果你答对了吗？



### 5> switch中continue和break 的影响

首先我们需要理解一下

**continue和break 的区别**

* continue： 表示终止本次循环的执行
* break ： 表示结束当前层整个循环，嵌套循环时外层不受影响



**在switch 语句环境里，如果当前配置中了的case 中没有continue和break，则会执行下一个case；**

如下：

```java
public class Test {
	public static void fun(int i) {
		switch (i) {
		case 0:
			System.out.println("case 0:");
		case 1:
			System.out.println("case 1:");
		case 2:
			System.out.println("case 2:");
            // break ;    1
		case 3:
			System.out.println("case 3:");
            // continue;		2
		case 4:
			System.out.println("case 4:");
		}
	}
	public static void main(String[] args) {
		fun(1);
	}
}
//输出：
case 1:
case 2:
case 3:
case 4:
```

 **如果有break 呢？ 比如取消 `1 `处 的注释**

此时输出：

case 1:
case 2:

 所以，我们可以理解为：**switch，其实就是一个case的循环，不过只能执行一次。break则可以中断case 循环。**



**如果有continue呢？比如取消 ` 2 ` 处的注释**

我们发现什么，发现提示报错，为什么？？

因为continue 不能再switch中执行。除非外层有for 等循环体包裹。

```java
public static void fun(int i) {
    for (int j = i; j < 5; j++) {
        switch (j) {
            case 0:
                System.out.println("case 0: j="+j);
            case 1:
                System.out.println("case 1: j="+j);
            case 2:
                System.out.println("case 2: j="+j);
                //break;
            case 3:
                System.out.println("case 3: j="+j);
                continue;
            case 4:
                System.out.println("case 4: j="+j);
        }
        System.out.println("------");
    }
}

public static void main(String[] args) {
    fun(2);
}
//输出
case 2: j=2
case 3: j=2
case 3: j=3
case 4: j=4
------
```

  由上面代码可以看出。 continue 终止的是 for 循环中的当前循环。

取消 上面break 注释 ，执行结果如下：

```
case 2: j=2
------
case 3: j=3
case 4: j=4
------
```

发现没有输出：case 3: j=2  ，并且多了一行“------”

这说明switch中的break， 对for循环时无效的，只作用于switch 上，所以在终止switch循环后，还会执行for循环中后续的代码



---

# 七、反射

## 1、反射的定义和特点

**定义：**

* **反射就是通过字节码文件找到某一个类、类中的方法以及属性等**
* Java反射就是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意方法和属性；并且能改变它的属性。



**特点：**

* 优点

  （1）能够运行时动态获取类的实例，大大提高系统的灵活性和扩展性。 
  （2）与Java动态编译相结合，可以实现无比强大的功能 

* 缺点 
  （1）使用反射的性能较低 
  （2）使用反射相对来说不安全 
  （3）破坏了类的封装性，可以通过反射获取这个类的私有方法和属性 

## 2、反射实现方式

**3种实现方式：**

- 直接通过类名.class方式获得：Class clazz = User.class;
- 通过对象的getClass()方法获取：User user =new User();Class<?> clazz =user.getClass();
- 通过全类名获取：Class<?> clazz = Class.forName("com.bobo.User");

 

**反射常用类**：Class(类的对象)、Constructor(类的构造方法)、Field(类中的属性对象)、Method(类中的方法对象）



**Class.forName和ClassLoader.loadClass的区别**

* Class.forName除了将类的.class文件加载到jvm中之外，还会对类进行解释，**执行类中的static块。**

* ClassLoader只将.class文件加载到jvm中，不会执行static块中的内容，只有在newInstance才会去执行static块。ClassLoader.loadClass().newInstance()

* Class.forName(name,initialize,loader)通过参数控制是否加载static块。并且只有调用了newInstance()方法采用调用构造函数，创建类的对象。

---

# 八、异常

异常主要分两大类：**Exception** 和**Error** ，他们都是继承了Throwable类

**Exception：**

* 是程序本身可以预料、可以处理的异常，应该被捕获。

* Exception又分为可检查异常和不可检查异常(RuntimeException)。
  * **可检查异常：** Java编译器要求`必须捕获或抛出`

  * **不可检查时异常：** Java编译器不要求一定捕获或抛出，`可以不做处理`。像NullPointerException、ArrayIndexOutOfBoundsException之类，

**Error：**

* 是程序无法处理的错误，**不便于也不需要捕获**。
* 常见的比如OutOfMemoryError之类都是Error的子类。

# 九、JSON和XML

两者的区别

* xml是重量级的，文件格式复杂，所以在远程调用时，比较占宽带。
* json因为是轻量级，文件格式都是压缩的，占宽带小。

## 1、JSON 

* JavaScript Object Notation，JS 对象简谱，是一种**轻量级的数据交换格式**
* JSON 是 JS 对象的字符串表示法，它使用文本表示一个 JS 对象的信息，本质是一个字符串。

* 支持任何类型：例如字符串、数字、对象、数组等

  * 对象用键值对表示，逗号分隔，花括号保存

    * ```json
      {"firstName": "Brett", "lastName": "McLaughlin"}
      ```

  * 数组用方括号保存

    * ```json
      {"people":[{"firstName": "Brett"},{"firstName":"Jason"}]}
      ```

* JSON解析工具：阿里巴巴fastjson、谷歌gson,jackJson



**JSON 和 JS 对象互转**

* JSON字符串转换为JS对象，使用 JSON.parse() 方法

  * ```js
    var obj = JSON.parse('{"a": "Hello", "b": "World"}');
    ```

* JS对象转换为JSON字符串，使用 JSON.stringify() 方法

  * ```js
    var json = JSON.stringify({a: 'Hello', b: 'World'});
    ```



## 2、XML

* 是一种用于标记电子文件使其**具有结构性的标记语言**

* xml 解析方式：1、DOM解析；2、SAX解析；3、JDOM解析；4、DOM4J解析
* **DOM4J性能最好**



[解析参考](https://www.cnblogs.com/longqingyang/p/5577937.html)

### 1> DOM解析

* DOM的全称是Document Object Model，也即文档对象模型

* Dom解析是将xml文件全部载入到内存，组装成一颗dom树，然后通过节点以及节点之间的关系来解析xml文件,与平台无关，但是由于整个文档都需要载入内存,不适用于文档较大时。

* ```java
  //创建DocumentBuilder对象
  DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
  //通过DocumentBuilder对象的parser方法加载books.xml文件到当前项目下
  Document document = db.parse("books.xml");
  //获取所有book节点的集合
  NodeList bookList = document.getElementsByTagName("book");
  ```

  

### 2> SAX解析

* SAX的全称是Simple APIs for XML，也即XML简单应用程序接口

* 基于事件驱动,逐条解析，可以在某个条件得到满足时停止解析，不必解析整个文档。 适用于只处理xml数据，不易编码,而且很难同时访问同一个文档中的多处不同数据

* 需要自定义DefaultHandler处理器

  

### 3> JDOM解析

* 简化与XML的交互并且比使用DOM实现更快,仅使用具体类而不使用接口因此简化了API,并且易于使用

* ```java
  Document document = new SAXBuilder().build(new FileInputStream(fileName));  
  //获取根节点bookstore  
  Element rootElement = document.getRootElement();  
  //获取根节点的子节点，返回子节点的数组  
  List<Element> bookList = rootElement.getChildren(); 
  ```

  

### 4> DOM4J解析

* JDOM的一种智能分支，它合并了许多超出基本XML文档表示的功能。
* 它使用接口和抽象基本类方法，具有性能优异、灵活性好、功能强大和极端易用的特点

[参考借鉴](https://blog.csdn.net/redarmy_chen/article/details/12969219)

DOM4j中，**获得Document对象的方式**有三种：

```java
// 1.读取XML文件,获得document对象            
SAXReader reader = new SAXReader();              
Document   document = reader.read(new File("csdn.xml"));
// 2.解析XML形式的文本,得到document对象.
String text = "<csdn></csdn>";            
Document document = DocumentHelper.parseText(text);
// 3.主动创建document对象.
Document document = DocumentHelper.createDocument();             //创建根节点
Element root = document.addElement("csdn");

```

**节点对象的属性方法操作**

```java
// 1.取得某节点下的某属性    
Element root=document.getRootElement();        //属性名name
Attribute attribute=root.attribute("id");
// 2.取得属性的文字
String text=attribute.getText();
// 3.删除某属性 
Attribute attribute=root.attribute("size"); 
root.remove(attribute);
// 4.遍历某节点的所有属性   
Element root=document.getRootElement();      
for(Iterator it=root.attributeIterator();it.hasNext();){        
    Attribute attribute = (Attribute) it.next();         
    String text=attribute.getText();        
    System.out.println(text);  
}
// 5.设置某节点的属性和文字.   
newMemberElm.addAttribute("name", "sitinspring");
// 6.设置属性的文字   
Attribute attribute=root.attribute("name");   
attribute.setText("csdn");

```

**将文档写入XML文件**

```java
// 1.文档中全为英文,不设置编码,直接写入的形式.  
XMLWriter writer = new XMLWriter(new  FileWriter("ot.xml")); 
writer.write(document);  
writer.close();
// 2.文档中含有中文,设置编码格式写入的形式.
OutputFormat format = OutputFormat.createPrettyPrint();// 创建文件输出的时候，自动缩进的格式                  
format.setEncoding("UTF-8");//设置编码
XMLWriter writer = new XMLWriter(newFileWriter("output.xml"),format);
writer.write(document);
writer.close();
```

**字符串与XML的转换**

```java
// 1.将字符串转化为XML
String text = "<csdn> <java>Java班</java></csdn>";
Document document = DocumentHelper.parseText(text);
// 2.将文档或节点的XML转化为字符串.
SAXReader reader = new SAXReader();
Document   document = reader.read(new File("csdn.xml"));            
Element root=document.getRootElement();    
String docXmlText=document.asXML();
String rootXmlText=root.asXML();
Element memberElm=root.element("csdn");
String memberXmlText=memberElm.asXML();

```



# 十、JDK 版本特性

## 1、JDK 7 新特性

- 二进制字面量
- 在数字字面量使用下划线
- switch可以使用string了
- 实例创建的类型推断
- 使用Varargs方法使用不可维护的形式参数时改进了编译器警告和错误
- try-with-resources 资源的自动管理
- 捕捉多个异常类型和对重新抛出异常的高级类型检查

## 2、JDK 8 新特性

参考：https://www.runoob.com/java/java8-lambda-expressions.html

jdk 8 有十大新特性：

- **Lambda 表达式**：允许把函数作为一个方法的参数
- **方法引用**：可以直接引用已有Java类或对象（实例）的方法或构造器。与lambda联合使用，方法引用可以使语言的构造更紧凑简洁，减少冗余代码。
- **默认方法**：在接口里面有了一个实现的方法
- **新编译工具**：新的编译工具，如：Nashorn引擎 jjs、 类依赖分析器jdeps。
- **Stream API**：新添加的Stream API（java.util.stream） 把真正的函数式编程风格引入到Java中
- **Date Time API** ：加强对日期与时间的处理
- **Optional 类** ：解决空指针异常。
- **Nashorn, JavaScript 引擎**：允许我们在JVM上运行特定的javascript应用。



 JDK 8 的应用，可以使用 Instant 代替 Date ， LocalDateTime 代替 Calendar ，
DateTimeFormatter 代替 SimpleDateFormat



## 3、Java 9 新特性

* **模块系统**：模块是一个包的容器，Java 9 最大的变化之一是引入了模块系统（Jigsaw 项目）。
* **REPL (JShell)**：交互式编程环境。
* **HTTP 2 客户端**：HTTP/2标准是HTTP协议的最新版本，新的 HTTPClient API 支持 WebSocket 和 HTTP2 流以及服务器推送特性。
* **改进的 Javadoc**：Javadoc 现在支持在 API 文档中的进行搜索。另外，Javadoc 的输出现在符合兼容 HTML5 标准。
* **多版本兼容 JAR 包**：多版本兼容 JAR 功能能让你创建仅在特定版本的 Java 环境中运行库程序时选择使用的 class 版本。
* **集合工厂方法**：List，Set 和 Map 接口中，新的静态工厂方法可以创建这些集合的不可变实例。
* **私有接口方法**：在接口中使用private私有方法。我们可以使用 private 访问修饰符在接口中编写私有方法。
* **进程 API**: 改进的 API 来控制和管理操作系统进程。引进 java.lang.ProcessHandle 及其嵌套接口 Info 来让开发者逃离时常因为要获取一个本地进程的 PID 而不得不使用本地代码的窘境。
* **改进的 Stream API**：改进的 Stream API 添加了一些便利的方法，使流处理更容易，并使用收集器编写复杂的查询。
* **改进 try-with-resources**：如果你已经有一个资源是 final 或等效于 final 变量,您可以在 try-with-resources 语句中使用该变量，而无需在 try-with-resources 语句中声明一个新变量。
* **改进的弃用注解 @Deprecated**：注解 @Deprecated 可以标记 Java API 状态，可以表示被标记的 API 将会被移除，或者已经破坏。
* **改进钻石操作符(Diamond Operator)** ：匿名类可以使用钻石操作符(Diamond Operator)。
* **改进 Optional 类**：java.util.Optional 添加了很多新的有用方法，Optional 可以直接转为 stream。
* **多分辨率图像 API**：定义多分辨率图像API，开发者可以很容易的操作和展示不同分辨率的图像了。
* **改进的 CompletableFuture API** ： CompletableFuture 类的异步机制可以在 ProcessHandle.onExit 方法退出时执行操作。
* **轻量级的 JSON API**：内置了一个轻量级的JSON API
* **响应式流（Reactive Streams) API**: Java 9中引入了新的响应式流 API 来支持 Java 9 中的响应式编程。

---
**offer直通车（一）之Java**

[Java（一）--基础](https://blog.csdn.net/u013234928/article/details/89408403)

[Java（二）--集合类](https://blog.csdn.net/u013234928/article/details/89416161)

[Java（三）--多线程](https://blog.csdn.net/u013234928/article/details/89416222)

[Java（四）--网络通讯](https://blog.csdn.net/u013234928/article/details/89416717)

[Java（五）--IO](https://blog.csdn.net/u013234928/article/details/89416304)

[Java（六）--JDBC](https://blog.csdn.net/u013234928/article/details/89416673)

[Java（七）--JVM](https://blog.csdn.net/u013234928/article/details/89416488)

---
**面试总结整理：**

 [offer直通车（一）之JAVA](https://blog.csdn.net/u013234928/article/details/89408403)

[offer直通车（二）之数据结构与算法](https://blog.csdn.net/u013234928/article/details/89416844)

 [offer直通车（三）之设计模式](https://blog.csdn.net/u013234928/article/details/89431038)

 [offer直通车（四）之数据库](https://blog.csdn.net/u013234928/article/details/89417009)

 offer直通车（五）之WEB

[offer直通车（六）之Spring系列](https://blog.csdn.net/u013234928/article/details/89432116)

offer直通车（七）之Linux 系统

[offer直通车（八）之分布式微服务](https://blog.csdn.net/u013234928/article/details/89430788)

[offer直通车（九）之缓存中间件](https://blog.csdn.net/u013234928/article/details/89430213)

[offer直通车（十）之消息中间件](https://blog.csdn.net/u013234928/article/details/89430897)