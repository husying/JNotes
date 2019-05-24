# 集合

# 一、集合框架

## 1、集合关系

Java集合类存放于 java.util 包中，是一个用来存放对象的容器。

* Collection：
  * List：ArrayList、LinkedList、Vector（Stack）
  * Set：HashSet、TreeSet
  * Queue：Deque
* Map：HashMap、TreeMap、LinkedHashMap



## 2、Collection 接口

**List**

特点：**排列有序，可重复，允许多个NULL**

* ArrayList：基于`动态数组`实现，读取速度快，增删慢；

* Vector：和 ArrayList 类似，但它是`线程安全`的

* LinkedList：基于`双向链表`实现，只能顺序访问，所以`查询速度慢`，但`插入和删除元素快`。不仅如此，LinkedList 还可以用作栈、队列和双向队列。

  

**Set**

特点：唯一，不重复

* **HashSet**：基于`哈希表`实现、`无序`，值允许为 null ，查找的时间复杂度为 O(logN)

* **TreeSet**：基于`红黑树`实现、`自然序`，值不为 null 值，查找的时间复杂度为 O(1)

* **LinkedHashSet**：具有 HashSet特性，增加`双向链表`维持元素的顺序，有序(`插入顺序`)

  

**Queue**

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
* **TreeMap**：基于`红黑树`实现。`自然序`，键值键名都不能为空。
* **LinkedHashMap**：拥有 HashMap 的所有特性，增加了`双向链表`维持元素的顺序，有序(`插入顺序`)

TreeMap 不能为空，键名为 null 会抛异常

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
* 使用java.util.concurrent 提供的并发集合对象，其提供了映射 、 有序集和队列的高效实现  **ConcurrentHashMap** 、**CopyOnWriteArrayList**、CopyOnWriteArraySet、ConcurrentSkipListMap（SkipList：跳表）、 ConcurrentSkipListSet 和 ConcurrentLinkedQueue



注释 ： 有些应用使用庞大的并发散列映射 ， 这些映射太过庞大 ， 以至于无法用 size 方法得到它的大小，因为这个方法只能返回 int。 对于一个包含超过20 亿条目的映射该如何处理 ？ **JavaSE 8 引入了一个 mappingCount 方法可以把大小作为 long 返回。**



**ArrayList** ：

* 使用 `Collections.synchronizedList();` 得到一个线程安全的 ArrayList。
* 使用 `CopyOnWriteArrayList`代替：读写分离的安全型并发集合对象，写操作需要加锁，防止并发写入时导致写入数据丢失。写操作在一个复制的数组上进行，读操作还是在原始数组中进行，读写分离，互不影响。写操作结束之后需要把原始数组指向新的复制数组。
  * 使用场景：适合读多写少的应用场景。
  * 缺点 1 ：内存占用：在写操作时需要复制一个新的数组，使得内存占用为原来的两倍左右；
  * 缺点 1 ：数据不一致：读操作不能读取实时性的数据，因为部分写操作的数据还未同步到读数组中。

```java
// 读操作
private E get(Object[] a, int index) {
    return (E) a[index];
}
// 写操作
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
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



---

# 二、源码分析--ArrayList

```java 
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```

**ArrayList 底层使用`数组`存储；数组的默认大小为 `10`。排列有序，可重复，允许多个NULL1、访问效率快**。Vector 同理

```java
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
```



**读取速度快**：数组有索引的存在，读取速度快，（RandomAccess支持快速（通常为恒定时间）随机访问）

**增删速度慢**：增删操作会对数组位移操作，即改变对象的索引，所以速度较慢；

```java
public E remove(int index) {
        rangeCheck(index);
        modCount++;
        E oldValue = elementData(index);
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,  numMoved);   //  这行影响速率
    	elementData[--size] = null; // clear to let GC do its work
        return oldValue;
    }
```

**System.arraycopy的函数原型**

调用 System.arraycopy() 将 index+1 后面的元素都复制到 index 位置上，该操作的时间复杂度为 O(N)，可以看出 ArrayList 删除元素的代价是非常高的。

```java
public static void arraycopy(
    Object src, 	//  表示源数组
    int srcPos, 	//  表示源数组要复制的起始位置
    Object dest,	//	表示目标数组
    int destPos,	//  目标数组要复制的起始位置
    int length)		//  表示要复制的长度
```

**添加或删除数据为什么LinkedList 比ArrayList 效率高**

* 在添加或删除数据的时候，ArrayList经常需要复制数据到新的数组，LinkedList只需改变节点之间的引用关系

---

## 2、 扩容机制

### **1> ArrayList**

* **默认初始容量10**，容量扩大为原来的**1.5倍**，
* 再判读，如果容量任然小于数组大小、**就直接为数组最小容量**，
* 再判读此时minCapacity大于MAX_ARRAY_SIZE，则返回Integer的最大值。否则返回MAX_ARRAY_SIZE（MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8）

```java
private static final int DEFAULT_CAPACITY = 10;  // 默认初始容量10
private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8; // 最大数组大小
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
private static int calculateCapacity(Object[] elementData, int minCapacity) {
    if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
        return Math.max(DEFAULT_CAPACITY, minCapacity);
    }
    return minCapacity;
}
private void ensureCapacityInternal(int minCapacity) {
    ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
}
private void ensureExplicitCapacity(int minCapacity) {
    modCount++;
    // overflow-conscious code
    if (minCapacity - elementData.length > 0)
        grow(minCapacity);
}
private void grow(int minCapacity) {
    // overflow-conscious code
    int oldCapacity = elementData.length;
    int newCapacity = oldCapacity + (oldCapacity >> 1);		//  >>1  相当于除 2
    if (newCapacity - minCapacity < 0)
        newCapacity = minCapacity;
    if (newCapacity - MAX_ARRAY_SIZE > 0)
        newCapacity = hugeCapacity(minCapacity);
    // minCapacity is usually close to size, so this is a win:
    elementData = Arrays.copyOf(elementData, newCapacity);
}
private static int hugeCapacity(int minCapacity) {
    if (minCapacity < 0) // overflow
        throw new OutOfMemoryError();
    return (minCapacity > MAX_ARRAY_SIZE) ? Integer.MAX_VALUE :  MAX_ARRAY_SIZE;
}
```



------

### **2> Vectot**

Vector 基本与ArrayList类似，数组存储，排列有序，可重复，允许多个NULL1、访问效率比ArrayList稍慢，因为**`Vector是同步的，线程安全`**，它有对外方法都由 synchronized 修饰。

Vectot的扩容：默认初始容量`10`，可以通过构造器指定的初始容量和容量增量，每次增加 **`2 倍`**

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

---

## 3、集合排序

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
ArrayList#sort(new Comparator<Student>() {
    @Override
     public int compare(Student s1, Student s2) {
        return s1.getAge() - s2.getAge();
    }
});
```



---

## 4、List 和Array转换

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

## 5、ArrayList 去重

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

# 三、源码分析--HashMap

基于`哈希表实现`。底层用`数组+单向链表`（1.8增加了`黑红树`）存储。`无序`，键名唯一，可为 NULL；键值可重复，可为 NULL

```java
public class HashMap<K,V> extends AbstractMap<K,V> implements Map<K,V>, Cloneable, Serializable 
```

## 1、存储机制

HashMap 以键值对方式存储，**内部包含了一个 Node 类型的数组 table。**

每个 Node 节点有4个属性：**hash、key、value 、next**

数组中的每个位置被当成一个桶，一个桶存放一个链表。当发生 hash 碰撞的时候，以链表的形式进行存储

```java
transient Node<K,V>[] table;

static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;
    final K key;
    V value;
    Node<K,V> next; 
}
```

### 1> Key 为空值原来

计算key的hash值时，会判断是否为 NULL

```java
 static final int hash(Object key) {
     int h;
     return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
 }    
```

### 2> hashCode 作用

* hash 算法可以直接根据元素的 hashCode 值计算出该元素的存储位置从而快速定位该元素
* 如果两个对象相同，就是适用于equals(java.lang.Object) 方法，那么这两个对象的hashCode一定要相同
* **为什么不直接使用数组，还需要使用HashSet呢？**
  * 因为数组元素的索引是连续的，而数组的长度是固定的，无法自由增加数组的长度。而HashSet就不一样了，HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加长度，并可以根据元素的hashCode值来访问元素。

### 3> Hash 碰撞处理

* JDK7 中，当发生hash碰撞的时候，以链表的形式进行存储。
* JDK8中**增加了黑红树**的使用。当一个hash碰撞的次数超过指定次数(常量8次)的时候，将转换为红黑树结构

```java
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}
// 计算键名的哈希值
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length;  //  集合大小为 0 时会初次扩容resize()
    if ((p = tab[i = (n - 1) & hash]) == null)  // 判读是否发生 hash 碰撞，数组索引为 (n - 1) & hash  
        tab[i] = newNode(hash, key, value, null);	// 不发生 hash 碰撞，以数组存储
    else {
        Node<K,V> e; K k;
        if (p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k))))
            e = p;
        else if (p instanceof TreeNode)  // 判读是否是树节点
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value); 	// 红黑树存储
        else {
            // 链表插入 ----start
            for (int binCount = 0; ; ++binCount) {
                if ((e = p.next) == null) {
                    p.next = newNode(hash, key, value, null);	// 链表存储
                    //  static final int TREEIFY_THRESHOLD = 8; 链表长度
                    if (binCount >= TREEIFY_THRESHOLD - 1) // 判读链表长度是否大于 8 
                        treeifyBin(tab, hash);	//  转换 Node 节点为 TreeNode 节点
                    break;
                }
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    break;
                p = e;
            }
            // 链表插入 ----end
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
    if (++size > threshold) // 是否扩容判断，阀值threshold = 初始容量 * 负载因子
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



## 2、扩容机制

初始容量：容量是哈希表中桶的数量

加载因子：默认0.75，是哈希表在其容量自动增加之前可以达到多满的一种尺度



**HashMap 是以当前容量的 1.5 倍增加。**

**JDK 8 源码分析**：

- **初始容量**：`默认 16`
- **负载因子**：`默认 0.75`
- **初始阀值**：`初始容量 * 负载因子`  (16 * 0.75 = 12)
- **扩容倍数**：`2 倍`
- **容量范围**：`16 < 容量 < MAXIMUM_CAPACITY`（2^30^），超出默认为 `Integer.MAX_VALUE` ( 2^31^-1)



**扩容步骤：**

**第一步：**

1. 如果：原容量大于 0 的情况下，
   * 比较原容量是否超出`最大容量`，是设置**阀值**为 `Integer.MAX_VALUE`，并返回当前 哈希表 table
   * 否则，设置**新容量为原来 2 倍 **，再判断此时新容量是否在`容量范围`中，是，则**新阀值为原来 2 倍**
2. 如果：原容量等于 0 ，但阀值大于 0  的情况下， 设置**容量等于阀值**。 这种情况是在 new HashMap(0) 时，经tableSizeFor()计算得阀值会为 1。
3. 在 1,2 不满足的情况下，直接**设置默认初始容量和阀值**

**第二步**：在判断阀值是否为 0，是 ，则当前容量设置阀值为 **容量 * 负载因子** ，或者为 `Integer.MAX_VALUE`

**第三步**：new 一个新的哈希表，复制数据到新哈希表

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
        // 扩容大小为 << 1 ，2 倍 相等乘 2 
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
                else { // preserve order
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



## 3、并发问题原理

**线程不安全原因：**

- HashMap多线程，put 时已被覆盖
  - 两个线程在单链上插入同一个位置时会被覆盖
- HashMap扩容易丢失数据
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

## 3、遍历方式

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

## 3、HashSet

HashSet 内部维持了一个HashMap 对象，新增元素通过HashMap对象的 put(K key, V value) 方法，存放一个Object对象，因此 HashSet 的原始是否为 NULL 和扩容机制都取决于 HashMap 特性。

**HashSet 的初始容量 16，默认增长因子 0.75，元素允许一个 NULL**

```java 
public class HashSet<E> extends AbstractSet<E> implements Set<E>, Cloneable, java.io.Serializable
    private transient HashMap<E,Object> map;
    private static final Object PRESENT = new Object();
    public boolean add(E e) {
        return map.put(e, PRESENT)==null;
    }
}
```

**构造方法：**

```java
public HashSet()//默认初始容量是 16，加载因子是 0.75。
public HashSet(Collection<? extends E> c) //默认的加载因子 0.75 ;collection 中所有元素的初始容量来创建 HashMap。 
public HashSet(int initialCapacity)//底层 HashMap 实例具有指定的初始容量和默认的加载因子（0.75）
public HashSet(int initialCapacity, float loadFactor)    //指定的初始容量和指定的加载因子
```

---

## 4、HashTable 

将Key通过哈希函数转换成一个整型数字，然后用该数字除以数组长度进行取余，取余结果就当作数组的下标，将value存储在下标对应的数组空间里。

**Hashtable 继承于Dictionary，实现了Map，支持线程同步，key和value都不允许出现null值**



**key和value都不允许出现null值**

* 在put时 会判读value是否为空，为空抛出异常；
* 由于直接获取哈希值（int hash = key.hashCode();）如果此处key为null，则直接抛出空指针异常。



**Hashtable与 HashMap区别**

* **父类：**Hashtable 继承自Dictionary类，而HashMap继承自AbstractMap类。但二者都实现了Map接口。
* **同步方式：**Hashtable 支持线程同步，所有对外方法由synchronized修饰；HashMap可以通过Collections.synchronizedMap(hashMap)来进行处理
* **Key的空值：**Hashtable 中，key和value都不允许出现null值，HashMap可以由一个null的key，多个null的Value
* **哈希值：**HashTable直接使用对象的hashCode。而HashMap重新计算hash值。
* **迭代器：**HashMap的迭代器(**Iterator**)是fail-fast迭代器，而Hashtable的**enumerator**迭代器不是fail-fast的
* **扩容：**Hashtable默认的初始大小为11，之后每次扩充，容量变为原来的2n+1。HashMap默认的初始化大小为16。之后每次扩充，容量变为原来的2倍。

---

# 四、源码分析--LinkedList

LinkedList 基于`双向链表`实现、使用 Node 存储链表节点信息。通过以一系列节点对象 Node 实现，每个节点都有一个前一个节点和下一个节点的引用节点，以及项目。当您在列表中插入空值时，您将 item 为 null节点，但 next 和 prev 指针是非空的，因此：**`可以有个 null 值`**

JDK 8 源码：

```java
public class LinkedList<E> extends AbstractSequentialList<E> implements List<E>, Deque<E>, Cloneable, java.io.Serializable{
    transient int size = 0;
    transient Node<E> first;
    transient Node<E> last;
    
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



