---
typora-root-url: Java-集合篇（5）集合之Map
---



## HashMap

基于**哈希表实现**。底层用**数组+单向链表**（1.8增加了**黑红树**）存储，内部包含了一个 Node 类型的数组 table。 每个 Node 节点有4个属性：`hash、key、value 、next`

HashMap 非线程安全。如果需要满足线程安全，可以用 Collections 的 synchronizedMap 方法使HashMap 具有线程安全的能力，或者使用 ConcurrentHashMap。



**HashMap为什么不直接使用数组，还需要使用HashSet呢？**

因为数组元素的索引是连续的，而数组的长度是固定的，无法自由增加数组的长度。而HashSet就不一样了，HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加长度，并可以根据元素的hashCode值来访问元素。

**HashMap线程不安全原因**

*   多线程下新增可能会被覆盖：两个线程在单链上插入同一个位置时会被覆盖
*   扩容易丢失数据：多个线程同时扩容时，最终只有最后一个线程生成的新数组被赋给table变量，其他线程的均会丢失。

*   **HashMap 死循环原理**，可能在链表上，链表最后一个元素指向了链表表头，形成循环





## HashMap存储方式

HashMap 是以 数组 + 双向链表 + 红黑树

*   不发生 hash 碰撞时以数组存储
*   发生 hash 碰撞，且链表长度小于 8 ，以链表存储
*   发生 hash 碰撞，且链表长度大于等于 8 ，转为红黑树存储，（JDK 1.8 新增的 ）

所谓 **“拉链法”** 就是：将链表和数组相结合。也就是说创建一个链表数组，数组中每一格就是一个链表。若遇到哈希冲突，则将冲突的值加到链表中即可



**JAVA7 实现** 

HashMap 里面是一个数组，然后数组中每个元素是一个单向链表。下图中，每个绿色的实体是嵌套类 Entry 的实例，时间复杂度为 **O(n)**，取决于链表的长度。

1.  capacity：当前数组容量，始终保持 2^n，可以扩容，**扩容后数组大小为当前的 2 倍**。

2.  loadFactor：负载因子，默认为 0.75。

3.  threshold：扩容的阈值，等于 capacity * loadFactor

![Java7 HashMap 存储机制](clipboard-1578149439454.png)



**JAVA8实现** 

Java8 对 HashMap 进行了一些修改，最大的不同就是利用了红黑树，所以其由 **数组+链表+红黑树** 组成。

在 Java8 中，当发生 hash 碰撞的时候，以链表的形式进行存储，当链表中的元素超过了 **8 个**以后，会将链表转换为红黑树，在这些位置进行查找的时候可以降低**时间复杂度为 O(logN)**。

![Java8 HashMap 存储机制](clipboard-1578149421429.png)



## ConcurrentHashMap	

整个 ConcurrentHashMap 由一个个 Segment 组成，Segment 代表”部分“或”一段“的意思，所以很多地方都会将其描述为**分段锁，线程安全（Segment 继承 ReentrantLock 加锁）**

并行度（默认 16），也就是说 ConcurrentHashMap 有 16 个 Segments，，所以理论上，这个时候，最多可以同时支持 16 个线程并发写

![Java8 ConcurrentHashMap	存储](clipboard-1578149537394.png)





## HashTable

**是线程安全的**，任一时间只有一个线程能写 Hashtable，并发性不如 ConcurrentHashMap，因为 ConcurrentHashMap 引入了分段锁。

Hashtable 不建议在新代码中使用，不需要线程安全的场合可以用 HashMap 替换，需要线程安全的场合可以用 ConcurrentHashMap 替换。





## TreeMap

**可排序**，TreeMap 实现 SortedMap 接口，能够把它保存的记录根据键排序，**默认是按键值的升序排序**，也可以指定排序的比较器，当用 Iterator 遍历 TreeMap 时，得到的记录是排过序的。如果使用排序的映射，建议使用 TreeMap。



## LinkHashMap(记录插入顺序）

LinkedHashMap 是 HashMap 的一个子类，保存了记录的插入顺序，在用 Iterator 遍历

LinkedHashMap 时，先得到的记录肯定是先插入的，也可以在构造时带参数，按照访问次序排序。



## Map遍历方式

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

