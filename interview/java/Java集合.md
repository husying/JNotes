# 集合

[TOC]



# 一、集合框架

## 1、集合关系

Java集合类存放于 java.util 包中，是一个用来存放对象的容器。

* Collection：List 、Set、Queue
  * List：ArrayList、LinkedList、Vector（Stack）
  * Set：HashSet、TreeSet
  * Queue：Deque
* Map：HashMap、TreeMap、LinkedHashMap



```java
----Collection ------
public boolean add(E e)    //插入列表尾部
public boolean addAll(Collection<? extends E> c) 
void clear() 
boolean remove(Object o)
boolean removeAll(Collection<?> c)
boolean retainAll(Collection<?> c)//删除  除了参数以外的元素；和removeAll 相反      
boolean contains(Object o)
boolean containsAll(Collection<?> c)
boolean equals(Object o)  // c1.equals(c2) 暗示着 c1.hashCode()==c2.hashCode()。 ;需要重写
boolean isEmpty()
Iterator<E> iterator()  
int size()   
Object[] toArray()
 
    
----Map ------     
V put(K key,V value)
void putAll(Map<? extends K,? extends V> m) 
V get(Object key)
Set<K> keySet() // 返回值是Map中key值的集合
Collection<V> values()
Set<Map.Entry<K,V>> entrySet()  //返回Map.Entry映射项（键-值对），也是返回一个Set集合    
boolean containsKey(Object key)
boolean containsValue(Object value)
boolean isEmpty()
V remove(Object key)
void clear()
int size()  
```



---

## 2、迭代器（Iterator）

**在使用Iterator的时候禁止对所遍历的容器进行改变其大小结构的操作**。

例如: 在使用Iterator进行迭代时，如果对集合进行了add、remove操作就会出现ConcurrentModificationException异常。



**快速失败机制（fail-fast）**

* 当多个线程对Collection进行操作时，若其中某一个线程通过Iterator遍历集合时，该集合的内容被其他线程所改变，则会抛出ConcurrentModificationException异常。

**迭代器遍历抛异常原因**

- 是迭代器在遍历时直接访问集合中的内容，并且在遍历过程中使用一个 modCount 变量。集合在被遍历期间如果内容发生变化，就会改变 modCount 的值。
- 每当迭代器使用 hashNext()/next() 遍历下一个元素之前，都会检测 modCount 变量是否为 expectedModCount 值，是的话就返回遍历；否则抛出异常，终止遍历。



**快速失败（fail-fast）和安全失败（fail-safe）**

- HashMap、ArrayList 这些集合类，这些在 java.util 包的集合类就都是快速失败的；而 java.util.concurrent 包下的类都是安全失败，比如：ConcurrentHashMap。
- 快速失败在遍历时直接访问集合中的内容
- 安全失败在遍历时不是直接在集合内容上访问的，而是先复制原有集合内容，在拷贝的集合上进行遍历。



**fast-fail解决办法**

- 通过util.concurrent集合包下的相应类（CopyOnWriteArrayList是自己实现Iterator）去处理，则不会产生fast-fail事件。
- CopyOnWriteArrayList类是复制了数组，不是直接操作原数组

 **for循环与迭代器的对比**

* ArrayList对随机访问比较快，而for循环中使用的get()方法，采用的即是随机访问的方法，因此在ArrayList里for循环快。

* LinkedList则是顺序访问比较快，Iterator中的next()方法采用的是顺序访问方法，因此在LinkedList里使用Iterator较快。



```java
//使用方式
Iterator it = list.iterator();
while(it.hasNext()){
　Object obj= it.next();
}
```



**Iterator 接口包含 4 个方法** 

```java
E next ( ) ;
boolean hasNext ();
void remove () ;
default void forEachRemaining ( Consumer < ? super E > action ) ;
```



## 3、多线程下的集合安全

由于集合大多数是线程不安全的，可采用如下方式处理

* 使用加锁机制：synchronized、Lock

* 使用volalite修饰
* 使用ThreadLocal对象
* 使用java.util.concurrent 提供的并发集合对象，其提供了映射 、 有序集和队列的高效实现  **ConcurrentHashMap** 、**CopyOnWriteArrayList**、CopyOnWriteArraySet、ConcurrentSkipListMap（SkipList：跳表）、 ConcurrentSkipListSet 和 ConcurrentLinkedQueue



注释 ： 有些应用使用庞大的并发散列映射 ， 这些映射太过庞大 ， 以至于无法用 size 方法得到它的大小，因为这个方法只能返回 int。 对于一个包含超过20 亿条目的映射该如何处理 ？ **JavaSE 8 引入了一个 mappingCount 方法可以把大小作为 long 返回。**



---

# 二、List

## 1、List 特点

List 是Collection子接口，常见实现类包含：ArrayList、LinkedList、Vector；

特点：**排列有序，可重复，允许多个NULL，iterator 遍历**

- 效率上：
  - ArrayList ：ArrayList底层使用数组存储；查询有索引的存在，读取速度快，增删慢；

  - LinkedList：使用双向循环链表数据结构存储，查询速度慢，增删快；

  - Vector：读取速度快，增删慢，**线程安全**，效率低；底层使用数组存储

    - Stack继承于Vector、“先进后出”，元素在数组末尾进行插或删除操作，

**ArrayList 和 Vector的区别**

- 安全上：Vector使用了synchronized，线程安全。ArrayList(getter()和setter()方法快)和LinkedList 不安全（新增删除的操作没有加锁）
- 扩容上：ArrayList和Vector都采用数组存储，扩容时ArrayList增加一半，而Vector可以自定义增长因子（capacityIncrement：是不是小数，是具体增长大小），默认会增加1倍；
- 性能上：ArrayList的数组采用`transient`修饰，防止序列化，并重写了了readObject和writeObject方法，提高效率



**添加或删除数据为什么LinkedList 比ArrayList 效率高**

* 在添加或删除数据的时候，
  * ArrayList经常需要复制数据到新的数组，
  * LinkedList只需改变节点之间的引用关系



**foreach与正常for循环效率对比**

* foreach使用的是迭代器循环，for是使用索引下标检索

- 需要**循环数组结构**的数据时，建议**使用普通for循环**，因为for循环采用下标访问，对于数组结构的数据来说，采用下标访问比较好。
- 需要**循环链表结构**的数据时，**一定不要使用普通for循环**，这种做法很糟糕，数据量大的时候有可能会导致系统崩溃。

------

## 2、扩容机制

**ArrayList扩容** ：1.5倍

```java
 private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
```

* **默认初始容量10**，容量扩大为原来的**1.5倍**，
* 再判读，如果容量任然小于数组大小、**就直接为数组最小容量**，
* 再判读此时minCapacity大于MAX_ARRAY_SIZE，则返回Integer的最大值。否则返回MAX_ARRAY_SIZE（MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8）



**Vectot 扩容：** 2倍

```java
private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + ((capacityIncrement > 0) ?
                                         capacityIncrement : oldCapacity);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
```

* 默认**初始容量10**；如果扩展因子没有赋值等于0；则**容器大小为2倍**；
* 然后和ArrayList一样比较最大容量

---

## 3、**集合排序**

集合排序的两种方式都是使用Collections.sort(集合)；

- 排序对象实现Comparable接口，并重写抽象方法compareTo
- 编写匿名类：Collections.sort（List list，Comparator c），自定义排序



---

## 4、List 和Array转换

list.toArray()   ||   Arrays.asList(array)

```java
List<String> list = new ArrayList<String>();
Object[] array=list.toArray();
----------------------------------------------------------
List<String> list = Arrays.asList(array);//但该方法存在一定的弊端，返回的list是Arrays里面的一个静态内部类，该类并未实现add,remove方法，因此在使用时存在局限性
//解决方案：运用ArrayList的构造方法
List<String> list = new ArrayList<String>(Arrays.asList(array));

List<String> list = new ArrayList<String>(array.length);
Collections.addAll(list, array);
```



注意：

List<String> list = Arrays.asList(array); 

这种方式得到的list，如果进行修改，直接影响array的值

---

## 5、ArrayList 去重的几种方式

- 双重for循环去重
- set集合判断去重,不打乱顺序
- 遍历后以contains判断赋给另一个list集合
- set和list转换去重 

```java
//set集合判断去重,不打乱顺序
List<String> listNew=new ArrayList<>();
Set set=new HashSet();
for (String str:list) {
    if(set.add(str)){
        listNew.add(str);
    }
}
//遍历后以contains判断赋给另一个list集合
List<String> listNew=new ArrayList<>();
for (String str:list) {
    if(!listNew.contains(str)){
        listNew.add(str);
    }
}
//set和list转换去重 
List<String> listNew=new ArrayList<>(new HashSet(list)); // TreeSet 也可以
//双重for循环去重
for (int i = 0; i < list.size() - 1; i++) {
    for (int j = list.size() - 1; j > i; j--) {
        if (list.get(j).equals(list.get(i))) {
            list.remove(j);
        }
    }
}
```

---

## 6、常用方法

**1> List** 常用方法

```java
public void add(int index, E element) //指定位置插入
public boolean addAll(int index, Collection<? extends E> c) 
E set(int index, E element)
E get(int index)
E remove(int index) 
void clear()    
int indexOf(Object o)   //返回索引
int lastIndexOf(Object o)  //返回元素最后位置的索引，不存在返回 -1
List<E> subList(int fromIndex, int toIndex)   //截取列表包括前，不包括后
ListIterator<E> listIterator(int index)//index指定位置开始迭代，可以不写  ListIterator可以定位当前的索引位置，nextIndex()和previousIndex()可以实现 
```

---

**2> Arrays常用方法**

**是数组对象操作类：** 排序和搜索

```java
//数组类型支持byte 、char 、int 、long 、float 、double ；下列参数类型只举例一种

public static <T> List<T> asList(T... a) //转List列表
public static int binarySearch(byte[] a, byte key)    
public static void sort(byte[] a)  
public static String toString(double[] a) // 将数组内容转换成字符串
public static char[] copyOfRange(char[] original, int from, int to)//复制到一个新数组,from 包括；to不包括(可以位于数组范围之外)
public static int[] copyOf(int[] original, int newLength)   
public static void fill(int[] a, int val)//填充覆盖数组每个元素
public static void fill(int[] a, int fromIndex, int toIndex, int val)// 填充覆盖数组fromIndex（包括）一直到索引 toIndex（不包括）的元素。（如果 fromIndex==toIndex，则填充范围为空。）
```

---

**3> ArrayList常用方法**

**以下方法除父接口之外，独有**

`List` 接口的实现，以数组存储列表

`size`、`isEmpty`、`get`、`set`、`iterator` 和 `listIterator` 操作都以固定时间运行
`add` 操作以*分摊的固定时间* 运行，也就是说，添加 n 个元素需要 O(n) 时间

```java
public ArrayList()//初始容量为 10 
public ArrayList(int initialCapacity)//指定初始容量
public ArrayList(Collection<? extends E> c)
    
protected void removeRange(int fromIndex, int toIndex)
```

---

**4> LinkedList**

LinkedList 是一个继承于AbstractSequentialList的双向链表。它也可以被当作堆栈、队列或双端队列进行操作。

LinkedList 实现 List 接口，能对它进行队列操作。
LinkedList 实现 Deque 接口，即能将LinkedList当作双端队列使用。

[详情参考](https://www.cnblogs.com/skywang12345/p/3308807.html)

```java
----------------------------------------------------------------------
			第一个元素（头部）				最后一个元素（尾部）
		抛出异常		特殊值			 抛出异常		特殊值
插入	addFirst(e)		offerFirst(e)	addLast(e)		offerLast(e)
移除	removeFirst()	pollFirst()		removeLast()	pollLast()
检查	getFirst()		peekFirst()		getLast()		peekLast()
----------------------------------------------------------------------
Queue 方法	等效 Deque 方法
add(e)		addLast(e)
offer(e)	offerLast(e)
remove()	removeFirst()
poll()		pollFirst()
element()	getFirst()
peek()		peekFirst()                
----------------------------------------------------------------------
堆栈方法	等效 Deque 方法
push(e)	addFirst(e)
pop()	removeFirst()
peek()	peekFirst()
----------------------------------------------------------------------                
public LinkedList()
public LinkedList(Collection<? extends E> c)
```

---

# 三、Set

## 1、特点

Set是Collection子接口；常见实现类包含：HashSet、TreeSet、LinkedHashSet

特点：**唯一，不重复，Iterator遍历**

​	Set判断两个对象是否相等用equals，而不是使用==，而是**hashCode 和equals 都相等**，对象才相等

- HashSet：**采用hash表来实现，不支持同步，无序、允许一个NULL的对象**；内部维持了一个hashmap
- TreeSet：**采用树结构实现(称为红黑树算法)，自然顺序，元素不允许为null值**；
- LinkedHashSet：**采用哈希表和链表实现**；有序（存储和取出的顺序一致）；与HashSet相比访问更快，插入时性能稍微差点；继承HashSet类，实现set接口



HashSet ：内部定义了一个hashmap对象，构造方法实例化， 其内部方法基本是有map在操作

------

扩展：

TreeSet：在默认情况下，元素不允许为null值；

原因：**在取值时，在比较器为空的情况下，会判读Key 是否为空，是抛出异常**

解决办法：可以通过设置Comparator接口的实例，来实现元素允许为null值，元素为不同类型

```java
//jdk 源码
 final Entry<K,V> getEntry(Object key) {
        // Offload comparator-based version for sake of performance
        if (comparator != null)
            return getEntryUsingComparator(key);
        if (key == null)		//-----------------》》这一步会异常
            throw new NullPointerException();
		Comparable<? super K> k = (Comparable<? super K>) key;
        Entry<K,V> p = root;
        while (p != null) {
            int cmp = k.compareTo(p.key);
            if (cmp < 0)
                p = p.left;
            else if (cmp > 0)
                p = p.right;
            else
                return p;
        }
        return null;
 }

```

---

## 2、扩容机制

- HashSet底层实现是hashMap
- 扩容机制和hashMap一样 16，0.75
- add的时候调用的是hashMap的put(key，PRESENT)；方法



---

## 3、常用方法

```java
public HashSet()//默认初始容量是 16，加载因子是 0.75。
public HashSet(Collection<? extends E> c) //默认的加载因子 0.75 ;collection 中所有元素的初始容量来创建 HashMap。 
public HashSet(int initialCapacity)//底层 HashMap 实例具有指定的初始容量和默认的加载因子（0.75）
public HashSet(int initialCapacity, float loadFactor)    //指定的初始容量和指定的加载因子
```



------

# 四、Map

## 1、特点

map 常见实现类包含：主要有HashMap、LinkedHashMap和TreeMap；

特点：**键值对的映射对象，键名唯一，键值可重复**

- hashmap：**是基于哈希表，底层用数组+单向链表实现（1.8增加了黑红树）；允许使NULL；无序对象；不支持线程同步**
- treemap ：**是红黑树算法实现，有序对象（Key的自然顺序）；不允许使用NULL（key == null 会抛出异常）；不支持线程同步；**
- LinkedHashMap：拥有 `HashMap` 的所有特性，**增加了双向链表；有序对象（存储和取出的顺序一致）；不支持线程同步；**
  - 因为多了个双向链表，所以性能比hashmap差一点。
  - 因为LinkedHashMap的遍历速度只和实际数据有关，和容量无关，
  - HashMap的遍历速度和他的容量有关。

| 集合类            | Key             | Value           | Super       | 说明                   |
| ----------------- | --------------- | --------------- | ----------- | ---------------------- |
| Hashtable         | 不允许为 null   | 不允许为 null   | Dictionary  | 线程安全               |
| ConcurrentHashMap | 不允许为 null   | 不允许为 null   | AbstractMap | 锁分段技术（JDK8:CAS） |
| TreeMap           | 不允许为 null   | **允许为 null** | AbstractMap | 线程不安全             |
| HashMap           | **允许为 null** | **允许为 null** | AbstractMap | 线程不安全             |

---

## 2、存储原理

* 根据key的hash值来求得对应数组中的位置，
* 如果hash值相同，判读key 是不是同一个，是覆盖，否，链表存储；
* HashMap底层就是一个数组结构，数组中的每一项又是一个链表(Entry 构成)。当新建一个HashMap的时候，就会初始化一个数组



**HashMap发生hash碰撞的的处理机制**

- JDK7 中，当发生hash碰撞的时候，以链表的形式进行存储。
- JDK8中**增加了黑红树**的使用。当一个hash碰撞的次数超过指定次数(常量8次)的时候，链表将转化为红黑树结构

---

**扩展：**

**Key 可以为null的原理**

计算key的hash值时，会判断是否为null，如果是，则返回0，即key为null的键值对

```java
 static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }    
```

---

## 3、线程不安全原理

**线程不安全原因：**

-  HashMap多线程，put 时已被覆盖

  - 两个线程在单链上插入同一个位置时会被覆盖

-  HashMap扩容易丢失数据

  - 多个线程同时扩容时，最终只有最后一个线程生成的新数组被赋给table变量，其他线程的均会丢失。



**HashMap 死循环原理**：

transfer方法，（引入重点）这就是HashMap并发时，会引起死循环的根本原因所在

[死循环参考](https://blog.csdn.net/zhuqiuhui/article/details/51849692)



**线程安全解决方案**

- **使用Hashtable 或者 Collections.synchronizedMap（list、set 等都有）**
- 使用并发包提供的线程安全容器类
  - 各种并发容器：比如**ConcurrentHashMap**、CopyOnWriteArrayList。
  - 各种线程安全队列（Queue/Deque)，如ArrayBlockingQueue、synchronousQueue。
  - 各种有序容器的线程安全版本。

------

## 4、扩容机制

**初始容量 16  、 加载因子0.75  、扩容2倍**

- 默认构造方法初始化HashMap，初始容量16 ，thershold 为12
- 指定初始容量的构造方法初始化HashMap，threshold = 当前的容量（threshold） * DEFAULT_LOAD_FACTOR
- HashMap不是第一次扩容。如果HashMap已经扩容过的话进行rehash操作，将table的容量以及threshold量为原有的两倍。

初始容量：容量：是哈希表中桶的数量

加载因子：默认0.75，是哈希表在其容量自动增加之前可以达到多满的一种尺度



1、先判断是否大于最大容量MAXIMUM_CAPACITY的   2的30次方，是直接给出Integer的最大值

MAXIMUM_CAPACITY 为 30次方是因为hashmap 是2倍扩容，即长度是hash表的长度设为2的N次方

如果此时在扩容便会 溢出，Integer的最大值是31次方减1



java hashmap，如果确定只装载100个元素，new HashMap(?)多少是最佳的，why？

* 100/0.75 = 133.33。为了防止rehash，向上取整，为134。
* hash表的长度设为2的N次方： 128（2的7次方）<  134 <  256
* 所以 结果是256







---

## 5、hashCode的作用

* hash算法可以直接根据元素的hashCode值计算出该元素的存储位置从而快速定位该元素
* 如果两个对象相同，就是适用于equals(java.lang.Object) 方法，那么这两个对象的hashCode一定要相同
* **为什么不直接使用数组，还需要使用HashSet呢？**
  * 因为数组元素的索引是连续的，而数组的长度是固定的，无法自由增加数组的长度。而HashSet就不一样了，HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加长度，并可以根据元素的hashCode值来访问元素。

---

## 6、Hashtable 

**哈希表原理**：

* 将Key通过哈希函数转换成一个整型数字，然后用该数字除以数组长度进行取余，取余结果就当作数组的下标，将value存储在下标对应的数组空间里。

**Hashtable 继承于Dictionary，实现了Map，支持线程同步，key和value都不允许出现null值**



**key和value都不允许出现null值**

- 在put时 会判读value是否为空，为空抛出异常；
- 由于直接获取哈希值（int hash = key.hashCode();）如果此处key为null，则直接抛出空指针异常。



**Hashtable与 HashMap区别**

- **父类：**Hashtable 继承自Dictionary类，而HashMap继承自AbstractMap类。但二者都实现了Map接口。
- **同步方式：**Hashtable 支持线程同步，所有对外方法由synchronized修饰；HashMap可以通过Collections.synchronizedMap(hashMap)来进行处理
- **Key的空值：**Hashtable 中，key和value都不允许出现null值，HashMap可以由一个null的key，多个null的Value
- **哈希值：**HashTable直接使用对象的hashCode。而HashMap重新计算hash值。
- **迭代器：**HashMap的迭代器(**Iterator**)是fail-fast迭代器，而Hashtable的**enumerator**迭代器不是fail-fast的
- **扩容：**Hashtable默认的初始大小为11，之后每次扩充，容量变为原来的2n+1。HashMap默认的初始化大小为16。之后每次扩充，容量变为原来的2倍。

---

## 7、ConcurrentHashMap

**ConcurrentHashMap 与HashTable区别**

相同点： Hashtable 和 ConcurrentHashMap都是线程安全的； **key跟value都不能是null**

区别： 两者主要是性能上的差异，

- Hashtable中采用的锁机制是一次**锁住整个hash表**，从而在同一时刻**只能由一个线程对其进行操作**；
  - 效率低的原因：因为它的实现基本就是将put、get、size等方法简单粗暴地加上“synchronized”。这就导致了所有并发操作都要竞争同一把锁，一个线程在进行同步操作时，其它线程只能等待，大大降低了并发操作的性能。
- ConcurrentHashMap是使用了**锁分段技术**来保证线程安全的。默认将hash表分为16个桶，**能同时有16个写线程执行**
  - 效率高的原因：诸如get、put、remove等常用操作只锁住当前需要用到的桶。这样，原来只能一个线程进入，现在却能同时有16个写线程执行，并发性能的提升是显而易见的。



**key跟value都不能是null：有很多方法都使用 null 值来指示映射中某个给定的键不存在**



**ConcurrentHashMap为什么并发效率高**

早期的ConcurrentHashMap其实现是基于：

- 分离锁，也就是将内部进行分段（Segment），里面则是HashEntry的数组。和HashMap类似，哈希相同的条目也是以链表形式存放。
- HashEntry内部使用volatile的value字段来保证可见性

Java 8对ConcurrentHashMap的改进

- 在结构上，虽然仍然有Segment定义，但是仅仅是为了给旧版本兼容。**初始化已经改成了Lazy-load的形式了**，有效避免了初始化开销。
- 数据存储利用的是Volatile来保证可见性。



集合并发类：ConcurrentHashMap、CopyOnWriteArrayList、阻塞队列（如LinkedBlockingQueue）

---

## 8、hashmap遍历

```java
 // 1. 通过Map.keySet遍历key和value：
for (String key : hashmap.keySet()){
    System.out.println("key: "+ key + "; value: " + hashmap.get(key));
}

//2. 通过Map.entrySet使用iterator遍历key和value：
Iterator<Map.Entry<Integer, String>> it = hashmap.entrySet().iterator();
while (it.hasNext()){
    Map.Entry<Integer, String> entry = it.next();
    System.out.println("key: "+ entry.getKey() + "; value: " + entry.getValue());
}

//3. 通过Map.entrySet遍历key和value
for(Map.Entry<Integer, String> entry : hashmap.entrySet()){
    System.out.println("key: "+ entry.getKey() + "; value: " + entry.getValue());
}

//4. 通过Map.values()遍历所有的value，但不能遍历key
for (String value : hashmap.values()) {
    System.out.println("value: "+value);
}
```



---

# 五、Queue

## 1、特点

Queue 的父接口是collection；**顺序结构和链式结构实现**、**“先进先出”**，**队尾插入，表头删除**

## 2> 阻塞队列

[参考博文](http://ifeve.com/java-blocking-queue/)

阻塞队列提供了四种处理方法:

| 方法\处理方式 | 抛出异常  | 返回特殊值 | 一直阻塞 | 超时退出           |
| ------------- | --------- | ---------- | -------- | ------------------ |
| 插入方法      | add(e)    | offer(e)   | put(e)   | offer(e,time,unit) |
| 移除方法      | remove()  | poll()     | take()   | poll(time,unit)    |
| 检查方法      | element() | peek()     | 不可用   | 不可用             |

- 抛出异常：是指当阻塞队列满时候，再往队列里插入元素，会抛出IllegalStateException(“Queue full”)异常。当队列为空时，从队列里获取元素时会抛出NoSuchElementException异常 。
- 返回特殊值：插入方法会返回是否成功，成功则返回true。移除方法，则是从队列里拿出一个元素，如果没有则返回null
- 一直阻塞：当阻塞队列满时，如果生产者线程往队列里put元素，队列会一直阻塞生产者线程，直到拿到数据，或者响应中断退出。当队列空时，消费者线程试图从队列里take元素，队列也会阻塞消费者线程，直到队列可用。
- 超时退出：当阻塞队列满时，队列会阻塞生产者线程一段时间，如果超过一定的时间，生产者线程就会退出。



阻塞队列常用方法:  **一个多线程程序中 ， 使用 offer 、 poll和 peek 方法**

- 往队列中添加元素: add(), put(), offer()
- 从队列中取出或者删除元素: remove() element()  peek()   poll()  take()



比较常用的有**ArrayBlockingQueue**和**LinkedBlockingQueue**，前者是以数组的形式存储，后者是以Node节点的链表形式存储。



JDK7提供了7个阻塞队列。分别是

- **ArrayBlockingQueue** ：一个由**数组结构**组成，**指定的容量**和公平性（重入锁实现）设置的阻塞队列。
- **LinkedBlockingQueue** ：一个由**链表结构**组成，默认情况下的容量是**没有上边界**的， 但也可以选择指定最大容量 
- PriorityBlockingQueue ：一个无边界阻塞，带优先级的队列 ， 用堆实现。
- DelayQueue：无界，但时间有限的阻塞队列。
- SynchronousQueue：一个不存储元素的阻塞队列。
- LinkedTransferQueue：一个由链表结构组成的无界阻塞队列。
- LinkedBlockingDeque：一个由链表结构组成的双向阻塞队列。



**阻塞队列**（BlockingQueue）是一个支持两个附加操作的队列。这两个附加的操作是：在队列为空时，获取元素的线程会等待队列变为非空。当队列满时，存储元素的线程会等待队列可用。

**使用场景：**

阻塞队列常用于生产者和消费者的场景，生产者是往队列里添加元素的线程，消费者是从队列里拿元素的线程。阻塞队列就是生产者存放元素的容器，而消费者也只从容器里拿元素。



