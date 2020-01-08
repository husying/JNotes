---
typora-root-url: 面试之Java-基础篇（8）异常
---



# 异常分类

Throwable 是 Java 语言中所有错误或异常的超类。下一层分为 **Error** 和 **Exception**

* **Error**：用来表示 JVM 无法处理的错误，是指 java 运行时系统的内部错误和资源耗尽错误。应用程序不会抛出该类对象不便于也不需要捕获，属于不可检查时异常。常见的比如`OutOfMemoryError`、`StackOverflowError`都是Error的子类。

* **Exception（RuntimeException、CheckedException）**： Exception 又 有 两 个 分 支 ， 一 个 是 运 行 时 异 常 RuntimeException ， 一 个 是CheckedException。

![img](untitled%20diagram.png)







# Exception

**运行时异常 RuntimeException**  ： 其与子类都是未检查的异常，如 `NullPointerException` 、 `ClassCastException` ；是那些可能在 Java 虚拟机正常运行期间抛出的异常的超类。 如果出现 `RuntimeException`，那么一定是程序员的错误.

**检查异常 CheckedException**：如 I/O 错误导致的 `IOException`、`SQLException`，一般是外部错误，这种异常都发生在编译阶段，Java 编译器会**强制程序去捕获此类异常**，即会出现要求程序进行 try catch，如：`Thread.sleep()`、`IOException`、`SQLException`等以及用户自定义的Exception异常

**抛出异常有 3 种形式，一是 throw,一个 throws，还有一种系统自动抛异常。**



## Throw 和 throws 的区别：

1. throws 用在函数上，后面跟的是异常类，可以跟多个；而 throw 用在函数内，后面跟的是异常对象。
2.  throws 用来声明异常，让调用者只知道该功能可能出现的问题，可以给出预先的处理方式；throw 抛出具体的问题对象，执行到 throw，功能就已经结束了，跳转到调用者，并将具体的问题对象抛给调用者。也就是说 throw 语句独立存在时，下面不要定义其他语句，因为执行不到。
3.  throws 表示出现异常的一种可能性，并不一定会发生这些异常；throw 则是抛出了异常，执行 throw 则一定抛出了某种异常对象。



## 常见Exception

**运行时异常**(RuntimeException)

- NullPointerException（空指针异常）
- ArrayIndexOutOfBoundsException（数组下标越界）
- ClassNotFoundException（找不到类）
- ArithmeticException（算术异常）



**检查异常 （CheckedException）**

- IOException：输入输出异常
- SQLException：操作数据库异常
- FileNotFoundException：文件未找到异常
- NoSuchMethodException：方法未找到异常



# Throwable类常用方法

- **public string getMessage()**：返回异常发生时的详细信息
- **public string toString()**：返回异常发生时的简要描述
- **public string getLocalizedMessage()**：返回异常对象的本地化信息。使用Throwable的子类覆盖这个方法，可以声称本地化信息。如果子类没有覆盖该方法，则该方法返回的信息与getMessage（）返回的结果相同
- **public void printStackTrace()**：在控制台上打印Throwable对象封装的异常信息