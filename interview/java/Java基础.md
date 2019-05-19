# JAVA基础

# 一、面向对象

## 1、封装、继承、多态

* 封装：利用抽象数据类型将数据和基于数据的操作封装在一起，使其构成一个不可分割的独立实体，隐藏内部的细节，只保留一些对外接口使之与外部发生联系。优点：减少耦合，代码重用，减轻维护
* 继承：它可以使用现有类的所有功能，并在无需重新编写原来的类的情况下对这些功能进行扩展。
* 多态：指允许不同类的对象对同一消息做出响应。

  * **编译时多态**：主要指方法的重载
  * **运行时多态**：指程序中定义的对象引用所指向的具体类型在运行期间才确定

**运行时多态有三个条件**：继承、覆盖（重写）、向上转型（父类引用指向子类对象）

## 2、类图

在UML类图中，常见的有以下几种关系: **泛化**（Generalization）, **实现**（Realization），**关联**（Association)**，聚合**（Aggregation），**组合**(Composition)，**依赖**(Dependency)

**各种关系的强弱顺序：泛化 = 实现 > 组合 > 聚合 > 关联 > 依赖**

* 泛化：指继承；**实线三角箭头**，箭头指向父类
* 实现：指接口实现；**虚线三角箭头**，箭头指向接口
* 聚合：是整体与部分的关系；且部分可以离开整体而单独存在；
  * 在代码实现聚合关系时，成员对象通常作为构造方法、Setter方法或业务方法的参数注入到整体对象中。
  * 带**空心菱形的实线**，菱形指向整体
* 组合：是整体与部分的关系，但部分不能离开整体而单独存在；比如公司和部门，公司没了部门就不存在了，但是公司和员工就属于聚合关系了，因为公司没了员工还在。
  * 对象成员变量；
  * 带**实心菱形的实线**，菱形指向整体
* 关联：指拥有，如：对象成员变量；带**普通箭头的实心线**，指向被拥有者，如Student 和School
* 依赖：是一种使用的关系，依赖关系是在运行过程中起作用的，即一个类的实现需要另一个类的协助；
  * 局部变量、方法的参数或者对静态方法的调用
  * 带**普通箭头的虚线**，指向被使用者

## 3、六大原则

1. **开闭原则**：对扩展开发放，对修改关闭，要求在添加新功能时不需要修改代码，符合开闭原则最典型的设计模式是装饰者模式
2. **单一职责原则**：一个类只负责一件事，尽量使用合成/聚合的方式，而不是使用继承。
3. **里式替换原则** ：任何基类可以出现的地方，子类一定可以出现。
4. **依赖倒转原则**：依赖于抽象而不依赖于具体
5. **接口隔离原则**：使用多个隔离的接口，比使用单个接口要好 ，不应该强迫客户依赖于它们不用的方法。
6. **迪米特法则**：一个软件实体应当尽可能少地与其他实体发生相互作用。

## 4、标识符

* 使用字母、下划线(_)、美元符($)、人民币符号(￥) 和数字（不能以数字开头）
* 大小写敏感，长度不限，不能使用关键字

---

# 二、关键字

## 1、访问权限

可以对类或类中的成员（字段以及方法）加上访问修饰符。private、default(默认)、protected 以及 public

访问权限范围：本类、同一包、子类、无限制

* 类可见表示其它类可以用这个类创建实例对象。
* 成员可见表示其它类可以用这个类的实例对象访问到该成员；

**private < default < protected < public**

private 		：本类
default 		：本类、同一包
protected	：本类、同一包、被继承
public			:   本类、同一包、被继承、不同包

protected 用于修饰成员，表示在继承体系中成员对于子类可见，但是这个访问修饰符对于类没有意义。

如果子类的方法重写了父类的方法，那么子类中该方法的访问级别不允许低于父类的访问级别。这是为了确保可以使用父类实例的地方都可以使用子类实例，也就是确保满足里氏替换原则。

## 2、final 关键字

* **声明变量**：表示常量，对于基本类型，final 使数值不变；对于引用类型，final 使引用不变，但对象本身是可以修改的。

* **声明方法**：不能被子类的方法重写，但可以被继承，**不能修饰构造方法**。。

* **声明类** ：不能被继承，没有子类，final类中的方法默认是final的。

  

## 3、static 关键字

* **静态变量**：又称为类变量，类所有的实例都共享静态变量，在内存中只存在一份
* **静态方法**：在类加载的时候就存在了，它不依赖于任何实例，只能访问所属类的静态字段和静态方法，方法中不能有 this 和 super 关键字（此时可能没有实例）。
* **静态语句块**：在类初始化时运行一次。
* **静态内部类**：非静态内部类依赖于外部类的实例，而静态内部类不需要。静态内部类不能访问外部类的非静态的变量和方法。

特性：

* **静态变量，静态方法可以通过类名直接访问**

* **初始化顺序**：静态变量和静态语句块优先于实例变量和普通语句块，静态变量和静态语句块的初始化顺序取决于它们在代码中的顺序。

  

实例变量：每创建一个实例就会产生一个实例变量，它与该实例同生共死。



**成员变量、静态变量、局部变量的区别**

* 静态变量可以被对象调用，也可以被类名调用。以static关键字申明的变量，其独立在对象之外，有许多对象共享的变量。在对象产生之前产生，存在于**方法区静态区中**。
* 成员变量只能被对象调用。随着对象创建而存在，随对象销毁而销毁。存在于**堆栈内存中**
* 局部变量在方法或语句块中申明的变量，生命周期只在定义的{}之中，不能跨方法或语句块使用。
* 成员变量可以称为对象的特有数据，**静态变量称为对象的共享数据**

---

# 三、数据类型

## 1、基本类型

|类型| byte | short | int | long | float | double | char | boolean |
|---| --- | --- | --- | --- | --- | --- | --- | --- |
|字节数| 1 | 2 | 4 | 8 | 4 | 8 | 2 | 1 |
|取值范围| +- 2^7^ | +-2^15^ | +-2^31^ |+-2^63^| +-2^31^ | +-2^63^ || true/false |

byte：-128~127   short：-32768~32767

JVM 会在编译时期将 boolean 类型的数据转换为 int，使用 1 来表示 true，0 表示 false。JVM 支持 boolean 数组，但是是通过读写 byte 数组来实现的

## 2、引用类型

基本类型都有对应的包装类型，基本类型与其对应的包装类型之间的赋值使用自动装箱与拆箱完成。

指类、接口、数组和字符串（String) 对象类型

**基本数据类型和引用数据类型区别**

* `基本数据类型`在被创建时，数值直接存储在栈上。
* `引用数据类型`在被创建时，对象的具体信息都存储在堆内存上，对象的引用地址存储在栈上

**自动装箱和拆箱**

自动拆箱：故名思议就是`将对象重新转化为基本数据类型`；是享元模式（flyweight）

```java
Integer num = 10;	//装箱
int num1 = num;	//拆箱
```

**缓存池**

**1、new Integer(123) 与 Integer.valueOf(123) 的区别在于：**

* new Integer(123) 每次都会新建一个对象；
* Integer.valueOf(123) 会使用缓存池中的对象，多次调用会取得同一个对象的引用。

```java
Integer x = new Integer(123);
Integer y = new Integer(123);
System.out.println(x == y);    // false
Integer z = Integer.valueOf(123);
Integer k = Integer.valueOf(123);
System.out.println(z == k);   // true
```

valueOf() 方法的实现比较简单，就是先判断值是否在缓存池中，如果在的话就直接返回缓存池的内容。



**2、Integer 和 Short 缓存池的大小默认为 -128~127**

编译器会在自动装箱过程调用 valueOf() 方法，如果该数值范围在缓冲池范围内，就可以直接使用缓冲池中的对象。

```java
//在-128~127 之外的数
Integer num1 = 297;   Integer num2 = 297;           
System.out.println("num1==num2: "+(num1==num2));     //false               
// 在-128~127 之内的数 
Integer num3 = 97;   Integer num4 = 97;   
System.out.println("num3==num4: "+(num3==num4));     //true      
```

如果超过了从–128到127之间的值，被装箱后的Integer对象并不会被重用，即相当于每次装箱时都新建一个 Integer对象



扩展：

在 jdk 1.8 所有的数值类缓冲池中，Integer 的缓冲池 IntegerCache 很特殊，这个缓冲池的下界是 - 128，上界默认是 127，但是这个上界是可调的，在启动 jvm 的时候，通过 -XX:AutoBoxCacheMax=<size> 来指定这个缓冲池的大小，该选项在 JVM 初始化的时候会设定一个名为 java.lang.IntegerCache.high 系统属性，然后 IntegerCache 初始化的时候就会读取该系统属性来决定上界。

---

## 3、String类型

String 被声明为 final，因此它不可被继承。

在 Java 8 中，String 内部使用 char 数组存储数据。

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence {
    private final char value[];
}
```

value 数组被声明为 final，这意味着 value 数组初始化之后就不能再引用其它数组。并且 String 内部没有改变 value 数组的方法，因此可以保证 String 不可变。

**String 不可变的好处**

* **可以缓存 hash 值**：因为 String 的 hash 值经常被使用，例如 String 用做 HashMap 的 key。不可变的特性可以使得 hash 值也不可变，因此只需要进行一次计算。
* **String Pool 的需要**：如果一个 String 对象已经被创建过了，那么就会从 String Pool 中取得引用。只有 String 是不可变的，才可能使用 String Pool。
* **安全性**：String 不可变性天生具备线程安全，可以在多个线程中安全地使用。String 经常作为参数，String 不可变性可以保证参数不可变。

**String/StringBuffer/StringBuilder区别**

* 从运行速度上说，StringBuilder>StringBuffer>String，因为String是不可变的对象

* String：是字符串常量（由final修饰），StringBuffer和StringBuilder 是字符串变量

* **StringBuffer：有同步锁**，但效率低，适用于多线程下字符缓冲区进行大量操作。 

* StringBuilder：效率高，线程不安全，适用于单线程下的字符缓冲区进行大量操作的情况；

**String Pool**

* 字符串常量池（String Pool）保存着所有字符串字面量（literal strings），这些字面量在编译时期就确定
* String 的 intern() 方法在运行过程中将字符串添加到 String Pool 中

```java
String s1 = new String("aaa");
String s2 = new String("aaa");
System.out.println(s1 == s2);           // false
String s3 = s1.intern();
String s4 = s2.intern();
System.out.println(s3 == s4);           // true
```

**String#intern** 方法：intern 方法会从字符串常量池中查询当前字符串是否存在，若不存在就会将当前字符串放入常量池中返回这个新字符串的引用，若存在（使用 equals() 方法进行确定）那么就会返回 String Pool 中字符串的引用；

在 Java 7 之前，String Pool 被放在运行时常量池中，它属于永久代。而在 Java 7，String Pool 被移到堆中。这是因为永久代的空间有限，在大量使用字符串的场景下会导致 OutOfMemoryError 错误。

----

**String 赋值**

```java
String s1 = "bbb";
String s2 = "bbb";
System.out.println(s5 == s6);  // true
```

如果是采用 "bbb" 这种字面量的形式创建字符串，会自动地将字符串放入 String Pool 中。而不是象new一样放在压缩堆中；当声明这样的一个字符串后，JVM会在常量池中先查找有没有一个值为"bbb"的对象，

* 如果有：就会把它赋给当前引用。即原来那个引用和现在这个引用指点向了同一对象,

* 如果没有：则在常量池中新创建一个"bbb",

下一次如果有String s2 = "bbb"；又会将s2指向"abcd"这个对象；即以这形式声明的字符串，只要值相等，任何多个引用都指向同一对象.



而String s = new String("abcd");和其它任何对象一样.每调用一次就产生一个对象，只要它们调用。



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



扩展：

**new String("abc")**

这种方式一共会创建两个字符串对象（**前提是 String Pool 中还没有 "abc" 字符串对象**）。

* "abc" 属于字符串字面量，因此编译时期会在 **String Pool 中**创建一个字符串对象，指向这个字符串字面量；
* 而使用 new 的方式会在**堆中**创建一个字符串对象。

------

**Sting 常用方法**

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

---

# 四、抽象和接口

**1. 抽象类**

抽象类和抽象方法都使用 abstract 关键字进行声明。如果一个类中包含抽象方法，那么这个类必须声明为抽象类。

抽象类和普通类最大的区别是，抽象类不能被实例化，需要继承抽象类才能实例化其子类。

**2. 接口**

接口是抽象类的延伸，在 Java 8 之前，它可以看成是一个完全抽象的类，也就是说它不能有任何的方法实现。

从 Java 8 开始，接口也可以拥有默认的方法实现，这是因为不支持默认方法的接口的维护成本太高了。在 Java 8 之前，如果一个接口想要添加新的方法，那么要修改所有实现了该接口的类。

接口的成员（字段 + 方法）默认都是 public 的，并且不允许定义为 private 或者 protected。

接口的字段默认都是 static 和 final 的。



## 1、抽象类和接口的区别

* 抽象类和接口都不能直接实例化；抽象方法必须由子类来进行重写
* 抽象类单继承，接口多实现
* 抽象类可有构造方法，普通成员变量，非抽象的普通方法，静态方法
* 抽象类的抽象方法访问权限可以为：public、protected 、default
* 接口中变量类型默认public staic final，接口中普通方法默认public abstract，没有具体实现
  jdk1.8 中接口可有静态方法和default（有方法体）方法



**应用场合**

* 接口：需要将一组类视为单一的类，而调用者只通过接口来与这组类发生联系。
* 抽象类：1、在既需要统一的接口，又需要实例变量或缺省的方法的情况下就可以使用它；2、定义了一组接口，但又不想强迫每个实现类都必须实现所有的接口

## 2、方法重载和重写

**多态性体现**：方法重载、方法重写、抽象类、接口

* 重写0veriding：**发生在继承类中，方法名和参数列表相同**

  * **重写有以下三个限制：**

  * 子类方法的访问权限必须大于等于父类方法；
  * 子类方法的返回类型必须是父类方法返回类型或为其子类型。
  * 子类方法抛出的异常类型必须是父类抛出异常类型或为其子类型。

* 重载Overloading：**发生在同一个类中，方法名相同，参数列表不同（个数、类型、顺序），与权限修饰、返回值类型、抛出异常无关**

---

# 五、Object 通用方法

## 1、概览

```java
public native int hashCode()
public boolean equals(Object obj)
protected native Object clone() throws CloneNotSupportedException
public String toString()
public final native Class<?> getClass()
protected void finalize() throws Throwable {}
public final native void notify()
public final native void notifyAll()
public final native void wait(long timeout) throws InterruptedException
public final void wait(long timeout, int nanos) throws InterruptedException
public final void wait() throws InterruptedException
```

## 2、equals()

* 对于基本类型，== 判断两个值是否相等，基本类型没有 equals() 方法。
* 对于引用类型，== 判断两个变量是否引用同一个对象，而 equals() 判断引用的对象是否等价。

**“==”和equals的区别**

`==`： 用来判断两个对象的内存地址是否相同（比较的是变量(栈)内存中存放的对象的(堆)内存地址，）。比较的是真正意义上的指针操作。

`equals`：用来比较的是两个对象的内容是否相等

```java
String s1 = new String("ab"); // s1 为一个引用
String s2 = new String("ab"); // s2 为另一个引用,对象的内容一样
String s3 = "ab"; // 放在常量池中
String s4 = "ab"; // 从常量池中查找
System.out.println(s1 == s2); // false
System.out.println(s3 == s4); // true
System.out.println(s1 == s3); // false
System.out.println(s1.equals(s2)); // true
System.out.println(s3.equals(s4)); // true
System.out.println(s1.equals(s3)); // true
```

对equals重新需要注意五点：

* 1   自反性：对任意引用值X，x.equals(x)的返回值一定为true；
* 2   对称性：对于任何引用值x,y,当且仅当y.equals(x)返回值为true时，x.equals(y)的返回值一定为true；
* 3   传递性：如果x.equals(y)=true, y.equals(z)=true,则x.equals(z)=true ；
* 4   一致性：如果参与比较的对象没任何改变，则对象比较的结果也不应该有任何改变；
* 5   非空性：任何非空的引用值X，x.equals(null)的返回值一定为false 。

## 3、hashCode()

hashCode() 返回散列值，而 equals() 是用来判断两个对象是否等价。等价的两个对象散列值一定相同，但是散列值相同的两个对象不一定等价。

所以：在覆盖 equals() 方法时应当总是覆盖 hashCode() 方法，保证等价的两个对象散列值也相等。



## 4、clone()

clone() 是 Object 的 protected 方法，它不是 public，一个类不显式去重写 clone()，其它类就不能直接去调用该类实例的 clone() 方法。

克隆（clone方法）为浅拷贝

**1.浅拷贝**：对基本数据类型进行值拷贝，对引用数据类型的`引用地址进行拷贝`，拷贝对象和原始对象的引用类型引用同一个对象

**2.深拷贝**： 对基本数据类型进行值拷贝，对引用数据类型的`内容进行拷贝`，拷贝对象和原始对象的引用类型引用不同对象。

**深拷贝实现**：

* `序列化`（serialization）这个对象，再反序列化回来，就可以得到这个新的对象，无非就是序列化的规则需要我们自己来写。
* `实现Clonable接口`，覆盖并重写clone()，除了调用父类中的clone方法得到新的对象， 还要将该类中的引用变量也clone出来。如果只是用**Object中默认的clone方法，是浅拷贝的**

```java
public class Test implements Cloneable {
	private int[] arr = {1,2,3,4};
	@Override
	protected Test clone() throws CloneNotSupportedException {
		Test newBody = (Test) super.clone();
		newBody.arr = arr.clone();    // 深拷贝实现
		return newBody;
	}
   
}
```



---

# 六、类加载和初始化

## 1、类加载

在类的加载阶段分：加载，验证，准备，解析，初始化，调用，卸载等七个时期

[JVM--类加载过程]()

**类加载方式：**

- **静态加载** ：编译时刻加载的类是静态加载类；通过**new关键字来实例对象**，编译时执行
- **动态加载** ：运行时刻加载的类是动态加载类。通过**反射、序列化、克隆等方式**加载，运行期执行

所以创建对象有4种方式：使用new关键字、反射、克隆（clone方法）、序列化



## 2、类初始化

### 1> 类初始化时机

- 使用new 实例化对象时
- 调用静态变量时（常量除外）、静态方法 
- 通过反射调用 
- 初始化一个类如果父类没有初始化，先触发父类的初始化 
- 执行main方法的启动类

**注意：不会触发初始化情况**

1. 子类调用父类的静态变量，子类不会被初始化，只有父类被初始化
2. 通过数组定义来引用类，不会触发类的初始化
3. 访问类的常量，不会初始化类

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
//输出
superclassA init
superclassB init
1
--------
superclassC init
subclass init
```

分析:
1、SubClass.value，输出最近一级的父类属性（子类会覆盖父类属性）所以预初始化superclassB，初始化一个类如果父类没有初始化，先触发父类的初始化，所以先初始化superclassA ；
2、new SubClass() 时，因为此时已经初始化过父类了， 即不再进行父类初始化，所以只初始化superclassC、superclass
3、如果注释superclassB 的value变量；则输出如下：

```java
superclassA init
123
--------
superclassB init
superclassC init
subclass init
```

此时： 调用的是superclassA 的属性，即先加载superclassA；
而后有new subclass（）执行初始化，此时superclassA 已经初始化过了，便不再初始化



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
//程序输出结果
hello world
```



### 2> 类初始化顺序

存在继承的情况下，初始化顺序为：

* 父类（静态变量、静态语句块）
* 子类（静态变量、静态语句块）
* 父类（实例变量、普通语句块）
* 父类（构造函数）
* 子类（实例变量、普通语句块）
* 子类（构造函数）

**注意：**

* 静态变量和静态语句块的初始化顺序取决于它们在代码中的顺序。

* 构造函数只有在new 关键字时是初始化



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
    	-->先初始化 singleTon ；这里是构造方法赋值。执行后：count1=1,count2=1；
    	--> 然后初始化count1和count2，由于count1 没有赋值动作，则不执行。
    	-->最后给count2 赋值，即：count2=0
    注意：如果singleTon 属性放在count2 后， 则结果就不一样了。而是count1=1,count2=1；
```



---

# 七、运算

## 1、参数传递

在方法参数传递过程中，其实是传递一个副本，所以：

* 基本数据类型和 String 都是修改的副本值。所以，**对参数不会发生改变**
* 引用类型是其引用地址不会修改，但副本地址也指向了原来的值，因此**引用类型属性值是会发生修改的。**

```java
public class Test {
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
    public static void stringChange(String name, int age, Person person) {
		name = "-----";
		age = 0;
		person.setName("-----");
		person.setAge(0);
	}
}
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

//运行结果如下：
Person: 张三,10
main : 张三,10
==============================
Person: -----,0
main : 张三,10
```

由上代码得出：基本数据类型和String类型，不会改变；引用类型其属性会改变



## 2、类型转换

数字类型大小顺序：short < int < float < long

Java 不能隐式执行向下转型，因为这会使得精度降低。



**隐式类型转换**：使用 += 或者 ++ 运算符可以执行隐式类型转换

```java
short s1 = 1;
// s1 = s1 + 1;    // 类型错误，需要 s1 = (short) (s1 + 1);
s1 += 1;
s1++;
```



## 3、 i++/++i和i+=1/i=i+1

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



## 4、finally提前return

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



## 5、 for循环执行顺序

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



## 6、switch 运算

**switch 条件判断语句中使用对象**

支持：char, byte, short, int, Character, Byte, Short, Integer, String, or an enum

不支持 long

支持String 从 Java 7 开始



**continue和break 对循环的影响**

首先我们需要理解一下

**continue和break 的区别**

* continue： 表示终止本次循环的执行
* break ： 表示结束当前层整个循环，嵌套循环时外层不受影响



**sweitch 中终止循环**

* 在switch 语句环境里，如果当前配置中了的case 中没有continue和break，则会执行下一个case；

* 因为continue 不能再switch中执行。除非外层有for 等循环体包裹。

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

# 八、反射

## 1、反射定义和优缺点

**定义**：可以在运行时根据指定的类名获得类的信息

Class 和 java.lang.reflect 一起对反射提供了支持，java.lang.reflect 类库主要包含了以下三个类：

* **Field** ：可以使用 get() 和 set() 方法读取和修改 Field 对象关联的字段；
* **Method** ：可以使用 invoke() 方法调用与 Method 对象关联的方法；
* **Constructor** ：可以用 Constructor 创建新的对象



**反射的优点：**

* 能够运行时动态获取类的实例，大大提高系统的灵活性和扩展性。 
* 与Java动态编译相结合，可以实现无比强大的功能 

**反射的缺点：**

* **性能开销** ：反射涉及了动态类型的解析，所以 JVM 无法对这些代码进行优化。因此，反射操作的效率要比那些非反射操作低得多。
* **安全限制** ：使用反射技术要求程序必须在一个没有安全限制的环境中运行。如果一个程序必须在有安全限制的环境中运行，如 Applet，那么这就是个问题了。
* **内部暴露** ：破坏了类的封装性，可以通过反射获取这个类的私有方法和属性 



## 2、实现方式

**3种实现方式：**

- 直接通过类名.class方式获得：Class clazz = User.class;
- 通过对象的getClass()方法获取：User user =new User();Class<?> clazz =user.getClass();
- 通过全类名获取：Class<?> clazz = Class.forName("com.bobo.User");



**Class.forName和ClassLoader.loadClass的区别**

* Class.forName除了将类的.class文件加载到jvm中之外，还会对类进行解释，**执行类中的static块。**

* ClassLoader只将.class文件加载到jvm中，不会执行static块中的内容，只有在newInstance才会去执行static块。ClassLoader.loadClass().newInstance()

* Class.forName(name,initialize,loader)通过参数控制是否加载static块。并且只有调用了newInstance()方法采用调用构造函数，创建类的对象。

---

# 九、异常

异常主要分两大类：**Exception** 和**Error** ，他们都是继承了**Throwable**类

又可以分为不受检查异常（`Unchecked Exception`）和检查异常（`Checked Exception`）

* **不可检查时异常：** Java编译器不要求一定捕获或抛出，`可以不做处理`。包括RuntimeException及其子类和Error
* **可检查异常：** Java编译器要求`必须捕获或抛出`，如：Thread.sleep()、IOException、SQLException等以及用户自定义的Exception异常



**Error**：

* 用来表示 JVM 无法处理的错误，**不便于也不需要捕获**，属于**不可检查时异常**。
* 常见的比如OutOfMemoryError之类都是Error的子类。

**Exception**： 

* 是程序本身**可以预料、可以处理的异常，应该被捕获**
  * 不可检查时异常：**运行时异常**(`RuntimeException`)：
  * 可检查时异常：如：Thread.sleep()、IOException、SQLException等以及用户自定义的Exception异常

非运行时异常指 RuntimeException 之外的异常

**运行时异常(`RuntimeException`)**

`ArrayIndexOutOfBoundsException`（数组下标越界）、`NullPointerException`（空指针异常）、`ArithmeticException`（算术异常）、`MissingResourceException`（丢失资源）、`ClassNotFoundException`（找不到类）等异常



**Java异常处理涉**

* 捕获`try{}catch{}finally`、
* 抛出`throw`、`throws`

---

# 十、泛型

未整理，待更新

 [10 道 Java 泛型面试题](https://cloud.tencent.com/developer/article/1033693)

# 十一、JSON和XML

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

 **DOM解析**

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

  

**SAX解析**

* SAX的全称是Simple APIs for XML，也即XML简单应用程序接口

* 基于事件驱动,逐条解析，可以在某个条件得到满足时停止解析，不必解析整个文档。 适用于只处理xml数据，不易编码,而且很难同时访问同一个文档中的多处不同数据

* 需要自定义DefaultHandler处理器

  

**JDOM解析**

* 简化与XML的交互并且比使用DOM实现更快,仅使用具体类而不使用接口因此简化了API,并且易于使用

* ```java
  Document document = new SAXBuilder().build(new FileInputStream(fileName));  
  //获取根节点bookstore  
  Element rootElement = document.getRootElement();  
  //获取根节点的子节点，返回子节点的数组  
  List<Element> bookList = rootElement.getChildren(); 
  ```

  

**DOM4J解析**

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



# 十二、JDK 版本特性

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

