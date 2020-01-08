---
typora-root-url: JVM（4）GC调优
---



JVM 的定位系统问题时，知识和经验是关键基础，数据是依据、工具是运用知识处理数据的手段

数据包括：运行日志、异常堆栈、GC日志、线程快照（thread dump、javacore文件）、堆转储快照（headdump / hprof 文件）



# 调优命令

JDK监控和故障处理命令，在bin目录下有：**jps、 jstat、jmap、jhat、jstack、jinfo**

*   jps：显示虚拟机进程，常用如：`jps -l -v `
*   jstat：收集虚拟机各方面的运行数据，常用如：`jps-gcutil 2764`、`jstat  -gc 2764 250 20`
*   jinfo：显示虚拟机配置信息
*   jmap：生成虚拟机内存转储快照（headdump 文件），常用如：`jmap -dump:live,format=b,file=dump.hprof 28920`
*   jhat：用于分析headdump 文件，他会建立一个http/html 的服务器，让客户可以在浏览器上查看分析结果，常用如：`jhat  dump.hprof`
*   jstack： 显示虚拟机线程快照，常用如：` jstack -l 11494`



下面做一 一介绍

#  jps 

 显示指定系统内所有的HotSpot虚拟机进程，

格式 ：

>    jps -<option>  [hostid]

options 参数：

```bash
  -q：只输出LVMID，省略主类的名称
  -m：输出新建启动时传递给主类main()函数的参数
  -l：输出主类的全名，如果进程执行的是Jar包，输出Jar路径
  -v：输出虚拟机进程启动时JVM参数
 
```

 其中[option]、[hostid]参数也可以不写

一般使用：

>   jps -l -m



#  jstat

用于监视虚拟机运行时状态信息的命令，它可以显示出虚拟机进程中的类装载、内存、垃圾收集、JIT编译等运行数据。

格式 

>    jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]

*   vmid： 进程号，interval 和count ：表示查询间隔和次数
*   options 参数如下

```bash
-class：监视类装载、卸载熟练、总空间以及类装载所消耗的时间
-gc ： 监视堆状况，包括Eden区、两个survivor区、老年代、永久代等容量、已用空间和GC 时间合计等信息
-gccapacity：监视内容和 -gc基本相同，但输出主要关注堆各个区域使用到最大，最小空间
-gcutil：监视内容和 -gc基本相同，但输出主要关注已使用空间占总空间的百分比
-gccause：与 -gcutil一样，额外输出导致上次GC产生的原因
-gcnew：监视新生代GC状况
-gcnewcapacity：监视内容和 -gcnew 基本相同，输出输出主要关注使用到的最大、最小空间
-gcold：监视老年代GC状况
-gcoldcapacity：监视内容和 -gcold 基本相同，输出输出主要关注使用到的最大、最小空间
-gcpermcapacity：输出永久代使用的最大、最小空间
-compiler：输出JIT 编译期编译过的方法、耗时等信息
-printcompilation：输出已经被JIT编译的方法
```

一般使用：

>   jps-gcutil 2764    //输出的是已使用空间占总空间的百分比
>
>   jstat  -gc 2764 250 20     //每隔250ms输出2764的gc情况，一共输出20次





# jinfo 

作用是实时查看和调整虚拟机运行参数。 之前的jps -v口令只能查看到显示指定的参数，如果想要查看未被显示指定的参数的值就要使用jinfo口令

格式 

>    jinfo  [option vmid]

vmid： 进程号

option参数

```bash
-flag : 输出指定args参数的值
-flags : 不需要args参数，输出所有JVM参数的值
-sysprops : 输出系统属性，等同于System.getProperties()
```

一般使用：`jinfo  -flag 11494`

# jmap 

**用于生成heap dump文件**，如果不使用这个命令，还阔以使用-XX:+HeapDumpOnOutOfMemoryError参数来让虚拟机出现OOM的时候·自动生成dump文件。

 jmap不仅能生成dump文件，还阔以查询finalize执行队列、Java堆和永久代的详细信息，如当前使用率、当前使用的是哪种收集器等。

格式 

>    jmap  -<option>  [vmid] 

option 参数

```bash
-dump : 生成堆转储快照
-finalizerinfo : 显示在F-Queue队列等待Finalizer线程执行finalizer方法的对象
-heap : 显示Java堆详细信息
-histo : 显示堆中对象的统计信息
-permstat : to print permanent generation statistics
-F : 当-dump没有响应时，强制生成dump快照
```

一般使用 :

>    jmap -dump:live,format=b,file=dump.hprof 28920

dump堆到文件，format指定输出格式，live指明是活着的对象，file指定文件名

dump.hprof这个后缀是为了后续可以直接用MAT(Memory Anlysis Tool)打开。





#  jhat 

用来分析jmap生成的dump；与jmap搭配使用；jhat内置了一个微型的HTTP/HTML服务器，生成dump的分析结果后，可以在浏览器中查看。

在此要注意，一般不会直接在服务器上进行分析，因为jhat是一个耗时并且耗费硬件资源的过程，一般把服务器生成的dump文件复制到本地或其他机器上进行分析。

格式 

>   jhat [dumpfile] 





# jstack

用于生成java虚拟机当前时刻的线程快照。线程快照是当前java虚拟机内每一条线程正在执行的方法堆栈的集合，**生成线程快照的主要目的是定位线程出现长时间停顿的原因**，如线程间死锁、死循环、请求外部资源导致的长时间等待等。 如果java程序崩溃生成core文件，jstack工具可以用来获得core文件的java stack和native stack的信息，从而可以轻松地知道java程序是如何崩溃和在程序何处发生问题。另外，jstack工具还可以附属到正在运行的java程序中，看到当时运行的java程序的java stack和native stack的信息, 如果现在运行的java程序呈现hung的状态，jstack是非常有用的。

格式 

>   jstack [option] LVMID

option参数

```bash
-F : 当正常输出请求不被响应时，强制输出线程堆栈
-l : 除堆栈外，显示关于锁的附加信息
-m : 如果调用到本地方法的话，可以显示C/C++的堆栈
```

一般使用：

>   jstack -l 11494

分析：这里有一篇文章解释的很好 [分析打印出的文件内容](http://www.hollischuang.com/archives/110)



# 调优工具

##  jconsole

*   jdk /bin 目录下，单机jconsole.exe 启动启动
*   自动搜索本机运行的所有虚拟机进程，不需要用户自己在使用jps 来查询



GChisto是一款专业分析gc日志的工具，可以通过gc日志来分析：Minor GC、full gc的时间、频率等等，通过列表、报表、图表等不同的形式来反应gc的情况。

GC Easy：推荐此工具进行gc分析；这是一个web工具,在线使用非常方便，进入官网，讲打包好的zip或者gz为后缀的压缩包上传，过一会就会拿到分析结果。

[GC Easy官网地址](http://gceasy.io)



##  VisualVM

jdk 集成的分析工具，在jdk /bin 目录下，单机jvisualvm.exe 启动

##  Oracle Java Mission Control

jdk 集成的分析工具，在jdk /bin 目录下，单机jmc.exe 启动





# 常见问题分析

## 查找CPU飙升的原因

问题分析步骤：

*   首先，需要知道哪个进程占用CPU比较高，
*   其次，需要知道占用CPU高的那个进程中的哪些线程占用CPU比较高，
*   然后，需要知道这些线程的stack trace。

问题解决步骤：

*   1、**top**和pgrep来查看系统中Java进程的CPU占用情况。

    *   命令如下：**top -p `pgrep -d , java`**
    *   pgrep：进程号，`top -p`：进程的信息。记录下CPU占用率最高的那个进程号。

*   2、top来查看进程中CPU占用最高的那些线程

    *   **top -Hp 12345**
    *   假定12345为占用CPU高的进程号。-H是显示该进程中线程的CPU占用情况。同样，记录下CPU占用率高的那些线程号。

*   3、ctrl+H 切换到线程模式，找到占用cpu最高的线程。并把**线程号转化为十六进制**，**printf "%x\n" <线程ID>**

*   4、通过**jstack**导出Java应用中线程的stack trace（堆栈轨迹）

    *   **jstack 12345**

注意：因为top中显示的线程号是10进制，jstack的输出结果中的线程号是16进制，所以只需要把top中看到线程号转换成16进制

小结一下，我们通过top和jstack来找到CPU占用高的线程的stack trace，可以使用Eclipse Memory Analyzer插件分析



## Java堆溢出和泄漏

### 内存溢出

程序在申请内存时,没有足够的内存空间供其使用

*   **危害：**容易受攻击
*   **影响因素**如下几大类： 
    *   内存中加载的数据量过于庞大，如一次从数据库取出过多数据
    *   集合类中有对对象的引用，使用完后未清空，使得JVM不能回收
    *   代码中存在死循环或循环产生过多重复的对象实体
*   **解决方案：**
    *   修改JVM启动参数，直接增加内存
    *   检查错误日志，是否有其他异常或错误；
    *   对代码进行走查和分析，找出可能发生内存溢出的位置
    *   重点排查：数据库的取值，死循环和递归调用



### 内存泄漏

无法释放已申请的内存空间

*   **危害：频繁GC、运行崩溃**

*   影响因素如下几大类： 

    *   静态集合类引起内存泄露

    *   当集合里面的对象属性被修改后，再调用remove()方法时不起作用。

        ```java
        Set<Person> set = new HashSet<Person>();
        Person p3 = new Person("唐僧","pwd1",25);
        p3.setAge(2); //修改p3的年龄,此时p3元素对应的hashcode值发生改变
        set.remove(p3); //此时remove不掉，造成内存泄漏
        ```

    *   监听器。释放对象时没有删除监听器。

    *   各种连接 ，比如数据库连接

    *   单例对象持有外部对象的引用

*   **解决办法：**使用工具jconsole分析

堆的最小值-Xms参数，最大值-Xmx参数

```java
//代码实现堆溢出：---> 无限循环创建 对象
List list =new ArrayList();
int i=0;
while(true){
    list.add(new byte[5*1024*1024]);//----------->就是这一步
    System.out.println("分配次数："+(++i))
}
```



### Java栈溢出

**栈溢出SOF定义**：线程请求的栈深度超过虚拟机允许的最大深度

*   无论是由于栈帧太大还是栈容量太小，当内存无法分配时都是OOM异常。
*   虚拟机栈溢出：**深度溢出：递归方法；广度溢出：大数组，建立多线程**

```java
//代码实现栈泄漏---> 方法无限递归调用
public void add(int i){
    add(i+1);
}
```





