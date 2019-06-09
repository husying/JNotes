# Java 并发

# 一、并发编程基础

## 1、进程与线程

**进程**：资源分配和调度单位

*   操作系统进行资源分配的最小单位，资源包括：CPU、内存空间、磁盘等
*   同一个进程中的多个线程共享该进程中的全部资源(**堆**和**方法区**资源)
*   进程之间是相互独立的

**线程**：线程是CPU调度的最小单位，必须依赖进程而存在

上下文切换：当CPU从一个线程切换到另外一个线程的时候，它需要先存储当前线程的本地的数据，程序指针等，然后载入另一个线程的本地数据，程序指针等，最后才开始执行

## 2、串行、并行与并发

串行：在同一时间一个人只能做一件事的情况下，一个人交替做着做多件事

并行：在同一时间一个人同时做多件事，如左后开弓一般

并发：在同一时间多个人抢着做同一件事，如竞争一个位置

## 3、吞吐量TPS

吞吐量表示在单位时间内通过某个网络或接口的数据量 

## 4、高并发

优点：充分利用CPU、加快响应用户的时间、是代码模块化、异步化、简单化

缺点：发生线程安全问题、容易死循环



**高并发与分布式**

*   **高并发**：指并发在单个资源个体的情况下实现达到最大资源利用价值，如：1个服务器4个CPU*4核，那么并行为16，高并发则利用多线程技术，可能实现160个
*   **分布式**：当来了 1 万个并发时，原来资源满足不了，就并行的再多开几个资源服务器。说白了就是多找几个服务器写作完成。常见架构有Hadoop、Hbase、Zookeeper、Redis

## 5、同步和异步

*   同步：发送一个请求，等待返回，然后再发送下一个请求。
*   异步：发送一个请求，不等待返回，随时可以在发送下一个请求。

------

# 二、线程基础

## 1、线程的3种实现方式

**线程的 3 种实现方式**：

*   继承 Thread 类
*   实现 Runnable 接口
*   实现 Callable  接口

通过 Runnable 和 Callable 接口实现的类，必须依靠 Thread 来启动，不是真正意义上的线程，可以当做线程任务看待，代码实现如下：

**1> 继承Thread类 **

```java
public class MyThread extends Thread{// 继承Thread类
　　public void run(){
　　// 重写run方法
　　}
}
public class Main {
　　public static void main(String[] args){
　　　　new MyThread().start();//创建并启动线程
　　}
}
```

**2> 实现Runnable接口 **

```java
public class MyThread2 implements Runnable {// 实现Runnable接口
　　public void run(){
　　// 重写run方法
　　}
}
public class Main {
　　public static void main(String[] args){
　　　　// 创建并启动线程
　　　　MyThread2 myThread=new MyThread2();
　　　　Thread thread=new Thread(myThread);
　　　　thread().start();
　　　　// 或者简写    
       new Thread(new MyThread2()).start();
　　}
}
```

实现接口比继承 Thread 类具有优势，因为接口是多实现， Thread 类单继承

实现接口会更好一些，因为：



**3> 实现Callable接口 **

**Callable和Runnable区别 **

*   执行方法不同，call()  、run()
*   Callable的 **call() **方法 **可以返回值和抛出异常 **，通过 Future 对象进行封装

```java
//Callable  启动线程方式
class ThreadDemo implements Callable<Integer> {
	public Integer call() throws Exception { return null;}
}
public class Test { 
	public static void main(String[] args) {
		ThreadDemo td = new ThreadDemo();
		FutureTask<Integer> result = new FutureTask<Integer>(td);
		new Thread(result).start();
	}  
}
```



------

## 2、Thread类的属性和方法

构造方法常用的有：

```java
new Thread()
new Thread(String name)
new Thread(Runnable target)
new Thread(Runnable target,String name)
new Thread(ThreadGroup group,String name)
```

主要方法有：

| 方法                                | 说明                                                         |
| ----------------------------------- | ------------------------------------------------------------ |
| static Thread currentThread()       | 返回当前正在执行的线程对象引用                               |
| long getId()                        | 返回该线程标识符                                             |
| String getName()                    | 返回线程名称                                                 |
| int  getPriority()                  | 返回线程优先级                                               |
| Thredad.State  getState()           | 返回线程状态                                                 |
| static boolean holdLock(Object obj) | 判断当前线程对象是否持有指定对象锁，是返回true               |
| **void  interrupt()**               | 中断线程                                                     |
| **static boolean interrupted()**    | 判断当前线程是否已经中断，**会清空中断标识位**（即重新设置为false） |
| **boolean  isInterrupted()**        | 判断当前线程是否已经中断，不会清除线程对象的中断标识位       |
| boolean isAlive()                   | 判断线程是否处于活动状态                                     |
| boolean isDaemon()                  | 判断该线程是否是守护线程                                     |
| **void join()**                     | 等待这个线程死亡，再执行                                     |
| void join(long millis)              | 等待这个线程死亡的时间最长为millis  ms                       |
| void join(long millis,int nanos)    | 等待这个线程死亡的时间最长为millis  ms+ nanos ns             |
| **void sleep(long millis)**         | 暂时停止执行，时间最长为millis  ms                           |
| void sleep(long millis,int nanos)   | 暂时停止执行，时间最长为millis  ms+ nanos ns                 |
| **void run()**                      | 线程执行体                                                   |
| **static void stop()**              | **已弃用**，停止线程，线程不安全                             |
| **void start()**                    | 启动线程                                                     |
| **static void yield()**             | 临时暂停，让掉当前线程 CPU 的时间片，让其他线程执行，转为就绪状态，并重新竞争 CPU 的调度权。 |
| void suspend()                      | **已弃用**，暂停线程，需要resume 恢复，线程不安全，易死锁    |
| void resume()                       | **已弃用**，恢复线程，线程不安全                             |

**Object的方法**

| 方法                       | 说明                                                         |
| -------------------------- | ------------------------------------------------------------ |
| **final void wait()**      | 释放CPU，释放线程锁，进入等待池，调用前必须先获取对象锁，否则抛异常 |
| **final void notify()**    | 唤醒当前对象等待池中的第一个线程，调用前必须先获取对象锁，否则抛异常 |
| **final void notifyAll()** | 唤醒当前对象等待池中的所有线程，调用前必须先获取对象锁，否则抛异常 |



**sleep 方法和wait 方法区别 **

*   sleep：放弃CPU一定的时间， **不会释放对象锁 **；wait：放弃CPU一定的时间， **会释放对象锁 **
*   Wait 通常被用于线程间交互/通信，sleep 通常被用于暂停执行。
*   sleep：可以在任何地方使用，而wait只能在同步方法或者同步块中使用
*   sleep： **必须抛出或捕获异常，而wait/notify/notifyAll不需要。 **
*   wait() 方法被调用后，线程不会自动苏醒，需要别的线程调用同一个对象上的 notify() 或者 notifyAll() 方法。sleep() 方法执行完成后，线程会自动苏醒。

**sleep和yield的区别 **

*   sleep()：让出CPU，进入睡眠状态，CPU让给其他线程运行机会时不考虑线程的优先级；
*   yield()：让出CPU，进入就绪状态，CPU只会让给相同优先级或更高优先级的线程以运行的机会;
*   sleep()方法声明抛出InterruptedException，而yield()方法没有声明任何异常; 

**notify 和 notifyAll的区别 **

*   notify()：只有一个等待线程会被唤醒而且它不能保证哪个线程会被唤醒，这取决于线程调度器
*   notifyAll()：唤醒等待该锁的所有线程，但是在执行剩余的代码之前，所有被唤醒的线程都将争夺锁定

**Thread.sleep(0)的作用 **

*   在线程中，调用sleep（0）可以释放cpu时间，让线程马上重新回到就绪队列而非等待队列，sleep(0)释放当前线程所剩余的时间片（如果有剩余的话），这样可以让操作系统切换其他线程来执行，提升效率。

**wait方法和notify/notifyAll方法在放弃对象监视器时有什么区别？ **

*   wait()方法立即释放对象监视器；	
*   notify()/notifyAll()方法则会等待线程剩余代码执行完毕才会放弃对象监视器

**为什么我们调用 start() 方法时会执行 run() 方法，为什么我们不能直接调用 run() 方法？**

*    调用 start 方法方可启动线程并使线程进入就绪状态，而 run 方法只是 thread 的一个普通方法调用，还是在主线程里执行。



Thread 使用注意：

*   开启一个新线程，一定要命名，方便监控观察
*   resume、stop、suspend等方法已经废除、不建议使用，可采用信号量（共享变量）或interrupt方法代替stop方法等
*   main 方法主线程结束，子线程不一定结束

------

## 3、线程中断机制

线程中断有2种方式

1.  第一种：调用Thread.stop()
2.  第二种：调用Thread.interrupt()

**Thread.stop()：**

*   强迫停止一个线程，并抛出一个新创建的ThreadDeath对象作为异常，可以停止一个尚未启动的线程。如果该线程稍后启动，会立刻终止
*   不安全，已弃用

**Thread.interrupt()**

*   是一种协作机制，不能直接终止线程，通过修改中断标识实现，会唤醒发生阻塞的线程。（调用wait 或者sleep 的线程），并抛出`InterruptException`异常，不能中断 I/O 阻塞和 synchronized 锁阻塞



**Thread类提供三个中断方法**

*   **void   interrupt()**：中断线程  ，设置中断状态为true
*   **boolean   interrupted()** ： 判断当前线程是否已经中断，**会清空中断标识位**，即重新设置为false。如果连续两次调用该方法，则第二次调用返回false
*   **boolean   isInterrupted()**：判断当前线程是否已经中断，不会清除线程对象的中断标识位



wait, sleep方法，会不断的轮询监听 interrupted 标志位，发现其设置为true后，会停止阻塞并抛出 InterruptedException异常。 



**线程池中断操作**

*   调用 Executor 的 shutdown() 方法：等待线程都执行完毕之后再关闭，
*   调用 Executor 的 shutdownNow() 方法，则相当于调用每个线程的 interrupt() 方法。

```java
ExecutorService executorService = Executors.newCachedThreadPool();
executorService.execute(() -> { });
executorService.shutdownNow();
```

**如果想中断线程池中的某一个线程**

*   可以通过使用 submit() 方法来提交一个线程，它会返回一个 Future<?> 对象，通过调用该对象的 cancel(true) 方法就可以中断线程。

```java
Future<?> future = executorService.submit(() -> { });
future.cancel(true);
```



------

## 4、线程状态和生命周期

线程状态总共6个：new、runnable、blocked、waiting、timed_waiting、terminated

线程状态：

*   `NEW`：创建后尚未启动的线程处于此状态。
*   `RUNNABLE`：正在Java虚拟机中执行的线程，或正在等待 CPU 时间片线程处于此状态。
*   `BLOCKED`：被阻塞等待监视器锁定的线程处于此状态。
*   `WAITING`：等待其它线程显式地唤醒，否则不会被分配 CPU 时间片的线程处于此状态。
*   `TIMED_WAITING`：无需等待其它线程显式地唤醒，在一定时间之后会被系统自动唤醒的线程处于此状态。
*   `TERMINATED`：已退出的线程处于此状态。

![Java线程状态变迁](assets/1684165153165.png)

线程生命周期：new、runnable、running、blocked、dead

*   `new`：新建状态，处于新生状态，有自己的内存，尚未运行，此时不是活着的
*   `runnable`：就绪状态，线程已启动，正等待被分配CPU时间片
*   `running`：运行状态，
*   `blocked`：阻塞状态，
    *   正在睡眠：使用sleep(long t)，睡眠指定时间后可进入就绪状态
    *   正在等待：使用wait()，可调用notify()/notifyAll()，恢复到就绪状态
    *   被另一个线程阻塞：调用suspend()，可调用resume()方法恢复
*   `dead`：死亡状态，分正常死亡或异常终止



------

## 5、守护线程

在Java中有两类线程：User Thread(用户线程)、Daemon Thread(守护线程) 

Daemon的作用是为其他线程的运行提供便利服务，只要任何非守护线程还在运行，守护线程就不会终止

守护线程最典型的应用就是 GC (垃圾回收器)，它就是一个很称职的守护者。



```java
Thread daemonTread = new Thread();  
daemonThread.setDaemon(true);  //  设定 daemonThread 为 守护线程，default false(非守护线程)  
//setDeamon(true)的唯一意义就是告诉JVM不需要等待它退出，让JVM喜欢什么退出就退出吧
daemonThread.isDaemon();  //  验证当前线程是否为守护线程，返回 true 则为守护线程  
```



 **需要注意： **

*   thread.setDaemon(true)必须在thread.start()之前设置，否则会跑出一个IllegalThreadStateException异常。你不能把正在运行的常规线程设置为守护线程。
*   在Daemon线程中产生的新线程也是Daemon的。 
*   不要认为所有的应用都可以分配给Daemon来进行服务，比如读写操作或者计算逻辑。 



## 6、线程组

线程组为了方便线程管理

在一个进程中线程组是以树形的方式存在，通常情况下，跟线程组是system线程组、system线程组下是main线程组

可通过如下方法获取当前线程组

`Thread.currentThread().getThreadGroup()`

**线程组和线程池的区别**

*   线程组是为了方便线程管理
*   线程池是为了管理线程的生命周期，复用线程，减少创建销毁线程的开销

## 7、异常捕获

因为run() 不会抛出异常，可使用如下方式处理：

*   对于checked exception，一般采用try/catch 块处理；
*   对于unchecked exception，一般采用注册一个实现UncaughtExceptionHandler 接口的对象实例处理。

UncaughtExceptionHandler 代码演示如下：

```java
public class ExceptionHandler implements UncaughtExceptionHandler{
	@Override
	public void uncaughtException(Thread t, Throwable e) {
		 System.out.println(e.getClass().getName());
		 System.out.println(e.getMessage());
	}

}
public class ThreadTest implements Runnable {
    @Override
    public void run() {
        Integer.parseInt("SSS");
    }

}
public class Test {
	public static void main(String args[]) {
		Thread thread = new Thread(new ThreadTest());
		thread.setUncaughtExceptionHandler(new ExceptionHandler());
		thread.start();
	}
}
```

注意：setUncaughtExceptionHandler  需要在线程启动前设置



------

## 8、线程唤醒

*   **wait与notify**
    *   wait与notify必须配合synchronized使用，因为调用之前必须持有锁，wait会立即释放锁，notify则是同步块执行完了才释放
*   **await与singal**
    *   Condition类提供，而Condition对象由new ReentLock().newCondition()获得，与wait和notify相同，因为使用Lock锁后无法使用wait方法
*   **park与unpark**
    *   LockSupport是一个非常方便实用的线程阻塞工具，它可以在线程任意位置让线程阻塞。和Thread.suspend()相比，它弥补了由于resume()在前发生，导致线程无法继续执行的情况。和Object.wait()相比，它不需要先获得某个对象的锁，也不会抛出IException异常。可以唤醒指定线程
*   suspend与resume
    *   不推荐使用； suspend() 去挂起线程的原因，是因为 suspend() 在导致线程暂停的同时，并不会去释放任何锁资源。其他线程都无法访问被它占用的锁。直到对应的线程执行 resume() 方法后，被挂起的线程才能继续，从而其它被阻塞在这个锁的线程才可以继续执行。
    *   如果 resume() 操作出现在 suspend() 之前执行，那么线程将一直处于挂起状态，同时一直占用锁，这就产生了死锁

------

# 三、多线程安全

## 1、多线程优缺点

优点：资源利用率更好、程序设计更简单、程序响应更快

缺点：增加资源消耗，出现线程死锁



## 2、多线程之间通讯

*   **Thread#join()**

*   **等待/通知机制**：使用 Object 类的方法，如 **wait()/notify()/notifyAll()**
*   **利用Lock和Condition**： ReentrantLock 类加锁的线程中使用**Condition类的 **await()/signal()/signalAll()
*   **利用阻塞队列**：如 BlockingQueue
*   **利用管道通信**：PipeInputStream和PipeOutputStream、PipeReader和PipedWriter



**Thread#join()**

在线程中调用另一个线程的 join() 方法，会将当前线程挂起，而不是忙等待，直到目标线程结束。

```java
class A extends Thread {
	@Override
	public void run() {
		System.out.println("A");
	}
}
class B extends Thread {
	private A a;
	B(A a) {
		this.a = a;
	}
	@Override
	public void run() {
		try {
			a.join(); // 等待 a 线程结束才继续执行
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("B");
	}
}

public class Test {
	public static void main(String[] args) {
		A a = new A();
		B b = new B(a);
		b.start();
		a.start();
	}
}
// 输出
A
B
```



## 3、线程同步与安全

### 1> 线程同步方式

*   使用**synchronized** ：修饰方法或代码块。修饰方法(类锁），代码块(对象锁，static修饰时，为类锁)
*   使用**volatile**修饰变量
*   使用**ThreadLocal** 局部变量
*   使用**java.util.concurrent**包中的类库，简称 `JUC`，AQS 被认为是 J.U.C 的核心。
    *   **并发集合类**：ConcurrentHashMap、CopyOnWriteArrayList、阻塞队列（如LinkedBlockingQueue）
    *   **atomic 包**： 原子类型变量
    *   **locks 包**： 重入锁或读写锁



**加锁原则**

同步调用应该去考量锁的性能损耗。能用无锁数据结构，就不要用锁 ； 能锁区块，就不要锁整个方法体 ； 能用对象锁，就不要用类锁。

**线程不安全**：多个线程对共享资源的互斥访问，即多个线程同时操作一个数据结构的时候产生了相互修改和串行，没有保证数据一致性

**线程安全**：指保证数据高度一致性和准确性

**线程同步加锁的时机**

*   并发修改同一记录时，避免更新丢失，需要加锁
*   要么在应用层加锁，要么在缓存加锁，要么在数据库层使用乐观锁：CAS 或版本号
*   如果每次访问冲突概率小于 20%，推荐使用乐观锁，否则使用悲观锁。乐观锁的重试次数不得小于 3 次。



---

### 2 > volatile 

*   **修饰的成员变量**，可保证`可见性`；

*   **禁止指令重排序**，`有序性`，不能保证原子性，所以不适用于高并发环境做安全机制

*   适用于：一写多读环境；多个多写，任然会有线程安全问题



**volatile：不能保证原子 **

*   线程A首先得到了i的初始值100，但是还没来得及修改，就阻塞了，这时线程B开始了，它也得到了i的值，由于i的值未被修改，即使是被volatile修饰，主存的变量还没变化，那么线程B得到的值也是100，之后对其进行加1操作，得到101后，将新值写入到缓存中，再刷入主存中。根据可见性的原则，这个主存的值可以被其他线程可见。 
*   问题来了，线程A已经读取到了i的值为100，也就是说读取的这个原子操作已经结束了，所以这个可见性来的有点晚，线程A阻塞结束后，继续将100这个值加1，得到101，再将值写到缓存，最后刷入主存，所以即便是volatile具有可见性，也不能保证对它修饰的变量具有原子性。



**volatile与synchronize的区别 **

*   都可以解决线程并发的问题，
*   synchronized 修饰同步，用 volatile **修饰的成员变量**
*   volatile： **保证可见性，禁止指令重排序 **，不能保证原子性；synchronized：则可以保证变量的修改**可见性和原子性**
*   **volatile不会造成线程阻塞。synchronized可能会造成线程阻塞。**



并发编程中，我们通常会遇到以下三个问题：原子性问题，可见性问题，有序性问题。

​	**java多线程中的原子性、可见性、有序性 **

*   原子性：是指线程的多个操作是一个整体，不能被分割，要么就不执行，要么就全部执行完，中间不能被打断。 
*   可见性：是指线程之间的可见性，就是一个线程修改后的结果，其他的线程能够立马知道。 
*   有序性：有序性就是代码执行顺序及是并发执行顺序。

---

### 3 >  ThreadLocal

ThreadLocal的实例代表了 **线程局部变量 **，每条线程都只能看到自己的值

ThreadLocal方法：get()、set()、remove()、initialValue()

```java
// JDBC 获取连接
private static ThreadLocal<Connection> threadLocal = new ThreadLocal<Connection>();
public static Connection getConnection() {
		Connection conn = threadLocal.get();
		if (conn == null) {
			try {
				conn = DriverManager.getConnection(
                    	properties.getProperty("jdbc.url"),
						properties.getProperty("jdbc.username"), 
						properties.getProperty("jdbc.password"));
				threadLocal.set(conn);
			} catch (Exception e) {
				throw new RuntimeException("建立数据库连接异常", e);
			}
		}
		return conn;
	}
```

**实现原理：**

每个 Thread 的对象都有一个 ThreadLocalMap 类，它是以一个静态内部类。

```java
// 设值
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
}
ThreadLocalMap getMap(Thread t) {
    return t.threadLocals;
}
// 取值
public T get() {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null) {
        ThreadLocalMap.Entry e = map.getEntry(this);
        if (e != null) {
            @SuppressWarnings("unchecked")
            T result = (T)e.value;
            return result;
        }
    }
    return setInitialValue();
}
```



InheritableThreadLocal：该类继承了 `ThreadLocal`，为子线程提供从父线程那里继承的值

---

### 4> 原子操作类

*   atomic 类库是不会阻塞线程的
*   包路径：java.util.concurrent.atomic
*   用于高并发环境下的高效程序处理



常用原子类如下：

*   基本类型：AtomicInteger、AtomicLong、AtomicBoolean
*   引用类型：AtomicReference、AtomicReference的ABA实例、AtomicStampedeReference、AtomicMarkableReference
*   数组类型：AtomicIntegerArray、AtomicLongArray、AtomicReferenceArray
*   属性原子修改器（Updater）:AtomicIntegerFieldUpdater、AtomicLongFieldUpdater、AtomicReferenceFieldUpdater

---

## 4、锁类型分类

### 1> 公平锁和非公平锁

*   **公平锁**：指多个线程在等待同一个锁时，必须按照申请锁的时间顺序来依次获得锁。
*   非公平锁：竞争获取锁



**自旋锁**

*   自旋锁是指尝试获取锁的线程不会立即阻塞，而是采用循环的方式去尝试获取锁
*   好处是减少线程上下文切换的消耗，缺点是循环会消耗CPU



### 2> 重入锁和不可重入锁

 **不可重入锁 **：当前线程执行某个方法已经获取了该锁，那么在这个方法中尝试再次获取这个锁时，就会获取不到被阻塞

```java
public class LockTest{
    private boolean isLocked = false;
    public synchronized void lock() throws InterruptedException{
        while(isLocked){    
            wait();
        }
        isLocked = true;
    }
    public synchronized void unlock(){
        isLocked = false;
        notify();
    }
}
```



 **可重入锁 **：线程可以进入它已经拥有的锁的同步代码块儿

```java
public class LockTest{
    boolean isLocked = false;
    Thread  lockedBy = null;
    int lockedCount = 0;  // 获取锁的次数
    public synchronized void lock()
            throws InterruptedException{
        Thread thread = Thread.currentThread();
        // 判断是当前对象的已经获得锁，无需等待可再次获取
        while(isLocked && lockedBy != thread){  
            wait();
        }
        isLocked = true;
        lockedCount++;
        lockedBy = thread;
    }
    public synchronized void unlock(){
        if(Thread.currentThread() == this.lockedBy){
            lockedCount--;
            if(lockedCount == 0){
                isLocked = false;
                notify();
            }
        }
    }
}
```





### 3> 悲观锁和 乐观锁

*   **悲观锁**：悲观锁认每次对某资源进行操作时，别人都会修改。 **实现方式：**synchronized和lock
*   **乐观锁**：乐观以为每次去拿数据的时候别人不会修改；采用的是**CAS算法 **，**实现方式：版本控制和CAS**

------

**CAS：(Compare-and-Swap) **

*   JDK体现：原子类，如AtomicInteger
*   **即比较-设置 **，假设有三个操作数： 内存位置值V、旧的预期值A、要修改的值B，当且仅当预期值A和内存值V相同时，才会将内存值修改为B并返回true，否则什么都不做并返回false 。
*   **当然CAS一定要volatile变量配合 **，这样才能保证每次拿到的变量是主内存中最新的那个值，否则旧的预期值A对某条线程来说，永远是一个不会变的值A，只要某次CAS操作失败，永远都不可能成功。



**CAS的缺点： **

*   **ABA问题： **比如说一个线程one从内存位置V中取出A，这时候另一个线程two也从内存中取出A，并且two进行了一些操作变成了B，然后two又将V位置的数据变成A，这时候线程one进行CAS操作发现内存中仍然是A，然后one操作成功。尽管线程one的CAS操作成功，但是不代表这个过程就是没有问题的。
    *   解决方法：加一个版本号或者时间戳，如AtomicStampedReference
*   **只能保证一个共享变量的原子操作 **
    *   当对一个共享变量执行操作时，我们可以使用 **循环CAS**的方式来保证原子操作
    *   对多个共享变量操作时，循环CAS就无法保证操作的原子性
    *   解决方法：
        *   可以加锁来解决。
        *   封装成对象类AtomicReference解决（java.util.concurrent.atomic的原子操作类（Atomic开头））。
*   **自旋消耗资源，CPU开销较大 **
    *   解决方法：破坏掉for死循环，当超过一定时间或者一定次数时，return退出





---

## 5、线程加锁

### 1> 隐式锁synchronized 

*   隐式锁指不需要加锁、解锁的操作
*   隐式锁又称线程同步锁、通过synchronized 实现

synchronized 两种方式：修饰方法、修饰代码块

```java
//  加锁方法
public synchronized void synMethod){
    // 方法体
}
//  加锁代码块
public void synMethod(){
    synchronized(Object){  //  Object 指锁对象
        // 方法体
    }
}

```

**注意：** 

*   synchronized 修饰方法是**类锁**、修饰代码块是**对象锁**，
*   如果同步方法或代码块**被static修饰时也为类锁**，因为同一个对象的多个实例，在进入静态的同步方法时，一次只能有一个类实例进入，所以同步方法体效率和性能没有同步块高





**同步方法和同步代码块的区别**

*   同步方法使用synchronized修饰方法，在调用该方法前，需要获得当前对象锁，即类锁
*   同步代码块使用synchronized(object){}进行修饰，在调用该代码块时，可以指定任一对象作为锁
*   synchronized方法等同于synchronized（this）， 是对整个类对象加锁

代码演示如下

```java
// 参考博文：https://www.cnblogs.com/xujingyang/p/6565606.html
class SynObj{
    public synchronized void showA(){
        System.out.println("showA");
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    public void showB(){
        synchronized (this) {
            System.out.println("showB");
        }
    }
    public void showC(){
        String s="1";
        synchronized (s) {
            System.out.println("showC");
        }
    }
}
public class Test {
    public static void main(String[] args) {
        final SynObj sy=new SynObj();
        new Thread(new Runnable() {
            public void run() {
                sy.showA();
            }
        }).start();
        new Thread(new Runnable() {
            public void run() {
                sy.showB();
            }
        }).start();
        new Thread(new Runnable() {
            public void run() {
                sy.showC();
            }
        }).start();
    }
}


```

// 你会发现，输出顺序为：showA、showC、showB；而showB 是延迟3秒才打印的，这是因为同步方法showA 使用的是类锁。



### 2> 显式锁Lock和ReentrantLock

Lock 是一个接口提供了无条件、可轮询、定时、可中断的锁获取操作，加锁和解锁都是显式的

*   包路径是：java.util.concurrent.locks.Lock
*   主要核心方法：lock()、tryLock()、unlock() 、lockInterruptibly ()
*   其实现类有：ReenTrantLock 、ReentrantReadWriteLock.ReadLock、ReentrantReadWriteLock.WritedLock

**lock()、tryLock()、lockInterruptibly** **

*   lock.lock()  是一个阻塞方法，调用后一直阻塞直到获得锁。阻塞过程中不会接受中断信号，忽视interrupt(), 拿不到锁就 一直阻塞。即：**拿不到lock就不罢休，不然线程就一直block**。 比较无赖的做法。
*   lock.tryLock：马上返回，**拿到lock就返回true，不然返回false**。 比较潇洒的做法。带时间限制的tryLock()，拿不到lock，就等一段时间，超时返回false。比较聪明的做法。

*   **lockInterruptibly** ：调用后如果没有获取到锁会一直阻塞，阻塞过程中会接受中断信号，即 **线程在请求lock并被阻塞时，如果被interrupt，则“此线程会被唤醒并被要求处理InterruptedException”。**





**ReentrantLock代码实现**

```java
// 非公平锁（默认）
final ReentrantLock lock = new ReentrantLock();
final ReentrantLock lock = new ReentrantLock(false);

// 公平锁
ReentrantLock lock = new ReentrantLock(true);
```

```java
Lock lock = new ReentrantLock();
if(lock.tryLock()) {
     try{				// ----------->>>>注意： lock()、tryLock() 不需要放在try 中
         // 处理任务
     }catch(Exception ex){
         
     }finally{
         lock.unlock();   //  释放锁
     } 
}else {
    //  如果不能获取锁，则直接做其他事情
}
```

**ReenTrantLock 与 synchronized 区别： **

*   synchronized 是 JVM 实现的，而 ReentrantLock 是 JDK 实现的。
*   ReenTrantLock：可以指定是公平锁还是非公平锁，默认情况是非公平的。而synchronized只能是非公平锁。
*   ReenTrantLock： **在lock()完了，一定要手动unlock() **
*   ReenTrantLock：以决定多长时间内尝试获取锁，如果获取不到就抛异常；synchronized一直等待，死锁
*   ReentrantLock增加了一些高级功能。主要来说主要有三点：**①等待可中断；②可实现公平锁；③可实现选择性通知（锁可以绑定多个条件）**
    *   **ReentrantLock提供了一种能够中断等待锁的线程的机制**，通过lock.lockInterruptibly()来实现这个机制。也就是说正在等待的线程可以选择放弃等待，改为处理其他事情。
    *   可实现公平锁，通过构造方法
    *   可实现选择性通知，通过借助 Condition

**Condition**

*   Condition是在java 1.5中才出现的，它用来替代传统的Object的wait()、notify()使用**Condition的await()、signal()**这种方式实现线程间协作更加安全和高效。因此通常来说比较推荐使用Condition。
*   Condition可以实现多路通知功能，也就是在一个Lock对象里可以创建多个Condition（即对象监视器）实例，线程对象可以注册在指定的Condition中，从而**可以有选择的进行线程通知，在调度线程上更加灵活**。

```java
// 实例化一个ReentrantLock对象
private ReentrantLock lock = new ReentrantLock();
// 为线程A注册一个Condition
public Condition conditionA = lock.newCondition();
// 为线程B注册一个Condition
public Condition conditionB = lock.newCondition();
```

详情参考：[Java多线程之ReentrantLock与Condition](https://www.cnblogs.com/xiaoxi/p/7651360.html)



### 3> 显式锁ReadWriteLock

*   ReadWriteLock 也是一个接口，提供了readLock 和 writeLock 两种锁机制
*   读锁支持多个读线程对一个资源访问
*   写锁是互斥锁，只能一个线程访问
*   包路径：java.util.concurrent.locks.ReadWriteLock
*   实现类：ReentrantReadWriteLock



**ReentrantReadWriteLock：**

*   默认非公平但可实现公平的
*   支持重入
*   写互斥，读共享
*   锁降级：写线程获取写入锁后，可以获取读取锁，然后释放写入锁，这样将写入锁变成读取锁实现锁降级



**ReentrantLock 与 ReentrantReadWriteLock  区别 **

*   ReentrantLock ：互斥锁。ReentrantReadWriteLock  ：写锁之间的互斥的，但读锁不互斥，
*   ReentrantReadWriteLock  可以实现在一个方法中读写分离的锁机制



### 4> 显式锁 StampedLock

*   StampedLock是Java8引入的一种新的所机制，可以认为它是读写锁的一个改进版本



### 5> 线程锁对比

Synchronized、ReentrantLock 、ReentrantReadWriteLock  、StampedLock

*   Synchronized 是jvm层面上实现，会自动释放锁，其他3个都是代码层面锁定
*   ReentrantLock 用于简单加锁、解锁的业务逻辑
*   ReentrantReadWriteLock  在Lock 上引入了读写锁机制
*   StampedLock 又在Lock 上引入乐观锁和悲观锁，不过其API 复杂。



### 实现的同步方式

*   使用synchronized ：修饰方法或代码块
*   使用**volatile**修饰变量
*   使用ThreadLocal 局部变量
*   使用java.util.concurrent包中的类库
    *   集合并发类：ConcurrentHashMap、CopyOnWriteArrayList、阻塞队列（如LinkedBlockingQueue）
    *   atomic 包下的 **原子类型变量**
    *   locks包下的重入锁或读写锁

同步调用应该去考量锁的性能损耗。能用无锁数据结构，就不要用锁 ； 能锁区块，就不要锁整个方法体 ； 能用对象锁，就不要用类锁。

synchronized ：修饰方法（类锁）或代码块（对象锁，static修饰时，为类锁）



并发修改同一记录时，避免更新丢失，需要加锁。要么在应用层加锁，要么在缓存加锁，要么在数据库层使用乐观锁，使用 version 作为更新依据。说明：如果每次访问冲突概率小于 20%，推荐使用乐观锁，否则使用悲观锁。乐观锁的重试次数不得小于 3 次。

------

**Synchronized和lock的区别 **

*   Synchronized： **非公平**，悲观，独享，互斥，可重入的重量级锁

*   ReentrantLock（重入锁）：默认非公平但可实现公平的，悲观，独享，互斥，可重入的重量级锁

*   ReentrantReadWriteLocK（读写锁）：默认非公平但可实现公平的，悲观， **写独享，读共享**，可重入的重量级锁

    

**Lock 接口方法 **

*   lock()、tryLock()、tryLock(long timeout,TimeUnit unit)、unLock()
*   lock(), 如果获取了锁立即返回，如果别的线程持有锁，当前线程则一直处于休眠状态，直到获取锁
*   tryLock(), 如果获取了锁立即返回true，如果别的线程正持有锁，立即返回false
*   tryLock(long timeout,TimeUnit unit)， 如果获取了锁定立即返回true，如果别的线程正持有锁，会等待参数给定的时间，在等待的过程中，如果获取了锁定，就返回true，如果等待超时，返回false；
*   lockInterruptibly:如果获取了锁定立即返回，如果没有获取锁定，当前线程处于休眠状态，直到获取锁定，或者当前线程被别的线程中断



------

**synchronized关键字也可以修饰静态方法，此时如果调用该静态方法，将会锁住整个类 **

*   同一个对象的多个实例，在进入静态的同步方法时，一次只能有一个类实例进入
*   [代码演示](https://blog.csdn.net/zhaodafeng/article/details/77119965)

------

```java
// ---------synchronized----------
public synchronized int getX() {
      return x++;
}
// ----------synchronized---------
public int getX() {
      synchronized (this) {
            return x++;
      }
}
// --------ReentrantLock-----------
public class Bank {      
    Lock lock = new ReentrantLock();  
    lock.lock(); 
    try {   
      //  update object state  
    } finally {  
      lock.unlock();   
    }  
｝
//  一般使用方式-----------------------


```

------

扩展：

 **不可重入锁 **（自旋锁）：当前线程执行某个方法已经获取了该锁，那么在这个方法中尝试再次获取这个锁时，就会获取不到被阻塞

 **可重入锁 **：线程可以进入它已经拥有的锁的同步代码块儿

```java
// 不可重入锁
public class Lock{
    private boolean isLocked = false;
    public synchronized void lock() throws InterruptedException{
        while(isLocked){    
            wait();
        }
        isLocked = true;
    }
    public synchronized void unlock(){
        isLocked = false;
        notify();
    }
}
// 使用该锁：
public class Count{
    Lock lock = new Lock();
    public void print(){
        lock.lock();
        doAdd();//-----------------无法执行，被阻塞
        lock.unlock();
    }
    public void doAdd(){
        lock.lock();
        //do something
        lock.unlock();
    }
}


// 可重入锁
public class Lock{
    boolean isLocked = false;
    Thread  lockedBy = null;
    int lockedCount = 0;
    public synchronized void lock()
            throws InterruptedException{
        Thread thread = Thread.currentThread();
        while(isLocked && lockedBy != thread){
            wait();
        }
        isLocked = true;
        lockedCount++;
        lockedBy = thread;
    }
    public synchronized void unlock(){
        if(Thread.currentThread() == this.lockedBy){
            lockedCount--;
            if(lockedCount == 0){
                isLocked = false;
                notify();
            }
        }
    }
}

```

------

## 6、死锁

### 1> 线程死锁定义

*   **两个或者多个线程互相持有对方所需要的资源，导致这些线程处于无限期等待状态，无法继续执行**
*   例如：线程1锁住了A资源并等待读取B资源，而线程2锁住了B资源并等待A资源，这样两个线程就发生了死锁现象。

### 2> 死锁发生的条件

*   互斥条件：一个资源每次只能被一个进程使用。
*   请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持占有。
*   不剥夺条件：指进程已获得的资源，在未使用完之前，不能被剥夺，只能在使用完时由自己释放。
*   循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系。

**如何避免线程死锁**：们只要破坏产生死锁的四个条件中的其中一个就可以了。



### 3> 死锁代码实现

```java
private static String A = "A";
private static String B = "B";

public static void main(String[] argc) {
    new Thread(()-> {
        synchronized (A) {
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            synchronized (B) {
            }
        }
    }).start();

    new Thread(()->{
        synchronized (B) {
            synchronized (A) {
            }
        }
    }).start();;
}
```

---

扩展：

 **死锁预防**

*   **有序资源分配法**：改变资源的分配顺序。
    *   如：进程PA，使用资源的顺序是R1，R2； 进程PB，使用资源的顺序是R2，R1； 改变之后变成；PA：申请次序应是：R1，R2，PB：申请次序应是：R1，R2。 以此来破坏环路条件，避免死锁发生
*   **银行家算法**：避免死锁算法中最有代表性的算法；以银行借贷系统的分配策略为基础，判断并保证系统的安全运行



**银行家算法**

**使用场景介绍**：

*   银行家算法顾名思义是来源于银行的借贷业务，一定数量的本金要应多个客户的借贷周转，为了防止银行家资金无法周转而倒闭，对每一笔贷款，必须考察其是否能限期归还。
*   在操作系统中研究资源分配策略时也有类似问题，系统中有限的资源要供多个进程使用，必须保证得到的资源的进程能在有限的时间内归还资源，以供其他进程使用资源。如果资源分配不得到就会发生进程循环等待资源，则进程都无法继续执行下去的死锁现象。

 **算法原理： **

将操作系统看做银行家，操作系统管理的资源相当于银行家管理的资金，进程向操作系统请求分配资源相当于用户向银行家贷款。

为保证资金的安全，银行家规定：

*   `贷款不能超过银行余额`：当一个顾客对资金的最大需求量不超过银行家现有的资金时就可接纳该顾客；
*   `允许分期贷款`：顾客可以分期贷款，但贷款的总数不能超过最大需求量；
*   `延期支付`：当银行家现有的资金不能满足顾客尚需的贷款数额时，对顾客的贷款可推迟支付，但总能使顾客在有限的时间里得到贷款；
*   `定期归还`： 当顾客得到所需的全部资金后，一定能在有限的时间里归还所有的资金.

操作系统按照银行家制定的规则为进程分配资源，当进程首次申请资源时，要测试该进程对资源的最大需求量

*   如果系统现存的资源可以满足它的最大需求量则按当前的申请量分配资源，否则就推迟分配
*   当进程在执行中继续申请资源时，先测试该进程本次申请的资源数是否超过了该资源所剩余的总量。若超过则拒绝分配资源，若能满足则按当前的申请量分配资源，否则也要推迟分配。



**死锁的解决办法**

*   预防死锁：通过破坏死锁的必要条件来预防；缺点：由于增加了限制条件，可能会导致系统资源利用率和系统吞吐量降低。
*   避免死锁：采用资源的动态分配，通过某种方法去检查系统在分配后是否会发生死锁，如果会，则不进行分配，以此来避免发生死锁
*   检查和解除死锁：
    *   先采用系统所设置的检测机构，及时地检测出死锁的发生，并精确地确定与死锁有关的进程和资源。检测方法包括定时检测、效率低时检测、进程等待时检测等。
    *   然后解除死锁：采取适当措施，从系统中将已发生的死锁清除掉。常用撤销或挂起的方式回收资源，再将资源分配给阻塞状态的进程，使之转为就绪状态。优点：可能提高系统资源利用率和吞吐量，但实现难度大





------

# 三、线程池

## 1、线程池的作用

*   降低资源消耗：通过重用已经创建的线程来降低线程创建和销毁的消耗

*   提高响应速度：任务到达时不需要等待线程创建就可以立即执行

*   提高线程的可管理性：线程池可以统一管理、分配、调优和监控

    [线程池详解](http://blog.csdn.net/fengye454545/article/details/79536986)



注意：线程池一定要在合理的单例模式下才有效。

## 2、线程池的分类

Executor 管理多个异步任务的执行，而无需程序员显式地管理线程的生命周期。这里的异步是指多个任务的执行互不干扰，不需要进行同步操作。

线程池不允许使用 Executors 去创建，而是通过 ThreadPoolExecutor 的方式，这样的处理方式让写的同学更加明确线程池的运行规则，规避资源耗尽的风险。



**线程池种类**：Java 通过Executors提供四种线程池，分别为：

*   **newCachedThreadPool**：创建一个 **可缓存线程池 **，线程数超出，回收空闲线程，无回收，新建
*   **newFixedThreadPool**： 创建一个 **定长线程池 **，控制线程最大并发数，超出队列中等待
*   **newScheduledThreadPool**： 创建一个 **定长线程池，支持定时及周期性任务执行 **。
*   **newSingleThreadExecutor**： 创建一个 **单线程化的线程 **池，指定顺序(FIFO, LIFO, 优先级)执行。



**Executors 线程池缺点**：

1.  FixedThreadPool 和 SingleThreadPool :

*   允许的请求队列长度为 Integer.MAX_VALUE ，可能会堆积大量的请求，从而导致 OOM 。

2.  CachedThreadPool 和 ScheduledThreadPool :

*   允许的创建线程数量为 Integer.MAX_VALUE ，可能会创建大量的线程，从而导致 OOM 。



```java
//  创建一个线程池  
ExecutorService pool = Executors.newFixedThreadPool(taskSize);  
poolService.execute(() -> e1.func1());

Future f = poolService.submit(Callable c);
poolService.shutdown();
```

## 3、线程池参数

### 1> 参数详情

```java
public ThreadPoolExecutor(
	int corePoolSize,
    int maximumPoolSize,
    long keepAliveTime,
    TimeUnit unit,
    BlockingQueue<Runnable> workQueue,
    ThreadFactory threadFactory,
    RejectedExecutionHandler handler) 

```

*   **corePoolSize**： **核心线程数 **，线程池的核心池大小，在创建线程池之后，线程池默认没有任何线程。
*   **maximumPoolSize**：允许的 **最大线程数 **。maximumPoolSize肯定是大于等于corePoolSize。
*   **keepAliveTime** ：线程空闲时间
*   **Unit**：时长单位。
*   **workQueue** ：一个阻塞队列，用来存储等待执行的任务
*   **threadFactory**：线程工厂
*   **handler**：表示当拒绝处理任务时的策略



### 2> 阻塞队列

BlockingQueue接口有：ArrayBlockingQueue ， DelayQueue ， LinkedBlockingDeque ， LinkedBlockingQueue ， LinkedTransferQueue ， PriorityBlockingQueue ， SynchronousQueue

*   **ArrayBlockingQueue （有界队列） **：是一个基于数组结构的有界阻塞队列，此队列按 FIFO（先进先出）原则对元素进行排序。
*   **LinkedBlockingQueue （无界队列） **：一个基于链表结构的阻塞队列，此队列按FIFO （先进先出） 排序元素，吞吐量通常要高于ArrayBlockingQueue。静态工厂方法Executors.newFixedThreadPool()使用了这个队列。
*   **SynchronousQueue（同步队列） **: 一个不存储元素的阻塞队列。每个插入操作必须等到另一个线程调用移除操作，否则插入操作一直处于阻塞状态，吞吐量通常要高于LinkedBlockingQueue，静态工厂方法Executors.newCachedThreadPool使用了这个队列。
*   **DelayQueue（延迟队列） **：一个任务定时周期的延迟执行的队列。根据指定的执行时间从小到大排序，否则根据插入到队列的先后排序。
*   **PriorityBlockingQueue（优先级队列） **: 一个具有优先级得无限阻塞队列。



 **怎么理解无界队列和有界队列 **

*   有界队列即长度有限，满了以后ArrayBlockingQueue会插入阻塞。
*   无界队列就是里面能放无数的东西而不会因为队列长度限制被阻塞，但是可能会出现OOM异常。

### 3> 拒绝策略

*   AbortPolicy：被拒绝时，它将抛出RejectedExecutionException。
*   CallerRunsPolicy：被拒绝时，会在线程池当前正在运行的Thread线程池中处理被拒绝的任务
*   DiscardOldestPolicy：被拒绝时，线程池会放弃等待队列中最旧的未处理任务，然后将被拒绝的任务添加到等待队列中
*   DiscardPolicy：被拒绝时，线程池将丢弃被拒绝的任务



### 4> 线程池状态

*   rrunning：接受新任务并且处理阻塞队列里的任务
*   shutdown：拒绝新任务但是处理阻塞队列里的任务
*   stop ：拒绝新任务并且抛弃阻塞队列里的任务同时会中断正在处理的任务
*   tidying：所有任务都执行完（包含阻塞队列里面任务）当前线程池活动线程为0，将要调用terminated方法
*   terminated：终止状态。terminated方法调用完成以后的状态

RUNNING -> SHUTDOWN:显式调用shutdown()方法，或者隐式调用了finalize(),它里面调用了shutdown（）方法。



------

## 4、线程池实现原理

提交一个任务到线程池中，线程池的处理流程如下：

*   先判读线程池里的核心线程是否都在执行任务，如果不是（核心线程空闲或还有未被创建）则创建新线程，如果是则下一步
*   再判读线程池工作队列是否已满，如果没满，则先存储在队列中，否则下一步
*   在判读线程池的线程是否都是工作状态，如果没有，则创建一个新的工作线程执行任务，否则，交给饱和策略来处理这个任务



 **线程池源码（jdk 1.8 ）： **

ThreadPoolExecutor的execute()方法

```java
 public void execute(Runnable command) {
     if (command == null)
         throw new NullPointerException();
     int c = ctl.get();
     if (workerCountOf(c) < corePoolSize) {
         if (addWorker(command, true))
             return;
         c = ctl.get();
     }
     if (isRunning(c) && workQueue.offer(command)) {
         int recheck = ctl.get();
         if (! isRunning(recheck) && remove(command))
             reject(command);
         else if (workerCountOf(recheck) == 0)
             addWorker(null, false);
     }
     else if (!addWorker(command, false))
         reject(command);
 }

```



 **线程池的关闭： **

ThreadPoolExecutor提供了两个方法，用于线程池的关闭，分别是shutdown()和shutdownNow()

*   **shutdown() **： **不会立即终止线程池 **，而是要等所有任务缓存队列中的任务都执行完后才终止，但再也不会接受新的任务
*   **shutdownNow() **： **立即终止线程池 **，并尝试打断正在执行的任务，并且清空任务缓存队列，返回尚未执行的任务



------

**Spring 的ThreadPoolExecutor配置 **

```xml
<!-- spring thread pool executor -->           
    <bean id="taskExecutor" class="org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor">
        <!-- 线程池维护线程的最少数量 -->
        <property name="corePoolSize" value="5" />
        <!-- 允许的空闲时间 -->
        <property name="keepAliveSeconds" value="200" />
        <!-- 线程池维护线程的最大数量 -->
        <property name="maxPoolSize" value="10" />
        <!-- 缓存队列 -->
        <property name="queueCapacity" value="20" />
        <!-- 对拒绝task的处理策略 -->
        <property name="rejectedExecutionHandler">
            <bean class="java.util.concurrent.ThreadPoolExecutor$CallerRunsPolicy" />
       		 <!-- AbortPolicy:直接抛出java.util.concurrent.RejectedExecutionException异常 -->
       		 <!-- CallerRunsPolicy:主线程直接执行该任务，执行完之后尝试添加下一个任务到线程池中，可以有效降低向线程池内添加任务的速度 -->
        	<!-- DiscardOldestPolicy:抛弃旧的任务、暂不支持；会导致被丢弃的任务无法再次被执行 -->
        	<!-- DiscardPolicy:抛弃当前任务、暂不支持；会导致被丢弃的任务无法再次被执行 -->
    	</property>
    </bean>

```

​         

# 四、J.U.C  常用组件

1、FutureTask 

2、BlockingQueue 

3、ForkJoin







# 资料参考

*   [CyC2018 / CS-Notes](https://github.com/CyC2018/CS-Notes)