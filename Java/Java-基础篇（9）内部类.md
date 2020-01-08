Java 类根据定义的方式不同，内部类分为**静态内部类**，**成员内部类**，**局部内部类**，**匿名内部类**四种。



# 静态或成员内部类

定义在类内部的静态类，就是静态内部类。非静态类就是成员内部类。**成员内部类不能定义静态方法和变量（final 修饰的除外）。**

```java
public class Out {
    private static int a;
    private int b;
    public static class Inner {
        public void print() {
        System.out.println(a);
        }
    }
}
```

1. 静态内部类可以访问外部类所有的静态变量和方法，即使是 private 的也一样。
2. 静态内部类和一般类一致，可以定义静态变量、方法，构造方法等。
3. 其它类使用静态内部类需要使用“外部类.静态内部类”方式，如下所示：Out.Inner inner =new Out.Inner();inner.print();
4. Java集合类HashMap内部就有一个静态内部类Entry。Entry是HashMap存放元素的抽象，HashMap 内部维护 Entry 数组用了存放元素，但是 Entry 对使用者是透明的。像这种和外部类关系密切的，且不依赖外部类实例的，都可以使用静态内部类。



# 局部内部类

**局部内部类是指定义在方法中的类**，如果一个类只在某个方法中使用，则可以考虑使用局部类

```java
public class Out {
    private static int a;
    private int b;
    public void test(final int c) {
        final int d = 1;
        class Inner {
            public void print() {
                System.out.println(c);
            }
        }
    }
}
```



# 匿名内部类

匿名内部类也就是没有名字的内部类，使用匿名内部类还有个前提条件：**必须继承一个父类或实现一个接口**

最常用的情况就是在多线程的实现上，因为要实现多线程必须继承Thread类或是继承Runnable接口

```java
public class Demo {
    public static void main(String[] args) {
        Thread t = new Thread() {
            public void run() {
                for (int i = 1; i <= 5; i++) {
                    System.out.print(i + " ");
                }
            }
        };
        t.start();
    }
}
```

