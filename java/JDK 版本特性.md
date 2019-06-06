# 一、JDK 版本特性

## 1、JDK 7 新特性

*   二进制字面量
*   在数字字面量使用下划线
*   switch可以使用string了
*   实例创建的类型推断
*   使用Varargs方法使用不可维护的形式参数时改进了编译器警告和错误
*   try-with-resources 资源的自动管理
*   捕捉多个异常类型和对重新抛出异常的高级类型检查

## 2、JDK 8 新特性

Java 8 有十大新特性：

*   **Lambda 表达式**：允许把函数作为一个方法的参数
*   **方法引用**：可以直接引用已有Java类或对象（实例）的方法或构造器。与lambda联合使用，方法引用可以使语言的构造更紧凑简洁，减少冗余代码。
*   **默认方法**：在接口里面有了一个实现的方法
*   **新编译工具**：新的编译工具，如：Nashorn引擎 jjs、 类依赖分析器jdeps。
*   **Stream API**：新添加的Stream API（java.util.stream） 把真正的函数式编程风格引入到Java中
*   **Date Time API** ：加强对日期与时间的处理
*   **Optional 类** ：解决空指针异常。
*   **Nashorn, JavaScript 引擎**：允许我们在JVM上运行特定的javascript应用。

 JDK 8 的应用，可以使用 Instant 代替 Date ， LocalDateTime 代替 Calendar ，
DateTimeFormatter 代替 SimpleDateFormat



# 二、Java 8 新特性实战

## 1、函数式接口

### 1> 定义

*   函数式接口就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口

*   函数式接口可以被隐式转换为 lambda 表达式

*   使用 **@FunctionalInterface** 申明

```java
@FunctionalInterface
interface IMath {
	int operation(int a, int b);
}

class Add implements IMath {
	@Override
	public int operation(int a, int b) {
		return a + b;
	}
}

public class Test {
	public static void main(String[] args) {
		IMath m1 = new Add();
		int sum = m1.operation(1, 2);
		System.out.println(sum);

		IMath m2 = (a, b) -> a + b; //隐式转换为 lambda 表达式
		m2.operation(1, 2);
		System.out.println(sum);

	}
}

```

有上面代码可以看出，函数式接口就是一 Lambda  进行接口实现

将 Add 类的`operation`实现，转化成了`(a, b) -> a + b`



当在 IMath 接口中在定义一个 appden 的方法，如下：

```java
@FunctionalInterface
interface IMath {
	int operation(int a, int b);
	String appden(String key);
}

```

此时，无法用 `IMath m2 = (a, b) -> a + b;`来表示

因此：函数式接口就是 **有且只有一个抽象方法**



### 2> 常用接口

```java
Consumer< T >		接收T对象，不返回值
Predicate< T >		接收T对象，返回boolean
Function< T, R >	接收T对象，返回R对象
Supplier< T >		提供T对象（例如工厂），不接收值name
```

常用：

```java
Predicate<T>#test(T t)   //接受一个输入参数，返回true / false
Supplier<T>#get()		 //返回一个结果
Consumer<T>#accept(T t)  //接受一个输入参数并且无返回的操作   
Function<T,R>#apply(T t) //将此函数应用于给定的参数  T 表示输入参数，R 表示返回参数

```



#### Predicate

感觉这函数不怎么常用啊，听说主要用于断言

```java
//返回一个组合的谓词，表示该谓词与另一个谓词的短路逻辑AND。
default Predicate<T>	and(Predicate<? super T> other)
//返回根据 Objects.equals(Object, Object)测试两个参数是否相等的 谓词 。
static <T> Predicate<T>	isEqual(Object targetRef)
//返回表示此谓词的逻辑否定的谓词。
default Predicate<T>	negate()
//返回一个组合的谓词，表示该谓词与另一个谓词的短路逻辑或。
default Predicate<T>	or(Predicate<? super T> other)
//在给定的参数上评估这个谓词。
boolean	test(T t)

```

**test**

```java
 
public static void eval(List<Integer> list, Predicate<Integer> predicate) {
    for(Integer i: list) {
        if(predicate.test(i)) {
            System.out.println(i + " ");
        }
    }
}
public static void main(String args[]){
    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9);
    System.out.println("输出大于 3 的所有数字:");
    eval(list, n-> n > 3 );
}


```



#### Supplier

```java
T  get() //获得结果。
```

这个接口，只是为我们提供了一个创建好的对象，这也符号接口的语义的定义

```java
Supplier<String> supplier = String::new;
```



#### Consumer

```java
void	accept(T t)	//对给定的参数执行此操作。
default Consumer<T>	andThen(Consumer<? super T> after) //返回一个组合的 Consumer ，按顺序执行该操作，然后执行 after操作
```

实践如下：

```java
public static void printInfo(String[] strArr, Consumer<String> con1, Consumer<String> con2){
    for (String str : strArr) {
        con1.accept(str);
        con2.accept(str);
        //上两行代码等同下一行， 这就是 andThen 方法的作用
        //con1.andThen(con2).accept(strArr[i]);
    }
}

public static void main(String[] args) {
    String[] strArr = {"热巴,女","郑爽,女","杨紫,女"};
    printInfo(strArr
        ,(message)->{System.out.print("姓名:" + message.split(",")[0] +",");}
        ,(message)->{System.out.println("性别:" + message.split(",")[1]);}
   );
}

```



------

#### Function

Consumer 是对传入的参数做一个 void 操作，

Function 则是对传入的参数做相应的处理，返回一个定义的类型。

```java
R apply(T t)	//将此函数应用于给定的参数。
static <T> Function<T,T> identity() 	//返回一个总是返回其输入参数的函数。
<V> Function<V,R> compose(Function<? super V,? extends T> before)
//返回一个组合函数，先执行before操作，然后执行该操作。
<V> Function<T,V> andThen(Function<? super R,? extends V> after)
//返回一个组合函数，按顺序执行该操作，然后执行 after操作


```

**apply**

Function 执行的入口是 apple 接口

**compose 比较 andThen**

```java
public static void main(String[] args) {
    System.out.println(Test.option1(5,i -> i * 2,i -> i * i));
    System.out.println(Test.option2(5,i -> i * 2,i -> i * i));
}

public static int option1(int i, Function<Integer,Integer> before,Function<Integer,Integer> after){
    return before.compose(after).apply(i);
}

public static int option2(int i, Function<Integer,Integer> before,Function<Integer,Integer> after){
    return before.andThen(after).apply(i);
}
//输出
50
100

```

由上可以看出

A.compose(B)   //  是先执行 B 再执行 A

A.andThen(B)   //  是先执行 A 再执行 B



## 2、Lambda表达式

语法

```java
(parameters) -> expression
或
(parameters) ->{ statements; }
```

lambda表达式的重要特征:

*   **可选类型声明：**不需要声明参数类型，编译器可以统一识别参数值。
*   **可选的参数圆括号：**一个参数无需定义圆括号，但多个参数需要定义圆括号。
*   **可选的大括号：**如果主体包含了一个语句，就不需要使用大括号。
*   **可选的返回关键字：**如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值。

举例说明：

```java
// 1. 不需要参数,返回值为 5  
() -> 5  
  
// 2. 接收一个参数(数字类型),返回其2倍的值  
x -> 2 * x  
  
// 3. 接受2个参数(数字),并返回他们的差值  
(x, y) -> x – y  
  
// 4. 接收2个int型整数,返回他们的和  
(int x, int y) -> x + y  
  
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)  
(String s) -> System.out.print(s)
```



实战使用

```java
 List<String> lst = Arrays.asList("bb", "aa", "dd", "cc", "ee");
// Lambda前
for (String a : lst) {
    System.out.println(a);
}   
// Lambda后
lst.forEach(a -> System.out.println(a));

Collections.sort(lst, 
     (o1, o2) -> { return o1.compareTo(o2);}
);
```





## 3、方法引用

方法引用使用一对冒号 **`::`**

*   **构造器引用：**它的语法是`Class::new`，或者更一般的Class< T >::new实例如下：

```java
final Car car = Car.create( Car::new ); 
```

*   **静态方法引用：**它的语法是`Class::static_method`，实例如下：

```java
cars.forEach( Car::collide );
```

*   **特定类的任意对象的方法引用：**它的语法是Class::method实例如下：

```java
cars.forEach( Car::repair );
```

*   **特定对象的方法引用：**它的语法是`instance::method`实例如下：

```java
final Car police = Car.create( Car::new ); 
cars.forEach( police::follow );
```

原型如下：

```java
@FunctionalInterface
public interface Supplier<T> {
    T get();
}
 
class Car {
    //Supplier是jdk1.8的接口，这里和lamda一起使用了
    public static Car create(final Supplier<Car> supplier) {
        return supplier.get();
    }
 
    public static void collide(final Car car) {
        System.out.println("Collided " + car.toString());
    }
 
    public void follow(final Car another) {
        System.out.println("Following the " + another.toString());
    }
 
    public void repair() {
        System.out.println("Repaired " + this.toString());
    }
}
```



## 4、Optional

Optional 类的引入很好的解决空指针异常。

### 1> 常用方法

```java
//创建Optional对象，
Optional.of(T value);  // 创建一个指定非null值的Optional 
Optional.ofNullable(T value);  // 创建一个指定值的Optional，value可以是null  
Optional.empty() //创建空的 Optional 对象：
```

值是否存在，不同处理：

```java
boolean  isPresent() //判断值是否存在
T  get()  // 有值，返回值，否则抛出异常 。
void ifPresent(Consumer consumer) //值存在，调用consumer对象，否则不调用
T orElse(T other)  //值存在，返回值， 否则返回 other。
T orElseGet(Supplier supplier)  //值存在，返回值， 否则返回 other。并返回 other 调用的结果
T orElseThrow()//值存在，返回值，则抛出异常， 
filter(Predicate) //判断Optional对象中保存的值是否满足函数Predicate 运算 ，并返回新的Optional
map(Function<? super T,? extends U> mapper)  //如果有值，进行函数运算，并返回新的Optional(可以是任何类型)，否则返回空Optional
flatMap(Function<? super T,Optional<U>> mapper)//功能与map()相似,如果值存在，返回基于Optional包含的映射方法的值，否则返回一个空的Optional
```

flatMap 方法与 map 方法类似，区别：

在于mapping 函数的返回值不同：flatMap方法的mapping函数返回值必须是Optional， map 可以是任何类型T



#### ifPresent

*   如果 Optional 实例有值则为其调用 consumer，否则不做处理；

*   参数 Consumer <? super T ) > consumer)：接收T对象，不返回值 

```java
//ifPresent 方法接受 lambda表达式作为参数。
//lambda表达式对Optional的值调用consumer进行处理。
name.ifPresent((value) -> {
  System.out.println("The is: " + value.length());
});
```

可以用于对集合中的对象进行判断处理。如：

```java
List<String> numList = Arrays.asList(new String[]{"1","2",null,"2"});
Optional<List<String>> optionalList = Optional.ofNullable(numList);
optionalList.ifPresent(list -> {   // 校验list集合是否为空
    list.stream().forEach(str -> {
        Optional.ofNullable(str).ifPresent(a -> {   // 校验list 元素是否为空
            System.out.println(a);
        });
    });
});
```

#### orElse/orElseGet/orElseThrow

**orElse**：如果有值则将其返回，否则返回指定的其它值。

```java
Optional<String> optional = Optional.ofNullable(null);
String a = optional.orElse("无值");
System.out.println(a);  // 输出无值
```

**orElseGet**：可以对值进行一个处理，再返回

*   orElseGet与orElse方法类似，区别在于得到的默认值。orElse方法将传入的字符串作为默认值，orElseGet 方法可以接受Supplier接口的实现用来生成默认值

*   Supplier<T>：无参数，返回一个结果。

```java
Optional<String> optional = Optional.ofNullable(null);
String a = optional.orElseGet(() -> "Default Value"); // 可以对值进行一个处理，再返回
System.out.println(a);
```

**orElseThrow**：如果有值则将其返回，否则抛出supplier接口创建的异常

```java
Optional<String> optional = Optional.ofNullable(null);
String a = null;
try {
    a = optional.orElseThrow(Exception::new);  // ::new   这是构造方法的引用
} catch (Exception e) {
    e.printStackTrace();
}
System.out.println(a);
```



#### map/flatMap

**map**：如果有值，为其执行mapping函数返回 Optional  类型返回值，否则返回空Optional

*   Function<? super T,? extends U>  

```java
Optional<String> optional1 = Optional.ofNullable(null);
System.out.println(optional1.map(a-> a+"1"));  // 输出: Optional.empty

Optional<String> optional2 = Optional.ofNullable("a");
System.out.println(optional2.map(a-> a+"1"));  //  输出: Optional[a1]

System.out.println(optional2.map(a-> Optional.of(a+"1")));  // 输出: Optional.empty
```

**flatMap**：

*   如果值存在，返回基于Optional包含的映射方法的值，否则返回一个空的Optional

*   区别在于mapping函数的返回值不同。map方法的mapping函数返回值可以是任何类型T，**而flatMap方法的mapping函数必须是Optional。**

```java
Optional<String> opt1 = Optional.ofNullable(null);
System.out.println(opt1.map(a-> Optional.ofNullable(a)));// 输出:ptional.empty

Optional<String> opt2 = Optional.ofNullable("a");
System.out.println(opt2.flatMap(a-> Optional.ofNullable(a+"1")));//输出:Optional[a1]
```



**map/flatMap 区别：**

```java
Optional<String> optional2 = Optional.ofNullable("a");
System.out.println(optional2.map(a-> Optional.of(a+"1")));  
// 输出: Optional[Optional[11]]

Optional<String> optional3 = Optional.ofNullable("a");
System.out.println(optional3.flatMap(a-> Optional.of(a+"1")));  
//  输出: Optional[a1]
```



#### filter

*   如果有值并且满足断言条件返回包含该值的Optional，否则返回空Optional。

*   filter个方法通过传入限定条件对Optional实例的值进行过滤。
*   **Predicate<? super <T> predicate)**  表示一个参数的谓词（布尔值函数）

```java
Optional<String> optional1 = Optional.ofNullable(null);
System.out.println(optional1.filter(a-> a == null));  // 输出: Optional.empty

Optional<String> optional2 = Optional.ofNullable("a");
System.out.println(optional2.filter(a-> a == null));  // 输出: Optional.empty

Optional<String> optional3 = Optional.ofNullable("a");
System.out.println(optional3.filter(a-> a != null));  //  输出: Optional[a]
```



### 2> 实战使用

#### if 判断

```java
//使用前
public static String getName(User u) {
    if (u == null) return "Unknown";
    return u.name;
}
//使用后
public static String getName(User u) {
    return Optional.ofNullable(u).map(user->user.name).orElse("Unknown");
}
```

#### if 逐级判断

```java
//使用前
public static String getChampionName(Competition comp) throws IllegalArgumentException {
    if (comp != null) {
        CompResult result = comp.getResult();
        if (result != null) {
            User champion = result.getChampion();
            if (champion != null) {
                return champion.getName();
            }
        }
    }
    throw new IllegalArgumentException("The value of param comp isn't available.");
}

//使用后
public static String getChampionName(Competition comp) throws IllegalArgumentException {
    return Optional.ofNullable(comp)
            .map(c->c.getResult())
            .map(r->r.getChampion())
            .map(u->u.getName())
            .orElseThrow(()->new IllegalArgumentException("The value of param comp isn't available."));
}

```

#### if/else 判断

```java
//以前写法
public void userDoSomething(int userId) {
	final User manager = getManager();
	User user = userDao.findById(1);
    if(user!=null){
        // 如果找到了这个人， 就交给其处理事情
 		dosomething(user);
    }else{// 如果找不到这个人, 事情交给经理去做
        dosomething(manager);
    }
    
    // 如果 user2 不为 null， 就有 user2 执行，否则不做
    User user2 = userDao.findById(2);
}


//JAVA8写法
public void userDoSomething(int userId) {
	final User manager = getManager();
	Optional<User> userOptioanl = userDao.findById(1);
	// 找到了人，由user去做；找不到人,事情交给manager去做
	doSomething(userOptiona.orElse(manager)).;
    
    // // 如果 user2 不为 null， 就有 user2 执行，否则不做
    Optional<User> userOptioan2 = userDao.findById(2);
    userOptioan2.ifPresent(user -> { doSomething(user); });//使用lambda
}


```

#### 空值处理

```java
// 第一种用法, 普通非空检查判断
public Optional<String> getUserNameById(int id) {
	Optional<User> userOptioanl = userDao.findById(1);
	if (userOptional.isPersent()) {
		final User user = userOptional.get();
		return Optional.ofNullable(user.getName());
	}
	return Optional.empty();
}

// 第二种, 如果为空,抛出异常
public Optional<String> getUserNameById(int id) throws UserNotFoundException {
	Optional<User> userOptioanl = userDao.findById(1);
	final String name = userOptional.orElseThrow(UserNotFoundException::new).getName();
	return Optioanl.ofNullable(name);
}

// 第三种, 当对象为空时,给一个默认值
public void userDoSomething(int userId) {
	final User manager = getManager();
	Optional<User> userOptioanl = userDao.findById(1);
	// 如果找不到这个人, 事情交给经理去做
	userOptional.orElse(manager).doSomething();
    userOptioanl.ifPresent(user -> { user.doSomething(); });//使用lambda
}

```



## 5、Stream 

*   **作用**：提供一种对 Java 集合运算和表达的高阶抽象。
*   **数据源** 流的来源。 可以是集合，数组，I/O channel， 产生器generator 等。
*   **聚合操作** 类似SQL语句一样的操作， 比如filter, map, reduce, find, match, sorted等。

特征：

*   **Pipelining**: 中间操作都会返回流对象本身
*   **内部迭代**：



**常用方法**

```java
stream() //为集合创建  串行流。
parallelStream() //为集合创建  并行流。
forEach() //迭代
map()  //获取每个元素到对应的结果
filter() //用于过滤出元素
limit  //imit 方法用于获取指定数量的流
sorted() // 排序，自然序

```

 

### 1> parallelStream

```java
//100条数据 循环打印测试
List<Integer> list = new ArrayList();
for (int j = 0; j < 100; j++) {
    list.add(j);
}
// 统计并行执行list的线程
Set<Thread> threadSet = new HashSet<>();
// 并行执行
list.parallelStream().forEach(integer -> {
    Thread thread = Thread.currentThread();
    // 统计并行执行list的线程
    threadSet.add(thread);
});
System.out.println("threadSet一共有" + threadSet.size() + "个线程");
System.out.println(list.toString());

```

### 2> map 和 forEach

```java
<R> Stream<R> map(Function<? super T, ? extends R> mapper);
void forEach(Consumer<? super T> action);

```

map 将 每个Entity 替换成了函数结果，成了一个新的 Stream 对象

如下：

```java
List<Person> list = new ArrayList<>();
list.add(new Person("AAA"));
list.add(new Person("BBB"));

list.stream().forEach(p -> System.out.println(p));
list.stream().map(s -> s.getName()).forEach(p -> System.out.println(p));

//输出
com.hsy.demo.Person@87aac27
com.hsy.demo.Person@3e3abc88
AAA
BBB

```

### 3> filter

filter 方法用于通过设置的条件过滤出元素。

```java
Stream<T> filter(Predicate<? super T> predicate);

```

如下:

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 输出 字符 a 为前缀的 字符串
strings.stream().filter(string -> string.startsWith("a"))
	.forEach(System.out::println));

//输出
abc
abcd

```

### 4> sort

```java
Stream<T> sorted();
Stream<T> sorted(Comparator<? super T> comparator);

```









------

# 资料参考

*   [Java 8 新特性 | 菜鸟教程](https://www.runoob.com/java/java8-new-features.html)

*   [Java 8 Optional 类深度解析](https://www.cnblogs.com/binarylei/articles/8490188.html)