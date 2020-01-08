---
typora-root-url: Java-集合篇（3）集合之Set
---



# HashSet

基于**哈希表**实现，哈希表边存放的是哈希值。是**无序存储**，其存储元素的顺序并不是按照存入时的顺序（和 List 显然不同） 而是按照哈希值来存的所以取数据也是按照哈希值取得。

**HashSet 首先判断两个元素的哈希值，如果哈希值一样，接着会比较equals 方法 如果 equls 结果为 true ，HashSet 就视为同一个元素。如果 equals 为 false 就不是同一个元素。**



**问题**：哈希值相同 equals 为 false 的元素是怎么存储呢？

HashSet 通过 hashCode 值来确定元素在内存中的位置。一个 hashCode 位置上可以存放多个元素。底层其实是数组+单向链表实现，如图：

![hashcode实现](clipboard-1578149491166.png)



**hashCode 作用**

*   hash 算法可以直接根据元素的 hashCode 值计算出该元素的存储位置从而快速定位该元素
*   如果两个对象相同，就是适用于 equals() 方法，那么这两个对象的hashCode一定要相同





# TreeSet

基于**红黑树**实现，是使用二叉树的原理对新 `add()` 的对象按照**指定的顺序排序（升序、降序）**，每增加一个对象都会进行排序，将对象插入的二叉树指定的位置。

Integer 和 String 对象都可以进行默认的 TreeSet 排序，而自定义类的对象是不可以的，自己定义的类必须**实现 Comparable 接口，并且覆写相应的 compareTo()函数**，才可以正常使用。



# LinkHashSet

**通过继承与 HashSet、又基于 LinkedHashMap 来实现的。加双向链表维持元素的顺序，有序(`插入顺序`)**

底层使用 LinkedHashMap 来保存所有元素，它继承与 HashSet，其所有的方法操作上又与 HashSet 相同

