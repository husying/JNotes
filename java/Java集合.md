# 默认集合

# 一、集合框架

## 1、集合关系

Java集合类存放于 java.util 包中，是一个用来存放对象的容器。

![1559390873399](assets/1559390873399.png)



## 2、Collection 接口

**List**

特点：**排列有序，可重复，允许多个NULL**

* ArrayList：基于`动态数组`实现，读取速度快，增删慢；

* Vector：和 ArrayList 类似，但它是`线程安全`的

* LinkedList：基于`双向链表`实现，只能顺序访问，所以`查询速度慢`，但`插入和删除元素快`。不仅如此，LinkedList 还可以用作栈、队列和双向队列。（JDK1.6之前为循环链表，JDK1.7取消了循环）




**Set**

特点：唯一，不重复

* **HashSet**：**（无序，唯一）**基于`哈希表`实现、`无序`，值允许为 null ，查找的时间复杂度为 O(logN)

* **TreeSet**：**（有序，唯一）**基于`红黑树`实现、`自然序`，值不为 null 值，查找的时间复杂度为 O(1)

* **LinkedHashSet**：具有 HashSet特性，增加`双向链表`维持元素的顺序，有序(`插入顺序`)

  

**Queue**

特点：先进先出

* **LinkedList**：可以用它来实现双向队列。
* **PriorityQueue**：基于堆结构实现，可以用它来实现优先队列。



**Collection 接口方法**

```java
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
```

---

## 3、Map 接口

特点：键值对存储，键名唯一，键值可重复

* **HashMap**：基于`哈希表实现`。底层用`数组+单向链表`（1.8增加了`黑红树`）存储。`无序`，键名唯一，可为空；键值可重复，可为 null
* **TreeMap**：基于`红黑树`实现。`自然序`，键值键名都不能为 NULL。
* **LinkedHashMap**：拥有 HashMap 的所有特性，增加了`双向链表`维持元素的顺序，有序(`插入顺序`)



**Hashtable：** 数组+链表组成的，数组是 HashMap 的主体，链表则是主要为了解决哈希冲突而存在的



TreeMap 不能为空，键名为 NULL 会抛异常

```java
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



## 4、迭代器（Iterator）

Collection 继承了 Iterable 接口，其中的 iterator() 方法能够产生一个 Iterator 对象，通过这个对象就可以迭代遍历 Collection 中的元素。

从 JDK 1.5 之后可以使用 foreach 方法来遍历实现了 Iterable 接口的聚合对象。

**特点**：

* 迭代遍历过程中，禁止改变容器大小，如：add、remove操作，会抛出ConcurrentModificationException异常
* **快速失败机制（fail-fast）**：
  * 当多个线程对Collection进行操作时，若其中某一个线程通过 Iterator 遍历集合时，该集合的内容被其他线程所改变，则会抛出ConcurrentModificationException异常。

**Fail-Fast 原因**

* 是迭代器在遍历时直接访问集合中的内容，并且在遍历过程中使用一个 modCount 变量（用来记录 ArrayList 结构发生变化的次数）。集合在被遍历期间如果内容发生变化，就会改变 modCount 的值。
* 结构发生变化是指添加或者删除至少一个元素的所有操作，或者是调整内部数组的大小，仅仅只是设置元素的值不算结构发生变化。
* 每当迭代器使用 hashNext()/next() 遍历下一个元素之前，都会检测 modCount 变量是否为 expectedModCount 值，是的话就返回遍历；否则抛出异常，终止遍历。



**快速失败（fail-fast）和安全失败（fail-safe）**

* HashMap、ArrayList 这些集合类，这些在 java.util 包的集合类就都是快速失败的；而 java.util.concurrent 包下的类都是安全失败，比如：ConcurrentHashMap。
* 快速失败在遍历时`直接访问`集合中的内容
* 安全失败在遍历时不是直接在集合内容上访问的，而是`先复制`原有集合内容，在拷贝的集合上进行遍历。



**快速失败（fail-fast）解决办法**

* 通过util.concurrent集合包下的相应类（CopyOnWriteArrayList是自己实现Iterator）去处理，则不会产生fast-fail事件。
* CopyOnWriteArrayList类是复制了数组，不是直接操作原数组

 

**for循环与迭代器的对比**

* **foreach使用的是迭代器循环，for是使用索引下标检索**

* 需要**循环数组结构**的数据时，建议**使用普通for循环**，因为for循环采用下标访问，对于数组结构的数据来说，采用下标访问比较好。
* 需要**循环链表结构**的数据时，**一定不要使用普通for循环**，这种做法很糟糕，数据量大的时候有可能会导致系统崩溃。

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



---

## 5、多线程下的集合安全

由于集合大多数是线程不安全的，可采用如下方式处理

* 使用加锁机制：synchronized、Lock
* 使用volalite修饰
* 使用ThreadLocal对象
* 使用集合工具类Collections，通过如下方法操作，常用有：
    * `synchronizedCollection(Collection<T> c)`
    * `synchronizedList(List<T> list)`
    * `synchronizedMap(Map<K,V> m)`
    * `synchronizedSet(Set<T> s)`
* 使用 `java.util.concurrent` 提供的并发集合对象，其提供了映射 、 有序集和队列的高效实现 ，常用有：
    * **ConcurrentHashMap**
    * **CopyOnWriteArrayList**
    * **CopyOnWriteArraySet**
    * ConcurrentSkipListMap（SkipList：跳表）、 
    * ConcurrentSkipListSet 
    * ConcurrentLinkedQueue



注释 ： 有些应用使用庞大的并发散列映射 ， 这些映射太过庞大 ， 以至于无法用 size 方法得到它的大小，因为这个方法只能返回 int。 对于一个包含超过20 亿条目的映射该如何处理  **JavaSE 8 引入了一个 mappingCount 方法可以把大小作为 long 返回。**



---

# 二、源码分析--ArrayList

## 1、存储机制

底层使用 **数组** 实现。**默认长度 10** 

因为写入或读取都是通过数组索引直接操作，所以：**允许为 null 值， 可以重复**

因为数组特性：**有索引，访问速度快**。

```java 
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable{
    private static final int DEFAULT_CAPACITY = 10;  // 默认大小为 10
    transient Object[] elementData;  //  数组存储
    private int size;
}
```

ArrayList 实现了**RandomAccess 接口**， RandomAccess 是一个标志接口，表明实现这个这个接口的 List 集合是支持**快速随机访问**的。在 ArrayList 中，我们即可以通过元素的序号快速获取元素对象，这就是快速随机访问。

ArrayList 实现了**Cloneable 接口**，即覆盖了函数 clone()，**能被克隆**。

ArrayList 实现**java.io.Serializable 接口**，这意味着ArrayList**支持序列化**，**能通过序列化去传输**。

读取方法：访问速度快

```java
public E get(int index) {
    rangeCheck(index);
    return elementData(index);
}
 private void rangeCheck(int index) {
     if (index >= size)
         throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
 }
```



新增方法：

```java
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
private void ensureCapacityInternal(int minCapacity) {
    ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
}
private static int calculateCapacity(Object[] elementData, int minCapacity) {
    if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
        return Math.max(DEFAULT_CAPACITY, minCapacity);
    }
    return minCapacity;
}
private void ensureExplicitCapacity(int minCapacity) {
    modCount++; // 迭代时，用来判断是否被其他线程修改
    if (minCapacity - elementData.length > 0)
        // 扩容
        grow(minCapacity);
}
```

**增删速度慢**：增删操作会对数组复制操作，所以速度较慢；

如下以，删除为例：

```java
public E remove(int index) {
    rangeCheck(index);
    modCount++;
    E oldValue = elementData(index);
    int numMoved = size - index - 1;
    if (numMoved > 0)
        // 这行影响 速率
        System.arraycopy(elementData, index+1, elementData, index,  numMoved);  
    elementData[--size] = null; 
    return oldValue;
}
```

**System.arraycopy的函数原型**

调用 System.arraycopy() 将 index+1 后面的元素都复制到 index 位置上，该操作的时间复杂度为 O(N)，可以看出 ArrayList 删除元素的代价是非常高的。

```java
public static native void arraycopy(
    Object src, 	//  表示源数组
    int srcPos, 	//  表示源数组要复制的起始位置
    Object dest,	//	表示目标数组
    int destPos,	//  目标数组要复制的起始位置
    int length)	；	//  表示要复制的长度
```

**添加或删除数据为什么LinkedList 比ArrayList 效率高**

* 在添加或删除数据的时候，ArrayList经常需要复制数据到新的数组，LinkedList只需改变节点之间的引用关系

---



## 2、扩容机制

**ArrayList 扩容**

* 1、默认**初始容量 10**，如果数据长度超过，则容量扩大为原来的 **1.5倍**，
* 2、然后会再判断，扩容后的容量大小是否任然小于数据长度、是则，取为数据大小为最新容量大小
* 3、再判断此时的最新容量大小是否超过最大容量值 `MAX_ARRAY_SIZE`，
* 4、是则，判断数据大小是否超过最大容量值 ，
    * 数据大小超过最大容量，则取 Integer 的最大值作为最新容量大小。
    * 数据大小没有最大容量，则取最大容量作为最新容量大小。

```java
private void grow(int minCapacity) {
    int oldCapacity = elementData.length;
    // 默认扩容 1.5 倍 ；  >>1 相当于除 2
    int newCapacity = oldCapacity + (oldCapacity >> 1);		
    if (newCapacity - minCapacity < 0)
        newCapacity = minCapacity;
    if (newCapacity - MAX_ARRAY_SIZE > 0)
        newCapacity = hugeCapacity(minCapacity);
    elementData = Arrays.copyOf(elementData, newCapacity);
}
private static int hugeCapacity(int minCapacity) {
    if (minCapacity < 0) // overflow
        throw new OutOfMemoryError();
    return (minCapacity > MAX_ARRAY_SIZE) ? Integer.MAX_VALUE :  MAX_ARRAY_SIZE;
}
```



------

## 3、Vectot

Vectot的扩容：默认初始容量`10`，可以通过构造器 **指定** 的**初始容量**和**容量增量**，每次增加 **`2 倍`**

```java
Vector(int initialCapacity)	//构造具有指定初始容量并且其容量增量等于零的空向量。
Vector(int initialCapacity, int capacityIncrement)	//构造具有指定的初始容量和容量增量的空向量。
```

**线程安全**

它有对外方法都由 synchronized 修饰

```java
public synchronized boolean add(E e) {
    modCount++;
    ensureCapacityHelper(elementCount + 1);
    elementData[elementCount++] = e;
    return true;
}
public synchronized E get(int index) {
    if (index >= elementCount)
        throw new ArrayIndexOutOfBoundsException(index);
    return elementData(index);
}
```

**扩容源码**

```java
private void grow(int minCapacity) {
    // overflow-conscious code
    int oldCapacity = elementData.length;
    int newCapacity = oldCapacity +
        ((capacityIncrement > 0) ? capacityIncrement : oldCapacity); // 扩容加一倍
    if (newCapacity - minCapacity < 0)
        newCapacity = minCapacity;
    if (newCapacity - MAX_ARRAY_SIZE > 0)
        newCapacity = hugeCapacity(minCapacity);
    elementData = Arrays.copyOf(elementData, newCapacity);
}
```



## 4、ArrayList 和 Vector 的区别

*   Vector 基本与ArrayList类似，数组存储，排列有序，可重复，允许多个NULL1、
*   访问效率比ArrayList稍慢，因为**`Vector是同步的，线程安全`**，它有对外方法都由 synchronized 修饰。

**为什么要用Arraylist取代Vector呢**

*   Vector类的所有方法都是同步的。可以由两个线程安全地访问一个Vector对象、但是一个线程访问Vector的话代码要在同步操作上耗费大量的时间。
*   Arraylist不是同步的，所以在不需要保证线程安全时时建议使用Arraylist。

## 5、Arraylist 与 LinkedList 区别

*   **线程安全：** ArrayList 和 LinkedList 都是不同步的，也就是不保证线程安全；

*    **底层数据结构**：Arraylist 底层使用的是Object数组；LinkedList 底层使用的是双向链表数据结构
*   **插入和删除是否受元素位置的影响**
    *   ① **ArrayList 采用数组存储，所以插入和删除元素的时间复杂度受元素位置的影响，时间复杂度就为 O(n-i)**
    *   ② **LinkedList 采用链表存储，所以插入，删除元素时间复杂度不受元素位置的影响，都是近似 O（1）而数组为近似 O（n）**

*   **是否支持快速随机访问：** LinkedList 不支持高效的随机元素访问，而 ArrayList 支持。快速随机访问就是通过元素的序号快速获取元素对象(对应于`get(int index) `方法)。

## 5、并发安全

**ArrayList 线程不安全原因**：使用数组存储，当前多线程时，当对同一位置操作时，可能会被覆盖，或者读取到了未更新的数据等一系列问题。

**线程安全解决方案**

* 使用 `Collections.synchronizedList();` 得到一个线程安全的 ArrayList。
* 使用 `CopyOnWriteArrayList`代替：**读写分离的安全型并发集合对象**，写操作需要加锁，防止并发写入时导致写入数据丢失。写操作在一个复制的数组上进行，写操作结束之后需要把原始数组指向新的复制数组。读操作还是在原始数组中进行，读写分离，互不影响。
  * 使用场景：适合读多写少的应用场景。
  * 缺点 1 ：内存占用：在写操作时需要复制一个新的数组，使得内存占用为原来的两倍左右；
  * 缺点 1 ：数据不一致：读操作不能读取实时性的数据，因为部分写操作的数据还未同步到读数组中。



**1> Collections.synchronizedList() 方式**

通过 synchronizedList() 返回一个 SynchronizedList 对象。 该对象内部维持 List 对象进行操作，并使用 synchronized 进行封装，来保证线程安全。

其他Set、Map 都是同理

```java
// 创建一个线程安全对象
public static <T> List<T> synchronizedList(List<T> list) {
    return (list instanceof RandomAccess ?
            new SynchronizedRandomAccessList<>(list) :
            new SynchronizedList<>(list));
}

static class SynchronizedList<E>  extends SynchronizedCollection<E>  implements List<E> {
     final List<E> list;
     SynchronizedList(List<E> list) {
         super(list);
         this.list = list;
     }
}
public E get(int index) {
    synchronized (mutex) {return list.get(index);}
}
public E set(int index, E element) {
    synchronized (mutex) {return list.set(index, element);}
}
public void add(int index, E element) {
    synchronized (mutex) {list.add(index, element);}
}
```

**2> CopyOnWriteArrayList**

读写分离的安全型并发集合对象，

写操作需要加锁，防止并发写入时导致写入数据丢失。写操作在一个复制的数组上进行，写操作结束之后需要把原始数组指向新的复制数组。

读操作还是在原始数组中进行，读写分离，互不影响。

```java
public class CopyOnWriteArrayList<E>
    implements List<E>, RandomAccess, Cloneable, java.io.Serializable {
    final transient ReentrantLock lock = new ReentrantLock(); 
    private transient volatile Object[] array;
}
```

读写操作：

```java
// 读操作
private E get(Object[] a, int index) {
    return (E) a[index];
}
// 写操作 加锁
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        // 内存占用：需要复制一个新的数组，使得内存占用为原来的两倍左右；
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        newElements[len] = e;
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
final void setArray(Object[] a) { array = a; }
final Object[] getArray() { return array; }
```



## 6、排序

集合排序的两种方式

- 对象实现 `Comparable` 接口，
- 使用 `Collections.sort`（List<T> list, Comparator<? super T> c），
- 使用 `ArrayList#sort`(Comparator<? super E> c)

前一种：**重写 compareTo(T o) 方法** ，

后两种：通过**匿名内部类**的方式**实现比较器 Comparator 接口**，重写compare(T o1, T o2)

```java
public class Student implements Comparable<Student> {
	private int age;
    @Override
    public int compareTo(Student o) {
        return this.age - o.age;   // 升序
    }
}
//自定义排序1
Collections.sort(list, new Comparator<Student>() {
    @Override
    public int compare(Student s1, Student s2) {
        return s1.getAge() - s2.getAge();
    }
});
//自定义排序2
new ArrayList().sort(new Comparator<Student>() {
    @Override
     public int compare(Student s1, Student s2) {
        return s1.getAge() - s2.getAge();
    }
});
```



---

## 7、List 和Array转换

**List 转Array**：使用 list.toArray() 

```java
List<String> list = new ArrayList<String>();
Object[] array=list.toArray();
```



**Array 转 List**：使用 Arrays.asList(array)

```java
// 方式 1
List<String> list = Arrays.asList(array);  // 有缺陷
// 方式 2
List<String> list = new ArrayList<String>(Arrays.asList(array));
// 方式 3
List<String> list = new ArrayList<String>(array.length);
Collections.addAll(list, array);
```

**注意**：

**Arrays.asList(array) 不能作为一个 List 对象的复制操作**

方式 1 中 只是复制了引用，list 修改会改变 array 内容，因为返回的 list 是 Arrays 里面的一个静态内部类，该类并未实现add、remove方法，因此在使用时存在局限性

List<String> list = Arrays.asList(array)，

一般使用第 2 中和第 3 种方式转换

```java
String[] arr = {"1","2","3","4","5"};
List<String> list1 = new ArrayList<String>(Arrays.asList(arr));
List<String> list2 = Arrays.asList(arr);  

list1.set(0, "AA");
System.out.println("Array:"+Arrays.toString(arr));
System.out.println("List :"+list2.toString());

System.out.println();

list2.set(0, "a");
System.out.println("Array:"+Arrays.toString(arr));
System.out.println("List :"+list2.toString());

// 输出
Array:[1, 2, 3, 4, 5]
List :[1, 2, 3, 4, 5]

Array:[a, 2, 3, 4, 5]
List :[a, 2, 3, 4, 5]
```



---

## 8、ArrayList 去重

- 双重for循环去重
- 通过set集合判断去重,不打乱顺序
- 遍历后以 contains() 判断赋给另一个list集合
- set和list转换去重 



```java
//双重for循环去重
for (int i = 0; i < list.size() - 1; i++) {
    for (int j = list.size() - 1; j > i; j--) {
        if (list.get(j).equals(list.get(i))) {
            list.remove(j);
        }
    }
}
```



```java
//set集合判断去重,不打乱顺序
List<String> listNew=new ArrayList<>();
Set set=new HashSet();
for (String str:list) {
    if(set.add(str)){
        listNew.add(str);
    }
}
// HashSet 的add方法
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```



```java
//遍历后以contains判断赋给另一个list集合
List<String> listNew=new ArrayList<>();
for (String str:list) {
    if(!listNew.contains(str)){
        listNew.add(str);
    }
}
```

```java
//set和list转换去重 
List<String> listNew=new ArrayList<>(new HashSet(list)); // TreeSet 也可以
```



---

## 9、常用方法

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

# 三、源码分析--LinkedList

## 1、存储原理

* LinkedList 基于`双向链表`实现，继承于 AbstractSequentialList ，
* **内部维持 2个 节点对象 first、last**；每个 Node 节点有3个属性 **item、next、prev**，
* LinkedList 实现 **List、Deque 接口**，因此它也可以被当作堆栈、队列或双端队列进行操作。
* 当您在列表中插入空值时，您将 item 为 null节点，但 next 和 prev 指针是非空的，因此：**`可以有个 null 值`**

```java
public class LinkedList<E> extends AbstractSequentialList<E> implements List<E>, Deque<E>, Cloneable, java.io.Serializable{
    transient int size = 0;
    transient Node<E> first;
    transient Node<E> last;
    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
	}
}
```

**添加元素**

```java
public boolean add(E e) {
    linkLast(e);
    return true;
}
void linkLast(E e) {
    final Node<E> l = last;
    final Node<E> newNode = new Node<>(l, e, null);
    last = newNode;
    if (l == null)
        first = newNode;
    else
        l.next = newNode;
    size++;
    modCount++;
}
```

## 2、常见方法

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
```



## 3、并发安全

**线程不安全原因**：使用数组存储，当前多线程时，当对同一位置操作时，可能会被覆盖，或者读取到了未更新的数据等一系列问题。

**线程安全解决方案**：使用 ConcurrentLinkedQueue



**ConcurrentLinkedQueue**

新增元素使用 `volatile + CAS`  来保证线程安全

```java
private transient volatile Node<E> tail;   //  volatile ---> 保证变量可见性
public boolean offer(E e) {
    checkNotNull(e);   // 判断节点是否为空
    final Node<E> newNode = new Node<E>(e);
   
    for (Node<E> t = tail, p = t;;) {
        Node<E> q = p.next;
        if (q == null) { // 判断 p 是否是尾节点
            if (p.casNext(null, newNode)) {  // casNext 使用 CAS 算法 ---> 保证线程安全
                if (p != t)  // 判断尾节点是否已被修改，是更新 tail节点
                    casTail(t, newNode);  //  使用 CAS 算法 ---> 保证线程安全
                return true;
            }
        }
        else if (p == q)
            p = (t != (t = tail)) ? t : head;
        else
            p = (p != t && t != (t = tail)) ? t : q;
    }
}

private static final sun.misc.Unsafe UNSAFE;
boolean casNext(Node<E> cmp, Node<E> val) {
    return UNSAFE.compareAndSwapObject(this, nextOffset, cmp, val);
}

```

**Unsafe** 

*   Unsafe类是在`sun.misc` 包下，不属于Java标准。但是很多Java的基础类库，包括一些被广泛使用的高性能开发库都是基于Unsafe类开发的，比如Netty、Hadoop、Kafka等。Unsafe可认为是Java中留下的后门，提供了一些低层次操作，如直接内存访问、线程调度等。 官方并不建议使用Unsafe。

*   通过这个类可以直接使用底层 native 方法来获取和操作底层的数据，例如获取一个字段在内存中的偏移量，利用偏移量直接获取或修改一个字段的数据等等

*   不安全的操作。如何理解这个不安全呢？在java的世界里所有的变量都是通过把代码编译成class字节码加载到JVM虚拟机中，通过虚拟机来操作内存中字段的数据，在此过程中，JVM帮程序员做了很多事情，其中大部分是内存的管理。

*   在JUC(java.util.concurrent)中使用了大量的Unsafe类（多线程、concurrentHashMap、AtomicInteger等等），他可以很方便的使用CAS来确保数据的可见性，同时比正常的Synchroized速度快很多。



---

# 四、源码分析--HashMap

## 1、存储机制

*   HashMap 基于**哈希表**实现。底层用  **数组+单向链表**（1.8增加了 **`黑红树`** ）存储。数组中的每个位置被当成一个桶，一个桶存放一个链表。当发生 hash 碰撞的时候，以链表的形式进行存储

*   HashMap 以**键值对方式存储**，内部包含了一个 Node 类型的数组 table。 每个 Node 节点有4个属性：`hash、key、value 、next`
*   **排列无序，键名唯一，可为 null ；键值可重复，可为 null **



```java
public class HashMap<K,V> extends AbstractMap<K,V> implements Map<K,V>, Cloneable, Serializable {
	static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
    static final int MAXIMUM_CAPACITY = 1 << 30;
    static final float DEFAULT_LOAD_FACTOR = 0.75f;
    
    static class Node<K,V> implements Map.Entry<K,V> {
        final int hash;
        final K key;
        V value;
        Node<K,V> next;

        Node(int hash, K key, V value, Node<K,V> next) {
            this.hash = hash;
            this.key = key;
            this.value = value;
            this.next = next;
        }
		// *****省略 *****
    }
    transient Node<K,V>[] table;  // 哈希表
    transient Set<Map.Entry<K,V>> entrySet;
    transient int size;
    transient int modCount;
}
```



### 1> 计算 hash 

* **Key 不为 null**：计算key的hash值时，会判断是否为 null

```java
 static final int hash(Object key) {
     int h;
     return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
 }    
```

**hashCode 作用**

* hash 算法可以直接根据元素的 hashCode 值计算出该元素的存储位置从而快速定位该元素
* 如果两个对象相同，就是适用于 equals() 方法，那么这两个对象的hashCode一定要相同
* **为什么不直接使用数组，还需要使用HashSet呢？**
  * 因为数组元素的索引是连续的，而数组的长度是固定的，无法自由增加数组的长度。而HashSet就不一样了，HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加长度，并可以根据元素的hashCode值来访问元素。

### 2> 存储方式

HashMap 是以 数组 + 双向链表 + 红黑树

* 不发生 hash 碰撞时以数组存储
* 发生 hash 碰撞，且链表长度小于 8 ，以链表存储
* 发生 hash 碰撞，且链表长度大于等于 8 ，转为红黑树存储，（JDK 1.8 新增的 ）

```java
// 数组
int i = (table.length - 1) & hash(key);
tab[i] = newNode(hash, key, value, null);
// 链表
p.next = newNode(hash, key, value, null);
// 红黑树
((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value)
```

所谓 **“拉链法”** 就是：将链表和数组相结合。也就是说创建一个链表数组，数组中每一格就是一个链表。若遇到哈希冲突，则将冲突的值加到链表中即可。



![JDK1.8之后的HashMap底层数据结构](assets/687474703a2f.jpg)

>   TreeMap、TreeSet以及JDK1.8之后的HashMap底层都用到了红黑树。红黑树就是为了解决二叉查找树的缺陷，因为二叉查找树在某些情况下会退化成一个线性结构。



### 3> put 操作

```java
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}
final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
     //  集合大小为 0 时会初次扩容resize()
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length; 
    // 判断是否发生 hash 碰撞，数组索引为 (n - 1) & hash 
    if ((p = tab[i = (n - 1) & hash]) == null)  
        tab[i] = newNode(hash, key, value, null);	// 不发生 hash 碰撞，以数组存储
    else {
        Node<K,V> e; K k;
        if (p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k))))
            e = p;
        else if (p instanceof TreeNode)  // 判断是否是树节点
             // 红黑树存储
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value); 
        else {
            //   链表插入 ----start
            for (int binCount = 0; ; ++binCount) {
                if ((e = p.next) == null) {
                    p.next = newNode(hash, key, value, null);	// 链表存储
                    //  TREEIFY_THRESHOLD = 8; 链表长度
                    if (binCount >= TREEIFY_THRESHOLD - 1) //  判断链表长度是否大于 8 
                        treeifyBin(tab, hash);	//   转换 Node 节点为 TreeNode 节点
                    break;
                }
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    break;
                p = e;
            }
            //  链表插入 ----end
        }
        if (e != null) { // existing mapping for key
            V oldValue = e.value;
            if (!onlyIfAbsent || oldValue == null)
                e.value = value;
            afterNodeAccess(e);
            return oldValue;
        }
    }
    ++modCount;
    if (++size > threshold)  // 是否扩容判断，阀值threshold = 初始容量 * 负载因子
        resize();
    afterNodeInsertion(evict);
    return null;
}
```

当 HashMap 中同一 hash 位的链表长度大于 8  时， 将Node 节点对象，转换成 树节点对象 TreeNode

```java
final void treeifyBin(Node<K,V>[] tab, int hash) {
    int n, index; Node<K,V> e;
    if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY)
        resize();
    else if ((e = tab[index = (n - 1) & hash]) != null) {
        TreeNode<K,V> hd = null, tl = null;
        do {
            TreeNode<K,V> p = replacementTreeNode(e, null); // 转换 Node 对象为TreeNode 
            if (tl == null)
                hd = p;
            else {
                p.prev = tl;
                tl.next = p;
            }
            tl = p;
        } while ((e = e.next) != null);
        if ((tab[index] = hd) != null)
            hd.treeify(tab);
    }
}
TreeNode<K,V> replacementTreeNode(Node<K,V> p, Node<K,V> next) {
    return new TreeNode<>(p.hash, p.key, p.value, next);
}
```

### 4> get 操作

```java
public V get(Object key) {
    Node<K,V> e;
    return (e = getNode(hash(key), key)) == null ? null : e.value;
}
final Node<K,V> getNode(int hash, Object key) {
    Node<K,V>[] tab; Node<K,V> first, e; int n; K k;
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (first = tab[(n - 1) & hash]) != null) {
        if (first.hash == hash && 
            ((k = first.key) == key || (key != null && key.equals(k))))
            return first;
        if ((e = first.next) != null) {
            if (first instanceof TreeNode)
                return ((TreeNode<K,V>)first).getTreeNode(hash, key);
            do {
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    return e;
            } while ((e = e.next) != null);
        }
    }
    return null;
}
```



## 2、扩容机制

**JDK 8 源码分析**：

- **初始容量**：`默认 16`，指哈希表中桶的数量
- **负载因子**：`默认 0.75`，指哈希表在其容量自动增加之前可以达到多满的一种尺度
- **初始阀值**：`初始容量 * 负载因子`  (16 * 0.75 = 12)
- **扩容倍数**：`2 倍`
- **容量范围**：`16 < 容量 < MAXIMUM_CAPACITY`（2^30^），超出默认为 `Integer.MAX_VALUE` ( 2^31^-1)



**HashMap 的长度为什么是2的幂次方**

*   **“取余(%)操作中如果除数是2的幂次则等价于与其除数减一的与(&)操作（也就是说 hash%length==hash&(length-1)的前提是 length 是2的 n 次方；）。”** 
*   并且 **采用二进制位操作 &，相对于%能够提高运算效率，这就解释了 HashMap 的长度为什么是2的幂次方。**



**扩容步骤：**

**第一步：**

1. 如果：原容量大于 0 的情况下，
   * 比较原容量是否超出`最大容量`，是设置**阀值**为 `Integer.MAX_VALUE`，并返回当前 哈希表 table
   * 否则，设置**新容量为原来 2 倍 **，再判断此时新容量是否在`容量范围`中，是，则**新阀值为原来 2 倍**
2. 如果：原容量等于 0 ，但阀值大于 0  的情况下， 设置**容量等于阀值**。 这种情况是在 new HashMap(0) 时，经tableSizeFor()计算得阀值会为 1。
3. 在 1,2 不满足的情况下，直接**设置默认初始容量和阀值**

**第二步**：在判断阀值是否为 0，是 ，则根据当前容量大小设置阀值为 **容量 * 负载因子** ，或者为 **Integer.MAX_VALUE**

**第三步**：new 一个新的哈希表，复制数据到新哈希表，这一步非常消耗时间

```java
static final int MAXIMUM_CAPACITY = 1 << 30;  // 集合最大容量 
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // 初始容量 16

// 扩容方法
final Node<K,V>[] resize() {
    Node<K,V>[] oldTab = table;
    // oldCap 数组长度  oldThr 阀值
    int oldCap = (oldTab == null) ? 0 : oldTab.length;
    int oldThr = threshold;  
    int newCap, newThr = 0;
    // 计算容量和阀值得大小 --- star
    if (oldCap > 0) {
        if (oldCap >= MAXIMUM_CAPACITY) {
            threshold = Integer.MAX_VALUE;
            return oldTab;
        }
        // 扩容条件，扩容后的容量在 16 到 最大容量之间时
        // 扩容大小为 << 1 ，2 倍，相当乘 2 
        else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                 oldCap >= DEFAULT_INITIAL_CAPACITY)
            newThr = oldThr << 1; // double threshold
    }
    else if (oldThr > 0) // initial capacity was placed in threshold
        newCap = oldThr;
    else {               // zero initial threshold signifies using defaults
        newCap = DEFAULT_INITIAL_CAPACITY;
        newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
    }
    if (newThr == 0) {
        float ft = (float)newCap * loadFactor;
        newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
                  (int)ft : Integer.MAX_VALUE);
    }
    // 计算容量和阀值得大小 --- end
    
    // 扩容，复制新数组---start
    threshold = newThr;
    @SuppressWarnings({"rawtypes","unchecked"})
    Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
    table = newTab;
    if (oldTab != null) {
        for (int j = 0; j < oldCap; ++j) {
            Node<K,V> e;
            if ((e = oldTab[j]) != null) {
                oldTab[j] = null;
                if (e.next == null)
                    newTab[e.hash & (newCap - 1)] = e;
                else if (e instanceof TreeNode)
                    ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
                else { // 链表优化，重新计算hash
                    Node<K,V> loHead = null, loTail = null;
                    Node<K,V> hiHead = null, hiTail = null;
                    Node<K,V> next;
                    do {
                        next = e.next;
                        if ((e.hash & oldCap) == 0) {
                            if (loTail == null)
                                loHead = e;
                            else
                                loTail.next = e;
                            loTail = e;
                        }
                        else {
                            if (hiTail == null)
                                hiHead = e;
                            else
                                hiTail.next = e;
                            hiTail = e;
                        }
                    } while ((e = next) != null);
                    if (loTail != null) {
                        loTail.next = null;
                        newTab[j] = loHead;
                    }
                    if (hiTail != null) {
                        hiTail.next = null;
                        newTab[j + oldCap] = hiHead;
                    }
                }
            }
        }
    }
    // 扩容，复制新数组---end
    return newTab;
}
```



**题型计算**

 HashMap对象如果确定只装载100个元素，new HashMap(?)多少是最佳的，why ？

解答：

1. 100/0.75 = 133.33。为了防止rehash，向上取整，为134。
2. hash表的长度设为2的N次方： 128（2的7次方）<  134 <  256
3. 所以 结果是256



**扩容时数据位置发生变化**
1、没有用到链表时，桶下标为：`int i= hash & (newCap-1)` ， 取值时根据桶下标获取： `(n-1)&hash` 
2、用到链表的桶下标对应：低位不变，高位（index+oldCap）

```java
// 高低位判断
(e.hash & oldCap) == 0  // ---> oldCap 扩容器容量大小

// 没有用到链表
e = oldTab[j]
newTab[e.hash & (newCap - 1)] = e;  // ----> 下标相等于高低位运算后的桶下标

// 用到链表
// 位置不变    
if (loTail != null) {
    loTail.next = null;
    newTab[j] = loHead;
}
// 位置迁移(index+oldCap)
if (hiTail != null) {
    hiTail.next = null;
    newTab[j + oldCap] = hiHead;
}
```

**举例说明**

```java
默认 初始容量 16 ，key = “name” 为例
// 经过计算
hash ： 3373752     //   1100110111101010111000
	 ： 16-1	       //                     1111
桶下标： 8
-- 扩容-----
1、如果 8 位置不是链表，则新桶下标：e.hash & (newCap - 1) =  24
2、如果 8 位置是链表，高位计算判断 						
//   hash: 1100110111101010111000
// newCap: 0000000000000000010000
----------------------------
		   0000000000000000010000   ----> // 非0 ，属于高位
扩容后桶下标：index+oldCap = 8 +16 = 24
```



## 3、并发安全

**线程不安全原因：**
- 多线程下新增可能会被覆盖：两个线程在单链上插入同一个位置时会被覆盖
- 扩容易丢失数据：多个线程同时扩容时，最终只有最后一个线程生成的新数组被赋给table变量，其他线程的均会丢失。
- **HashMap 死循环原理**



**线程安全解决方案**

* 使用集合工具类 Collections.synchronizedMap（list、set 等都有）

- 使用 Hashtable 
- 使用并发包提供的线程安全容器类：比如 **ConcurrentHashMap**



### 1> Collections.synchronizedMap

通过 synchronizedMap() 返回一个 SynchronizedMap对象。 该对象内部维持Map对象进行操作，并使用 synchronized 进行封装，来保证线程安全。

其他Set、ArrayList 都是同理

```java
public static <K,V> Map<K,V> synchronizedMap(Map<K,V> m) {
    return new SynchronizedMap<>(m);
}
private static class SynchronizedMap<K,V>  implements Map<K,V>, Serializable {
    private final Map<K,V> m;     // Backing Map
    final Object      mutex;
    SynchronizedMap(Map<K,V> m) {
        this.m = Objects.requireNonNull(m);
        mutex = this;
    }
    public boolean containsKey(Object key) {
        synchronized (mutex) {return m.containsKey(key);}
    }
    public boolean containsValue(Object value) {
        synchronized (mutex) {return m.containsValue(value);}
    }
    public V get(Object key) {
        synchronized (mutex) {return m.get(key);}
    }
    public V put(K key, V value) {
        synchronized (mutex) {return m.put(key, value);}
    }
}
```



### 2> Hashtable与 HashMap区别

**Hashtable**

1. Hashtable **继承 Dictionary 类**，数据结构与 HashMap 类似，不过 Hashtable 内部维持 Entry 对象，而 在 jdk 1.8 中  HashMap是 Node 对象，不过他们都实现了 Map.Entry
2. **初始容量为 `11`，增长因子为`0.75`，每次扩容为原来的 `2n + 1**`
3. **hashCode直接取的键名的哈希值**，以 (hash & 0x7FFFFFFF) % tab.length 取余作元素对应哈希表索引，将值存储该索引下（Integer.MAX_VALUE = 0x7FFFFFFF ）
4. **key和value都不允许为 NULL ，**
5. **底层数据结构**，synchronized 修饰 put 方法，同一时间只允许一个写线程操作该对象，效率没有ConcurrentHashMap高

```java
public class Hashtable<K,V> extends Dictionary<K,V>
    implements Map<K,V>, Cloneable, java.io.Serializable {
    private transient Entry<?,?>[] table;
    public Hashtable() {
        this(11, 0.75f); // 默认的初始容量为 11，增长因子为0.75
    }
}
```

**Hashtable与 HashMap区别**

* **父类：**Hashtable 继承自`Dictionary`类，而HashMap继承自`AbstractMap`类。但二者都实现了Map接口。
* **线程是否安全**：**Hashtable 支持线程同步**，所有对外方法由synchronized修饰；HashMap可以通过Collections.synchronizedMap(hashMap)来进行处理，或者使用ConcurrentHashMap 
* **Key的空值：**Hashtable 中，key和value都不允许出现null值，HashMap可以由一个null的key，多个null的Value
* **效率**：因为线程安全的问题，HashMap 要比 HashTable 效率高一点。另外，HashTable 基本被淘汰，不要在代码中使用它；
* **哈希值：**HashTable直接使用对象的hashCode。而HashMap重新计算hash值。
* **迭代器：**HashMap的迭代器(**Iterator**)是fail-fast迭代器，而Hashtable的**enumerator**迭代器不是fail-fast的
* **扩容：**Hashtable默认的初始容量为`11`，每次扩充为原来的 `2n + 1`。HashMap默认的初始容量`16`。每次扩充为原来的 `2倍`。



**添加元素源码如下：**

由synchronized 对 put 方法进行加锁。

```java
public synchronized V put(K key, V value) {
    // Make sure the value is not null
    if (value == null) {
        throw new NullPointerException();
    }

    // Makes sure the key is not already in the hashtable.
    Entry<?,?> tab[] = table;
    int hash = key.hashCode();    // 键名不能为空
    int index = (hash & 0x7FFFFFFF) % tab.length;
    @SuppressWarnings("unchecked")
    Entry<K,V> entry = (Entry<K,V>)tab[index];
    for(; entry != null ; entry = entry.next) {
        if ((entry.hash == hash) && entry.key.equals(key)) {
            V old = entry.value;
            entry.value = value;
            return old;
        }
    }
    addEntry(hash, key, value, index);
    return null;
}
private void addEntry(int hash, K key, V value, int index) {
        modCount++;
    Entry<?,?> tab[] = table;
    if (count >= threshold) {
        // Rehash the table if the threshold is exceeded
        rehash();    // 扩容

        tab = table;
        hash = key.hashCode();
        index = (hash & 0x7FFFFFFF) % tab.length;
    }

    // Creates the new entry.
    @SuppressWarnings("unchecked")
    Entry<K,V> e = (Entry<K,V>) tab[index];
    tab[index] = new Entry<>(hash, key, value, e);
    count++;
}
```



**扩容机制**

```java
protected void rehash() {
    int oldCapacity = table.length;
    Entry<?,?>[] oldMap = table;

    // overflow-conscious code
    int newCapacity = (oldCapacity << 1) + 1;    //  扩容倍数 2n + 1
    if (newCapacity - MAX_ARRAY_SIZE > 0) {
        if (oldCapacity == MAX_ARRAY_SIZE)
            return;
        newCapacity = MAX_ARRAY_SIZE;
    }
    Entry<?,?>[] newMap = new Entry<?,?>[newCapacity];

    modCount++;
    threshold = (int)Math.min(newCapacity * loadFactor, MAX_ARRAY_SIZE + 1);
    table = newMap;

    for (int i = oldCapacity ; i-- > 0 ;) {
        for (Entry<K,V> old = (Entry<K,V>)oldMap[i] ; old != null ; ) {
            Entry<K,V> e = old;
            old = old.next;

            int index = (e.hash & 0x7FFFFFFF) % newCapacity;
            e.next = (Entry<K,V>)newMap[index];
            newMap[index] = e;
        }
    }
}
```

---

### 3> ConcurrentHashMap

1. 数据结构与 HashMap 类似，底层通过`数组+链表+红黑树`实现，不过`键值对不支持 NULL`

1. ConcurrentHashMap 使用了 `volatile `来保证哈希表的可见性
2. ConcurrentHashMap 使用`锁分段技术`来保证线程安全，哈希表默认16个桶，代表能同时有16个写线程执行
3. 初始容量为16，增长因子为 0.75，每次扩容增加原理的 2 倍

```java
public class ConcurrentHashMap<K,V> extends AbstractMap<K,V>
implements ConcurrentMap<K,V>, Serializable {
	transient volatile Node<K,V>[] table;
}
```

**效率高的原因**：诸如get、put、remove等常用操作只锁住当前需要用到的桶。这样，原来只能一个线程进入，现在却能同时有16个写线程执行，并发性能的提升是显而易见的。



**ConcurrentHashMap 与HashTable区别**

**相同点**： Hashtable 和 ConcurrentHashMap都是线程安全的； key跟value都不能是null

**区别**： 两者主要是性能上的差异，

* Hashtable中采用的锁机制是一次**锁住整个hash表**，从而在同一时刻**只能由一个线程对其进行操作**；
* ConcurrentHashMap：
    * **在JDK1.7的时候，ConcurrentHashMap（分段锁）** 对整个桶数组进行了分割分段(Segment)，每一把锁只锁容器其中一部分数据，多线程访问容器里不同数据段的数据，就不会存在锁竞争，提高并发访问率。
    * **到了 JDK1.8 的时候已经摒弃了Segment的概念，而是直接用 Node 数组+链表+红黑树的数据结构来实现，并发控制使用 synchronized 和 CAS 来操作。**

![687474707337](assets/687474707337.jpg)

![1554616165](assets/1554616165.png)

**添加元素源码如下：**

```java
public V put(K key, V value) {
    return putVal(key, value, false);
}
final V putVal(K key, V value, boolean onlyIfAbsent) {
    // 所以键值对都不能为空
    if (key == null || value == null) throw new NullPointerException();  
    
    int hash = spread(key.hashCode());  // (h ^ (h >>> 16)) & HASH_BITS
    
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();		// 懒加载 初始化
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value, null)))
                break;                  
        }
        else if ((fh = f.hash) == MOVED)   // 集合对象正在扩容时，先协助扩容，再更新值
            tab = helpTransfer(tab, f);
        else { 	// hash 碰撞
            V oldVal = null;
            // - --------- 重点---------------
            synchronized (f) {   //  分段锁，对哈希表中的Node节点加锁
                if (tabAt(tab, i) == f) {
                    if (fh >= 0) {
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            if (e.hash == hash &&  // 节点存在,即替换链表该节点的值
                                ((ek = e.key) == key || (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent) // 替换
                                    e.val = value;
                                break;
                            }
                            Node<K,V> pred = e;
                            if ((e = e.next) == null) {  // 节点不存在,即添加数据到链表尾部
                                pred.next = new Node<K,V>(hash, key, value, null);
                                break;
                            }
                        }
                    }
                    else if (f instanceof TreeBin) {  // 红黑树存储
                        Node<K,V> p;
                        binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key, value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                }
            }
            if (binCount != 0) {
                if (binCount >= TREEIFY_THRESHOLD)   //链表节点长度超过8，转为红黑树存储
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);  // 利用CAS更新baseCount 
    return null;
}
```

---

## 4、遍历方式

*   通过Map#keySet() 获取键值Set集合，遍历 key 获取 value 
*   通过Map#entrySet().iterator() 获取迭代器对象iterator ，通过迭代器获取 Entry对象。然后获取key和value
*   通过Map#entrySet() 获取Entry对象集合，遍历Entry对象集合，通过Entry 获取key和value
*   通过Map#values() 获取所有的 value 集合，但不能遍历key

```java
 // 1. 通过Map.keySet遍历key和value
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

# 五、源码分析--HashSet

HashSet 底层就是基于 HashMap 实现的，内部维持了一个HashMap 对象，新增元素通过HashMap对象的 put(K key, V value) 方法，存放一个Object对象，因此 HashSet 的原始是否为 NULL 和扩容机制都取决于 HashMap 特性。

**因此，HashSet 的初始容量 16，默认增长因子 0.75，元素允许一个 NULL**

```java 
public class HashSet<E> extends AbstractSet<E> implements Set<E>, Cloneable, java.io.Serializable
    private transient HashMap<E,Object> map;
    private static final Object PRESENT = new Object();
    public boolean add(E e) {
        return map.put(e, PRESENT)==null;
    }
}
```



HashSet如何检查重复：

*   计算对象的hashcode值来判断对象加入的位置
*   如果发现有相同hashcode值的对象，这时会调用equals（）方法来检查hashcode相等的对象是否真的相同。如果两者相同，HashSet就不会让加入操作成功