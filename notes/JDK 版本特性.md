# JDK 版本特性

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