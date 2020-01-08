# 一、IO模型

Java的IO模型设计非常优秀，它使用Decorator**(装饰者)模式**，按功能划分Stream；

在《Unix网络编程》中分为**五种IO模型**：**阻塞IO、非阻塞IO、多路复用IO、信号驱动IO、异步IO。**

*   **阻塞IO**：即在读写数据过程中会发生阻塞现象。

*   **非阻塞IO**：当用户线程发起一个read操作后，并不需要等待，而是马上就得到了一个结果。如果结果是一个error时，它就知道数据还没有准备好，于是它可以再次发送read操作；所以事实上，在非阻塞IO模型中，用户线程需要不断地询问内核数据是否就绪，也就说**非阻塞IO不会交出CPU，而会一直占用CPU**。

*   **多路复用IO**：Java NIO实际上就是多路复用IO。在该模型中，**一个线程可以使用选择器 selector.select()不断去轮询监听多个socket的状态，查询每个通道是否有到达事件**

*   **信号驱动IO** ： 当用户线程发起一个IO请求操作，会给对应的socket注册一个信号函数，然后用户线程会继续执行，当内核数据就绪时会发送一个信号给用户线程，**用户线程接收到信号之后，便在信号函数中调用IO读写操作来进行实际的IO请求操作。**

*   **异步IO**：最理想的IO模型；当用户线程发起read操作之后，立刻就可以开始去做其它的事。而另一方面，从内核的角度，当它受到一个asynchronous read之后，它会立刻返回，说明read请求已经成功发起了，因此不会对用户线程产生任何block。然后，内核会等待数据准备完成，然后将数据拷贝到用户线程，当这一切都完成之后，内核会给用户线程发送一个信号，告诉它read操作完成了。也就说用户线程完全不需要实际的整个IO操作是如何进行的，**只需要先发起一个请求，当接收内核返回的成功信号时表示IO操作已经完成，可以直接去使用数据了。**

    

**阻塞程度：阻塞IO>非阻塞IO>多路转接IO>信号驱动IO>异步IO，效率是由低到高的**。



**多路复用IO比非阻塞IO模型的效率高**

是因为在非阻塞IO中，不断地询问socket状态时通过用户线程去进行的，而在多路复用IO中，轮询每个socket状态是内核在进行的，这个效率要比用户线程要高的多。



**生活实例举例：**

在大城市中，作为最底层的打工者，每逢过年过节时，买票都是一大问题。此处以买票为例：

1、阻塞IO：

农民工多数不会使用网络订票，都是去窗口买票。问题来了，当窗口人很多时，就需要排队，并只能一直等在那里， 什么都干不了，直到轮到他买票。这就是阻塞IO 

2、非阻塞IO：

去窗口买票，当窗口人很多需要排队时， 买票人 A 不想排队， 于是打算出去逛逛，过一段时间再来。在来时，发现还有很多人。又出去逛了逛。如此反复过来查看。 就是非阻塞方式

3、多路复用IO

买票人 A 不想排队，于是他请了个人 b，去各个售票点询问情况，并让b 盯着，无论哪个售票点人少，有票，就告诉 A，于是b 不停的咨询着各个售票点的情况。 这就是多路复用模型

4、信号IO

这个模型中买票人 A 和车站员工有点关系。于是和车站员工说有票数时告诉我一声。当有票时，车站员工打了个电话给他说“有票啦，快带着身份证过来买”。然后A 屁颠屁颠的跑过去买。

5、异步IO 

异步IO ，就是别人来帮自己做。比如，我们找黄牛买票。我们说告诉黄牛，我要一张到哪的票，帮我定一张，买到了告诉我。 黄牛就会帮你预定好，然后告诉你。预定到了，你可以去付款了。







------

# 二、IO分类

![2019-06-01_090652.png](https://github.com/HusyCoding/static-resources/blob/master/learning-notes-images/images/2019-06-01_090652.png?raw=true)

![IO](assets/IO.png)

**按照处理数据方向分类：**

*   输出流：从内存读出到文件。只能进行写操作。
*   输入流：从文件读入到内存。只能进行读操作。

注意：这里的出和入，都是相对于系统内存而言的。



**字节流与字符流区别：**

*   字符流最小的数据单元是字符，Unicode编码，**一个字符占用两个字节**；字节流最小的数据单元是字节
*   **字符流使用了缓冲区进行操作，而字节流没有使用缓冲区，是文件本身直接操作的。**
    *   **字符流只有在调用close()方法关闭缓冲区时，信息才输出**；字节流不调用colse()方法时，信息已经输出了
    *   **字符流在未关闭时输出信息，则需要手动调用flush()方法**。

```java
public static void main(String[] args) throws Exception {   // 异常抛出，  不处理    
    // 第1步：使用File类找到一个文件    
    File f1 = new File("d:" + File.separator + "test1.txt"); // 声明File  对象    
    // 第2步：通过子类实例化父类对象    
    OutputStream out = null;            
    // 准备好一个输出的对象    
    out = new FileOutputStream(f1);      
    // 通过对象多态性进行实例化    
    // 第3步：进行写操作    
    String str = "Hello World!!!";      
    // 准备一个字符串    
    byte b[] = str.getBytes();          
    // 字符串转byte数组    
    out.write(b);                      
    // 将内容输出    
    // 第4步：关闭输出流    
    // out.close();                  
    // 此时没有关闭    
    
    // 第1步：使用File类找到一个文件    
    File f2 = new File("d:" + File.separator + "test2.txt");// 声明File 对象    
    // 第2步：通过子类实例化父类对象    
    Writer out = null;                 
    // 准备好一个输出的对象    
    out = new FileWriter(f2);            
    // 通过对象多态性进行实例化    
    // 第3步：进行写操作    
    String str = "Hello World!!!";      
    // 准备一个字符串    
    out.write(str);                    
    // 将内容输出    
    // 第4步：关闭输出流    
    // out.close();                   
    // 此时没有关闭    
}  
```

test1.txt 中输出：`Hello World!!!`，此时没有关闭字节流操作，但是文件中也依然存在了输出的内容，证明字节流是直接操作文件本身的。

test2.txt 中没有任何内容，这是因为字符流操作时使用了缓冲区，而在关闭字符流时会强制性地将缓冲区中的内容进行输出，但是如果程序没有关闭，则缓冲区中的内容是无法输出的，

所以得出结论：**字符流使用了缓冲区，而字节流没有使用缓冲区。**



**字节流与字符流转化**

*   **字节流 - -> 字符流**：InputStreamReader，InputStream 到 Reader 的过程要指定编码字符集，否则将采用操作系统默认字符集，很可能会出现乱码问题，StreamDecoder 正是完成字节到字符的解码的实现类
*   **字符流 - -> 字节流**：OutputStreamWriter



InputStreamReader和OutputStreamWriter 可以通过字节码操作指定编码格式

```java
InputStream inputStream = new FileInputStream("c:\\data\\input.txt");
Reader reader = new InputStreamReader(inputStream, "UTF-8");
```



# 三、I/O 工作机制

*   I/O 操作主要是将数据持久化到物理磁盘的过程

*   数据在磁盘的唯一最小描述就是文件，换言之，文件就是操作系统和磁盘驱动器交互的一个最小单元，因为应用程序只能通过文件来操作磁盘上的数据
*   Java 中通常的 File 并不代表一个真实存在的文件对象，它只是一个代表这个路径相关联的一个虚拟对象，可能是文件也可能是目录
*   当我们创建一个 FileInputStream 对象时，会创建一个 FileDescriptor 对象
*   FileDescriptor 就是真正代表一个存在的文件对象的描述，当我们在操作一个文件对象时可以通过 getFD() 方法获取真正操作的与底层操作系统关联的文件描述



**FileInputStream 对象的构造方法如下：**

```java
public FileInputStream(File file) throws FileNotFoundException {
    String name = (file != null ? file.getPath() : null);
    SecurityManager security = System.getSecurityManager();
    if (security != null) {
        security.checkRead(name);
    }
    if (name == null) {
        throw new NullPointerException();
    }
    if (file.isInvalid()) {
        throw new FileNotFoundException("Invalid file path");
    }
    fd = new FileDescriptor(); //  ---> 真正的文件描述对象
    fd.attach(this);
    path = name;
    open(name);
}
```







# 三、I/O 中的装饰者模式

Java I/O 使用了装饰者模式来实现。以 InputStream 为例，

*   InputStream ： 是一个抽象组件
*   它有很多具体组件的实现类，如：FileInputStream 、ByteArrayInputStream 、PipedInputStream 等
*   还有装饰者对象。如：FilterInputStream ；为组件提供额外的功能，其子类有：BufferInputStream 、DataInputStream 等等

![InputStream.png](https://github.com/HusyCoding/static-resources/blob/master/learning-notes-images/images/InputStream.png?raw=true)



**范例：**

通过缓冲流来读取文件，只需要实例化一个具有缓存功能的字节流对象时，然后在 FileInputStream 对象上再套一层 BufferedInputStream 对象即可。

如：

```
FileInputStream fileInputStream = new FileInputStream(filePath);
BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);
```

DataInputStream 装饰者提供了对更多数据类型进行输入的操作，比如 int、double 等基本类型。





# 四、文件操作

## 1、常用类和方法

**文件操作主要的使用类如下：**

1.  **File**（文件特征与管理）：操作文件或者目录等信息
2.  **FileInputStream/FileOutputStream**：（二进制格式操作），基于字节的输入输出操作
3.  **FileReader/FileWriter**：（文件格式操作），基于字符的输入输出操作
4.  **BufferedReader/BufferedWriter**：缓冲区操作，提高IO处理速度
5.  **RandomAccessFile**（随机文件操作）：一个独立的类，可以从文件的任意位置进行存取（输入输出）操作。如果你需要跳跃式地读取文件其中的某些部分，可以使用RandomAccessFile。

------

**File类**：是对文件系统中文件以及文件夹进行封装的对象

```java
public boolean exists( ) 判断文件或目录是否存在
public boolean isFile( ) 判断是文件还是目录 
public boolean isDirectory( ) 判断是文件还是目录
public String getName( ) 返回文件名或目录名
public String getPath( ) 返回文件或目录的路径。
public long length( ) 获取文件的长度 
public String[ ] list ( ) 将目录中所有文件名保存在字符串数组中返回。 

// File类中还定义了一些对文件或目录进行管理、操作的方法，常用的方法有：
public boolean renameTo( File newFile );    重命名文件
public void delete( );   删除文件
public boolean mkdir( ); 创建目录

```



## 2、读取文件

### 1> 字节读取

字节操作的读取有 3 个方法

```java
方法一：
int read();  
// 其中返回值表示：返回值为文件字节，当没有字节时返回-1，可以利-1做循环控制条件


方法二：
public int read(byte[] b)  //使用缓冲数组，其函数的返回值是取到的数据的长度，当没有数据可以取时返回-1，可以利用其做循环控制的条件

方法三：
public int read(byte[] b,int off,int len) //将数据读取到数组中的指定位置，b数组中起始存放数据的位置由off指定，其返回值和上面的两种方法是一致的，此方法一般不用

```



常用方法二。第一种不推荐

```java
public static void readFile(String path) {
    File file = new File(path);
    try (InputStream input = new FileInputStream(file)) {
        
    	int length = 0 ;
        //建立缓存数组，缓存数组的大小一般都是1024的整数倍，大文件一般 10M
    	byte[] buf = new byte[1024];  
        while ((length = input.read(buf)) != -1){ 
            system.out.print(new String(buf,0 ,length));
        }
    } catch (Exception e) {
        throw new RuntimeException(e.getMessage(), e);
    }
}
```

写入操作

```java
public static void writeFile(String src,String dist) {
    try (FileInputStream in = new FileInputStream(src);
         OutputStream out = new FileOutputStream(dist);) {
        byte[] buffer = new byte[20 * 1024];
        int cnt;
        
         // read() 最多读取 buffer.length 个字节
        // 返回的是实际读取的个数
        // 返回 -1 的时候表示读到 eof，即文件尾
        while ((cnt = in.read(buffer, 0, buffer.length)) != -1) {
            out.write(buffer, 0, cnt);
        }
    } catch (Exception e) {
        throw new RuntimeException(e.getMessage(), e);
    }
}
```



### 2> 字符读取

*   读取文件，生成字符流对象，Reader。如果你想指定编码读取，可以使用 InputStreamReader
*   生成缓冲流对象，通过缓冲字符流读取文件：**read**()读取单个字符。**readLine()**读取一个文本行。

```java
File filename = new File(pathname); // 要读取以上路径的input。txt文件  
// 创建一个字符流对象 reader  

Reader reader = new FileReader(filename);
// 指定编码格式读取
InputStream inputStream= new FileInputStream(filename)
Reader reader = new InputStreamReader(inputStream, "UTF-8");

// 转化为缓冲流
// InputStreamReader只能读一个字符；BufferedReader 还可以读取一行
BufferedReader bufferedReader = new BufferedReader(reader); 

String line = "";   
// bufferedReader.readLine() 一次读取一行
while ((line = bufferedReader.readLine()) != null) {
    System.out.println(line);
}
// 装饰者模式使得 BufferedReader 组合了一个 Reader 对象
// 在调用 BufferedReader 的 close() 方法时会去调用 Reader 的 close() 方法
// 因此只要一个 close() 调用即可
bufferedReader.close();
```

**写入文件：**

```java
File writename = new File(".\\result\\en\\output.txt"); // 相对路径，如果没有则要建立一个新的output。txt文件  
writename.createNewFile(); // 创建新文件  
BufferedWriter out = new BufferedWriter(new FileWriter(writename));  
out.write("我会写入文件啦\r\n"); // \r\n即为换行  
out.flush(); // 把缓存区内容压入文件  
out.close(); // 最后记得关闭文件  

```

**为什么读取文本要用缓冲流**

*   FileInputStream/FileOutputStream：每次调用 read()/write() 都会触发一个 IO 操作，
*   BufferedReader/BufferedWriter：调用 read()/write() 并不会每次都触发一个 IO 操作，只是写到内部的buffer里面，而只有内部的 buffer 满了或者调用 flush() 才会触发 IO 操作。

------

## 3、RandomAccessFile

允许你来回读写文件，也可以替换文件中的某些部分

RandomAccessFile包含两个方法来操作文件记录指针：

*   long getFilePointer()：返回文件记录指针的当前位置
*   void seek(long pos)：将文件记录指针定位到pos位置

RandomAccessFile类在创建对象时，除了指定文件本身，还需要指定一个mode参数，该参数指定RandomAccessFile的访问模式，该参数有如下四个值：

*   r：以只读方式打开指定文件。如果试图对该RandomAccessFile指定的文件执行写入方法则会抛出IOException
*   rw：以读取、写入方式打开指定文件。如果该文件不存在，则尝试创建文件
*   rws：以读取、写入方式打开指定文件。相对于rw模式，还要求对文件的内容或元数据的每个更新都同步写入到底层存储设备，默认情形下(rw模式下),是使用buffer的,只有cache满的或者使用RandomAccessFile.close()关闭流的时候儿才真正的写到文件
*   rwd：与rws类似，只是仅对文件的内容同步更新到磁盘，而不修改文件的元数据



```java
try (RandomAccessFile raf = new RandomAccessFile(path, "r");) {
    System.out.println("RandomAccessFile的文件指针初始位置:" + raf.getFilePointer());
    raf.seek(raf.getFilePointer());
    byte[] bbuf = new byte[1024];
    int hasRead = 0;
    while ((hasRead = raf.read(bbuf)) > 0) {
        System.out.print(new String(bbuf, 0, hasRead));
    }
} catch (IOException e) {
    e.printStackTrace();
}
```



# 五、缓冲器操作

*   提供缓冲区为输入输出流，以此来提高IO处理的速度

*   可以一次读取一大块的数据，特别是在访问大量磁盘数据时，缓冲通常会让IO快上许多。
*   Java IO中主要 4 种缓冲流：BufferedInputStream、BufferedOutputStream、BufferedReader、BufferedWriter
*   缓冲区必须要 flush()  或者 内部的 buffer 满了 才会触发IO操作，当调用 close() 时，也会强制输出缓冲区数据



## 1、BufferedInputStream

*   缓冲输入流，支持`mark`和`reset`方法的功能。 

*   当创建`BufferedInputStream`时，将创建一个内部缓冲区数组。 当从流中读取或跳过字节时，内部缓冲区将根据需要从所包含的输入流中重新填充，一次有多个字节。 

*   `mark`操作会记住输入流中的一点，

*   `reset`操作会导致从最近的`mark`操作之后读取的所有字节在从包含的输入流中取出新的字节之前重新读取。



## 2、BufferedOutputStream

该类实现缓冲输出流。 通过设置这样的输出流，应用程序可以向底层输出流写入字节，而不必为写入的每个字节导致底层系统的调用。



## 3、BufferedReader

*   从字符输入流读取文本，缓冲字符，以提供字符，数组和行的高效读取。

*   可以**指定缓冲区大**小（能更高效地利用内置缓冲区的磁盘），或者可以使用默认大小。 默认值足够大，可用于大多数用途。

通常，由读取器做出的每个读取请求将引起对底层字符或字节流的相应读取请求。 因此，建议将BufferedReader包装在其read（）操作可能昂贵的读取器上， 例如，

```java
// 将缓冲指定文件的输入。
BufferedReader in = new BufferedReader(new FileReader("foo.in")); 
```

没有缓冲，每次调用read（）或readLine（）可能会导致从文件中读取字节，转换成字符，然后返回，这可能非常低效。

使用DataInputStreams进行文本输入的程序可以通过用适当的BufferedReader替换每个DataInputStream进行本地化。



## 4、BufferedWriter

*   将文本写入字符输出流，缓冲字符，以提供单个字符，数组和字符串的高效写入。

*   可以指定缓冲区大小，或者可以接受默认大小。 默认值足够大，可用于大多数用途。

提供了一个newLine（）方法，它使用平台自己的系统属性`line.separator`定义的行分隔符概念。 并非所有平台都使用换行符（'\ n'）来终止行。 因此，调用此方法来终止每个输出行，因此优选直接写入换行符。

一般来说，Writer将其输出立即发送到底层字符或字节流。 除非需要提示输出，否则建议将BufferedWriter包装在其write（）操作可能很昂贵的Writer上，例如，

```java
// 将缓冲PrintWriter的输出到文件。
PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("foo.out"))); 
```

 没有缓冲，每次调用print（）方法都会使字符转换为字节，然后立即写入文件，这可能非常低效。





# 六、序列化

## 1、概述

**对象的序列化：**把对象转换为字节序列的过程，方便存储和传输。

**对象的反序列化：**把字节序列恢复为对象的过程。

不会对静态变量进行序列化，因为序列化只是保存对象的状态，静态变量属于类的状态。



**序列化主要有两种用途：**

*   可以把的内存中的对象保存到一个文件中或者数据库；
*   可以用套接字在网络上传送对象；
*   可以通过RMI（远程方法调用）传输对象；

## 2、序列化实现

*   序列化：ObjectOutputStream.writeObject()

*   反序列化：ObjectInputStream.readObject()

```java
//序列化过程	
ObjectOutputStream oo = new ObjectOutputStream(new FileOutputStream(new File("E:/Person.txt")));
oo.writeObject(person);//Person  是一个对象，这里不写了！！
oo.close();
//反序列化过程	
ObjectInputStream ois = new ObjectInputStream(new FileInputStream(new File("E:/Person.txt")));
Person person = (Person) ois.readObject();
System.out.println("Person对象反序列化成功！");
```

**序列化的两种方式：** 

*   实现Serializable接口(隐式序列化，不需要手动)：生成一个serialVersionUID(版本号)，要保持版本号的一致 来进行序列化
*   实现Externalizable接口。(显式序列化)：需要重写readExternal和writeExternal方法
*   实现Serializable接口+添加writeObject()和readObject()方法。(显+隐序列化)
    *   writeObject和readObject是private的且是void的
    *   1，方法必须要被private修饰                                ----->才能被调用
    *   2，第一行调用默认的defaultRead/WriteObject(); ----->隐式序列化非static和transient
    *   3，调用read/writeObject()将获得的值赋给相应的值  --->显式序列化



## 3、部分属性序列化

1.  **使用`transient`关键字修饰，属性不会序列化**
2.  添加writeObject和readObject方法
3.  使用Externalizable实现

**transient**关键字的作用是：

*   阻止实例中那些用此关键字修饰的的变量序列化；

*   当对象被反序列化时，被transient修饰的变量值不会被持久化和恢复。

*   transient只能修饰变量，不能修饰类和方法。



**Externalizable和Serializable 区别：**

*   serializable序列化时不会调用默认的构造器，而Externalizable序列化时会调用默认构造器的
*   Serializable：一个对象想要被序列化，那么它的类就要实现 此接口，这个对象的所有属性（包括private属性、包括其引用的对象）都可以被序列化和反序列化来保存、传递。 
*   Externalizable：他是Serializable接口的子类，需要重写readExternal和writeExternal方法；有时我们不希望序列化那么多，可以使用这个接口，这个接口的writeExternal()和readExternal()方法可以指定序列化哪些属性。



  

## 4、相关注意事项

*   当一个父类实现序列化，子类自动实现序列化，不需要显式实现Serializable接口
*   当一个对象的实例变量引用其他对象，序列化该对象时也把引用对象进行序列化；
*   并非所有的对象都可以序列化，,至于为什么不可以，有很多原因了,比如：
    *   安全方面的原因，比如一个对象拥有private，public等field，对于一个要传输的对象，比如写到文件，或者进行rmi传输 等等，在序列化进行传输的过程中，这个对象的private等域是不受保护的。
    *   资源分配方面的原因，比如socket，thread类，如果可以序列化，进行传输或者保存，也无法对他们进行重新的资源分 配，而且，也是没有必要这样实现。  





# 资料参考

*   [深入分析 Java I/O 的工作机制](https://www.ibm.com/developerworks/cn/java/j-lo-javaio/index.html)
*   [Java IO教程 | 并发编程网](http://ifeve.com/java-io/)
*   [CyC2018 | CS-Notes](https://github.com/CyC2018)