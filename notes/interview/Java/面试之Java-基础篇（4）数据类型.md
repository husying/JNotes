

在本章中，主要介绍一下 Java 最常用、也是基础考点的数据类型；我们都知道 Java 语言提供了八种基本类型：六种数字类型（四个整数型，两个浮点型），一种字符类型，还有一种布尔型。并且还提供了其对应的引用类型。



---

# 基本类型

| 类型       | 字节数/位数 | 最小值                  | 最大值                    |
| ---------- | ----------- | ----------------------- | ------------------------- |
| **byte**   | 1/8         | -128（-2^7）            | 127（2^7-1）              |
| **short**  | 2/16        | -32768（-2^15）         | 32767（2^15 - 1）         |
| **int**    | 4/32        | -2,147,483,648（-2^31） | 2,147,483,647（2^31 - 1） |
| **long**   | 8/64        | -2^63                   | 2^63 -1                   |
| **float**  | 4/32        |                         |                           |
| **double** | 8/64        |                         |                           |

**char**：在 Java 中是用 unicode来表示字符，所以 2 个字节来表示一个字符； 一个数字或英文或汉字都是一个字符，只不过数字和英文时，存储的2个字节的第一个字节都为0，就是浪费了点空间。存汉字就占满了2个字节。

```java
public static void main(String[] args) {
    char c1 = 'a';
    char c2 = '中';

    System.out.println("char字符："+ c1 + ",字节数：" + charToByte(c1).length);;
    System.out.println("char字符："+ c2 + ",字节数：" + charToByte(c2).length);;
}

public static byte[] charToByte(char c) {
    byte[] b = new byte[2];
    b[0] = (byte)((c & 0xFF00) >> 8);
    b[1] = (byte)(c & 0xFF);
    return b;
}
```

运行结果：

```
char字符：a,字节数：2
char字符：中,字节数：2
```



**boolean**：在 Java 基本类型中只有两个状态，true、false，理论上只占一个字节，但是实际如下：

*   单个的boolean类型变量在编译的时候是使用的 int 类型，即 boolean a = true 时，这个a在 JVM 中**占用 4 个字节**，即32位；
*   boolean类型的数组时，在编译时是作为byte array来编译的。所以，boolean数组里的每一个元件占用一个字节；即 boolean[] b = new boolean[10] 的数组时，每一个boolean在 JVM中占**一个字节**；



**注意**： `float` 和 `double` 都不能表示精确的值，所以一般不能用在计算货币，要想精度不失效，可以使用 `BigDecimal`



---

# 引用类型

在 Java 中引用类型指向一个对象，指向对象的变量是引用变量。这些变量在声明时被指定为一个特定的类型，比如 Employee、Puppy 等。变量一旦声明后，类型就不能被改变了。

*   对象、数组都是引用数据类型；
*   所有引用类型的默认值都是null；
*   一个引用变量可以用来引用任何与之兼容的类型



我们的基本类型都有对应的引用类型，且基本类型与其对应的引用类型之间的赋值使用自动装箱与拆箱完成



**Integer需要几个字节 ？**，答案是每个Integer 占用了 3 * 4bytes

* Integer在内存中有一个指向方法区里边类信息的指针，这个指针占用4bytes；

* 另外Integer中实例变量只有一个int类型的字段，所以为32位，4bytes。

* 有4bytes的指向对象池的指针



---

## **自动装箱和拆箱**

自动拆箱：故名思议就是`将对象重新转化为基本数据类型`；是享元模式（flyweight）

```java
Integer num = 10;	//装箱
int num1 = num;	//拆箱
```

**基本数据类型和引用数据类型区别**

*   `基本数据类型`在被创建时，数值直接存储在栈上。
*   `引用数据类型`在被创建时，对象的具体信息都存储在堆内存上，对象的引用地址存储在栈上



---

## new Integer(123) 与 Integer.valueOf(123)区别 

注意：我们使用基本类型的引用类型新建对象时，可能出现一些意料之外的变化，如：

```java
Integer x = 10;
Integer y = new Integer(10);
System.out.println(x == y);		// false
Integer z = 10;
Integer k = Integer.valueOf(10);
System.out.println(z == k);		// true
```

为什么出现以上结果，这是因为 valueOf() 方法的实现，就是先判断值是否在缓存池中，如果在的话就直接返回缓存池的内容，而不是每次新建一个对象，所以：

*   new Integer(10) 每次都会新建一个对象；
*   Integer.valueOf(10) 会使用缓存池中的对象，多次调用会取得同一个对象的引用。



**注意：4种整型都有相同效果，有兴趣的可以分别试试 Byte、Short、Integer、Long 的效果**



---

## Integer或 Short  缓存池上下边界

Short 其实和 Integer 是相同效果，这里以 Integer 为例

```java
//在-128~127 之外的数
Integer num1 = 128;   
Integer num2 = 128;           
System.out.println("num1==num2: "+(num1==num2));     //false               
// 在-128~127 之内的数 
Integer num3 = 127;   
Integer num4 = 127;   
System.out.println("num3==num4: "+(num3==num4));     //true   
```

为什么出现以上结果，这是因为 **Integer **如果超过了从–128到127之间的值，被装箱后的Integer对象并不会被重用，即相当于每次装箱时都新建一个 Integer对象



---

## IntegerCache 源码分析

```java
private static class IntegerCache {
    static final int low = -128;
    static final int high;
    static final Integer cache[];

    static {
        // high value may be configured by property
        int h = 127;
        String integerCacheHighPropValue =
            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
        if (integerCacheHighPropValue != null) {
            try {
                int i = parseInt(integerCacheHighPropValue);
                i = Math.max(i, 127);
                // Maximum array size is Integer.MAX_VALUE
                h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
            } catch( NumberFormatException nfe) {
                // If the property cannot be parsed into an int, ignore it.
            }
        }
        high = h;

        cache = new Integer[(high - low) + 1];
        int j = low;
        for(int k = 0; k < cache.length; k++)
            cache[k] = new Integer(j++);

        // range [-128, 127] must be interned (JLS7 5.1.7)
        assert IntegerCache.high >= 127;
    }

    private IntegerCache() {}
}
```

>   通过源码，可以知道默认的Integer缓存池的大小范围是 -128~127。也是是说在这个范围里面，只要缓存池中有需要的值，会直接从缓存池中来获取，而不是重新new一个对象。
>
>   

```java
static final int low = -128;
static final int high;
```

>   在 jdk 1.8 IntegerCache 缓冲池中，可以看出，这个缓冲池的下界是 - 128，上界默认是 127，但是这个上界是可调的，在启动 jvm 的时候，通过 -XX:AutoBoxCacheMax= 来指定这个缓冲池的大小，该选项在 JVM 初始化的时候会设定一个名为 java.lang.IntegerCache.high 系统属性，然后 IntegerCache 初始化的时候就会读取该系统属性来决定上界。



---



# String类型

## String 不可变

String 类型 是一个final修饰的类型。因此它不可被继承。在 Java 8 中，String 内部使用 char 数组存储数据。

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence {
    private final char value[];
}
```

value 数组被声明为 final，这意味着 value 数组初始化之后就不能再引用其它数组。并且 String 内部没有改变 value 数组的方法，**因此可以保证 String 不可变。**



**String 不可变的好处**

*   **可以缓存 hash 值**：因为 String 的 hash 值经常被使用，例如 String 用做 HashMap 的 key。不可变的特性可以使得 hash 值也不可变，因此只需要进行一次计算。
*   **String Pool 的需要**：如果一个 String 对象已经被创建过了，那么就会从 String Pool 中取得引用。**只有 String 是不可变的，才可能使用 String Pool**。
*   **安全性**：String 不可变性天生具备线程安全，可以在多个线程中安全地使用。String 经常作为参数，String 不可变性可以保证参数不可变。



## String 赋值

```java
String s1 = "bbb";
String s2 = "bbb";
System.out.println(s5 == s6);  // true
```

如果是采用 "bbb" 这种字面量的形式创建字符串，会自动地将字符串放入 String Pool 中。而不是象new一样放在压缩堆中；当声明这样的一个字符串后，JVM会在常量池中先查找有没有一个值为"bbb"的对象，

*   如果有：就会把它赋给当前引用。即原来那个引用和现在这个引用指点向了同一对象,
*   如果没有：则在常量池中新创建一个"bbb",

下一次如果有String s2 = "bbb"；又会将s2指向"abcd"这个对象；即以这形式声明的字符串，只要值相等，任何多个引用都指向同一对象.

而`String s = new String("abcd");`和其它任何对象一样，每调用一次就产生一个对象

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

```java
new String("abc")
```

这种方式一共会创建两个字符串对象（**前提是 String Pool 中还没有 "abc" 字符串对象**）。

*   "abc" 属于字符串字面量，因此编译时期会在 **String Pool 中**创建一个字符串对象，指向这个字符串字面量；
*   而使用 new 的方式会在**堆中**创建一个字符串对象。





## String 字节/编码

如果编码和解码过程使用不同的编码方式那么就出现了乱码。

*   GBK 编码中，中文字符占 2 个字节，英文字符占 1 个字节；
*   UTF-8 编码中，中文字符占 3 个字节，英文字符占 1 个字节；
*   UTF-16 编码中，中文字符和英文字符都占 2 个字节。

```java
public static void main(String[] args) {
    try {
        String str1 = "a";
        String str2 = "你";

        System.out.println("utf-8:'a'所占的字节数:" + str1.getBytes("utf-8").length);
        System.out.println("gbk:'a'所占的字节数:" + str1.getBytes("gbk").length);

        System.out.println("utf-8:'中'所占的字节数:" + str2.getBytes("utf-8").length);
        System.out.println("gbk:'中'所占的字节数:" + str2.getBytes("gbk").length);
    } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
    }
	}
```

运行结果如下：

```java
utf-8:'a'所占的字节数:1
gbk:'a'所占的字节数:1
utf-8:'中'所占的字节数:3
gbk:'中'所占的字节数:2
```



## String、StringBuffer、 StringBuilder的区别

* 从运行速度上说，StringBuilder>StringBuffer>String，因为String是不可变的对象

* String：是字符串常量（由final修饰），StringBuffer和StringBuilder 是字符串变量

* **StringBuffer：有同步锁**，但效率低，适用于多线程下字符缓冲区进行大量操作。

* StringBuilder：效率高，线程不安全，适用于单线程下的字符缓冲区进行大量操作的情况；

  ​    

**StringBuffer 和 StringBuilder 能大量操作字符的原理**

在append是后，采用了`Arrays.copyOf（）` 进行了数组复制

```java
@Override
public synchronized StringBuffer append(Object obj) {
    toStringCache = null;
    super.append(String.valueOf(obj));
    return this;
}

// AbstractStringBuilder 类
public AbstractStringBuilder append(String str) {
    if (str == null)
        return appendNull();
    int len = str.length();
    ensureCapacityInternal(count + len); // 采用复制方式增加数组长度
    str.getChars(0, len, value, count);
    count += len;
    return this;
}
private void ensureCapacityInternal(int minimumCapacity) {
    if (minimumCapacity - value.length > 0) {
        value = Arrays.copyOf(value,
                              newCapacity(minimumCapacity));
    }
}
```



---



## String Pool

*   字符串常量池（String Pool）保存着所有字符串字面量（literal strings），这些字面量在编译时期就确定
*   String 的 intern() 方法在运行过程中将字符串添加到 String Pool 中

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



---



## String 常用方法

```java
public boolean endsWith(String suffix) //测试此字符串是否以指定的后缀结束
public boolean startsWith(String prefix)
public char charAt(int index);//返回指定索引处的 char 值
public int indexOf(String str) 
public int lastIndexOf(int ch)
public String[] split(String regex)
public String substring(int beginIndex)   
public String replace(char oldChar,char newChar)
public int length()
```



# Object

在 Java 中 Object 是所有的祖类。

## 常用方法

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

## equals()

*   对于基本类型，== 判断两个值是否相等，基本类型没有 equals() 方法。
*   对于引用类型，== 判断两个变量是否引用同一个对象，而 equals() 判断引用的对象是否等价。

**“==”和equals的区别**

`==`： 用来判断两个对象的内存地址是否相同（比较的是变量(栈)内存中存放的对象的(堆)内存地址，）。比较的是真正意义上的指针操作。

`equals`：用来比较的是两个对象的内容是否相等

```
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

*   1 自反性：对任意引用值X，x.equals(x)的返回值一定为true；
*   2 对称性：对于任何引用值x,y,当且仅当y.equals(x)返回值为true时，x.equals(y)的返回值一定为true；
*   3 传递性：如果x.equals(y)=true, y.equals(z)=true,则x.equals(z)=true ；
*   4 一致性：如果参与比较的对象没任何改变，则对象比较的结果也不应该有任何改变；
*   5 非空性：任何非空的引用值X，x.equals(null)的返回值一定为false 。

## hashCode()

hashCode() 返回散列值，而 equals() 是用来判断两个对象是否等价。等价的两个对象散列值一定相同，但是散列值相同的两个对象不一定等价。

所以：在覆盖 equals() 方法时应当总是覆盖 hashCode() 方法，保证等价的两个对象散列值也相等。

**为什么要有 hashCode？**因为 `hashCode()` 的作用就是**获取哈希码**，确定该对象在哈希表中的索引位置



**hashCode（）与equals（）**

1.  如果两个对象相等，则hashcode一定也是相同的
2.  两个对象相等,对两个对象分别调用equals方法都返回true
3.  两个对象有相同的hashcode值，它们也不一定是相等的
4.  **因此，equals 方法被覆盖过，则 hashCode 方法也必须被覆盖**
5.  hashCode() 的默认行为是对堆上的对象产生独特值。如果没有重写 hashCode()，则该 class 的两个对象无论如何都不会相等（即使这两个对象指向相同的数据）

## clone()

clone() 是 Object 的 protected 方法，它不是 public，一个类不显式去重写 clone()，其它类就不能直接去调用该类实例的 clone() 方法。

克隆（clone方法）为浅拷贝

**1.浅拷贝**：对基本数据类型进行值拷贝，对引用数据类型的`引用地址进行拷贝`，拷贝对象和原始对象的引用类型引用同一个对象

**2.深拷贝**： 对基本数据类型进行值拷贝，对引用数据类型的`内容进行拷贝`，拷贝对象和原始对象的引用类型引用不同对象。

**深拷贝实现**：

*   `序列化`（serialization）这个对象，再反序列化回来，就可以得到这个新的对象，无非就是序列化的规则需要我们自己来写。
*   `实现Clonable接口`，覆盖并重写clone()，除了调用父类中的clone方法得到新的对象， 还要将该类中的引用变量也clone出来。如果只是用**Object中默认的clone方法，是浅拷贝的**

```
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

开发中常用的对象拷贝工具：

例如DozerMapper、Apache BeanUtils、Spring、Jodd BeanUtils、甚至是Cglib 都提供了这样的功能

选择Cglib的 **BeanCopier** 进行Bean拷贝的理由是，其性能要比 **Spring的BeanUtils **，**Apache的BeanUtils **和 **PropertyUtils** 要好很多，尤其是数据量比较大的情况下

Cglib 的beans 包 操作

*   BeanCopier：用于两个bean之间，同名属性间的拷贝。
*   BulkBean：用于两个bean之间，自定义get&set方法间的拷贝。
*   BeanMap：针对POJO Bean与Map对象间的拷贝。
*   BeanGenerator：根据Map<String,Class>properties的属性定义，动态生成POJO Bean类。