# ArrayList

## 存储机制

基于**动态数组**实现，**默认长度 10** ；因为数组特性，其读取速度快，增删效率慢

因为写入或读取都是通过数组索引直接操作，所以，**允许为 null 值， 且可以重复**

当数组大小不满足时需要增加存储能力，就要将已经有数组的数据复制到新的存储空间中。当从 ArrayList 的中间位置插入或者删除元素时，需要对数组进行复制、移动、代价比较高。

因此，它**适合随机查找和遍历，不适合插入和删除。**





## 类定义

在 jdk 8 中源码如下

```java
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable{
    private static final int DEFAULT_CAPACITY = 10;  // 默认大小为 10
    transient Object[] elementData;  //  数组存储
    private int size;
}
```

ArrayList 实现了`RandomAccess` 接口， `RandomAccess` 是一个标志接口，表明实现这个这个接口的 List 集合是支持**快速随机访问**的。在 ArrayList 中，我们即可以通过元素的序号快速获取元素对象，这就是快速随机访问。

ArrayList 实现了`Cloneable` 接口，即覆盖了函数 clone()，**能被克隆**。

ArrayList 实现`java.io.Serializable` 接口，这意味着ArrayList**支持序列化**，**能通过序列化去传输**。



## get()方法

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

通过以上代码可以看出，ArrayList  通过索引读取元素，所以其读取元素效率高



## add()方法

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

通过以上代码发现，添加元素时会触发扩容机制，当集合扩容时采用的是`Arrays.copyOf(elementData, newCapacity)`，因此造成了新增元素速度慢



## remove()方法

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

删除方法同样进行了数组复制，所以效率同样不高



## grow()方法

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

* 1、默认**初始容量 10**，如果数据长度超过，则容量扩大为原来的 **1.5倍**，
* 2、然后会再判断，扩容后的容量大小是否任然小于数据长度、是则，取为数据大小为最新容量大小
* 3、再判断此时的最新容量大小是否超过最大容量值 `MAX_ARRAY_SIZE`，
* 4、是则，判断数据大小是否超过最大容量值 ，
    * 数据大小超过最大容量，则取 Integer 的最大值作为最新容量大小。
    * 数据大小没有最大容量，则取最大容量作为最新容量大小。



## 线程安全

**ArrayList 线程不安全原因**：使用数组存储，当前多线程时，当对同一位置操作时，可能会被覆盖，或者读取到了未更新的数据等一系列问题。

**线程安全解决方案**

*   使用 `Collections.synchronizedList();` 得到一个线程安全的 ArrayList。
*   使用 `CopyOnWriteArrayList`代替：读写分离的安全型并发集合对象，写操作需要加锁，防止并发写入时导致写入数据丢失。写操作在一个复制的数组上进行，写操作结束之后需要把原始数组指向新的复制数组。读操作还是在原始数组中进行，读写分离，互不影响。



使用场景：适合读多写少的应用场景。

*   缺点 1 ：内存占用：在写操作时需要复制一个新的数组，使得内存占用为原来的两倍左右；
*   缺点 2 ：数据不一致：读操作不能读取实时性的数据，因为部分写操作的数据还未同步到读数组中。



## List 和Array转换

**List 转Array**：使用 `list.toArray()`

**Array 转 List**：使用 `Arrays.asList(array)`

```java
//List 转Array
List<String> list = new ArrayList<String>();
Object[] array=list.toArray();

//Array 转 List
// 方式 1
List<String> list = Arrays.asList(array);  // 有缺陷
// 方式 2
List<String> list = new ArrayList<String>(Arrays.asList(array));
// 方式 3
List<String> list = new ArrayList<String>(array.length);
Collections.addAll(list, array);
```

**注意**：**Arrays.asList(array) 不能作为一个 List 对象的复制操作**

因为：方式 1 中 只是复制了引用，list 修改会改变 array 内容，因为返回的 list 是 Arrays 里面的一个静态内部类，该类并未实现add、remove方法，因此在使用时存在局限性

所以，一般使用第 2 中和第 3 种方式转换

```java
String[] arr = {"1","2","3","4","5"};
List<String> list1 = new ArrayList<String>(Arrays.asList(arr));
List<String> list2 = Arrays.asList(arr);  
List<String> list3 = new ArrayList<String>(arr.length);
Collections.addAll(list3, arr);

list1.set(0, "a");
System.out.println("Array:"+Arrays.toString(arr));
System.out.println("List :"+list1.toString());
System.out.println();


list2.set(0, "b");
System.out.println("Array:"+Arrays.toString(arr));
System.out.println("List :"+list2.toString());
System.out.println();

list3.set(0, "c");
System.out.println("Array:"+Arrays.toString(arr));
System.out.println("List :"+list3.toString());
```

执行结果：

```java
Array:[1, 2, 3, 4, 5]
List :[a, 2, 3, 4, 5]

Array:[b, 2, 3, 4, 5]
List :[b, 2, 3, 4, 5]

Array:[b, 2, 3, 4, 5]
List :[c, 2, 3, 4, 5]
```





## ArrayList 去重

*   双重for循环去重
*   通过set集合判断去重,不打乱顺序
*   遍历后以 contains() 判断赋给另一个list集合
*   set和list转换去重

```java
//双重for循环去重
for (int i = 0; i < list.size() - 1; i++) {
    for (int j = list.size() - 1; j > i; j--) {
        if (list.get(j).equals(list.get(i))) {
            list.remove(j);
        }
    }
}

//set集合判断去重,不打乱顺序
List<String> listNew=new ArrayList<>();
Set set=new HashSet();
for (String str:list) {
    if(set.add(str)){  //HashSet 内部维持map,其键唯一
        listNew.add(str);
    }
}
```



## ArrayList 排序

可以使用如下方式

1.  对象实现 `Comparable` 接口，
2.  使用 `Collections.sort`（List list, Comparator<? super T> c），
3.  使用 `ArrayList#sort`(Comparator<? super E> c)

前一种：**重写 compareTo(T o) 方法** ，后两种：通过**匿名内部类**的方式**实现比较器 Comparator 接口**，重写compare(T o1, T o2)

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



# Vector

同样基于**动态数组**实现，但它是**线程安全**的，它支持线程的同步，但实现同步需要很高的花费，

因此，**访问它比访问 ArrayList 慢**。



# LinkedList

基于**双向链表**实现，只能顺序访问

因此，**很适合数据的动态插入和删除，随机访问和遍历速度比较慢**。

另外，他还提供了 List 接口中没有定义的方法，专门用于操作表头和表尾元素，可以当作堆栈、队列和双向队列使用。



# List 之间的区别

## ArrayList 和 Vector 的

*   Vector 基本与ArrayList类似，数组存储，排列有序，可重复，允许多个NULL1、
*   访问效率比ArrayList稍慢，因为**`Vector是同步的，线程安全`**，它有对外方法都由 synchronized 修饰。

**为什么要用Arraylist取代Vector呢**

*   Vector类的所有方法都是同步的。可以由两个线程安全地访问一个Vector对象、但是一个线程访问Vector的话代码要在同步操作上耗费大量的时间。
*   Arraylist不是同步的，所以在不需要保证线程安全时时建议使用Arraylist。



## Arraylist 与 LinkedList 区别

*   **线程安全：** ArrayList 和 LinkedList 都是不同步的，也就是不保证线程安全；
*   **底层数据结构**：Arraylist 底层使用的是数组；LinkedList 底层使用的是双向链表数据结构
*   **插入和删除是否受元素位置的影响**
    *   ArrayList 采用数组存储，所以插入和删除元素的时间复杂度受元素位置的影响，时间复杂度就为 O(n-i)
    *   LinkedList 采用链表存储，所以插入和删除元素时间复杂度不受元素位置的影响，都是近似 O(1）而数组为近似 O(n）
*   **是否支持快速随机访问：** LinkedList 不支持高效的随机元素访问，而 ArrayList 支持。快速随机访问就是通过元素的序号快速获取元素对象(对应于`get(int index) `方法)。

