# Java NIO

*   Java NIO(New IO)是一个可以替代标准Java IO API的IO API（从Java 1.4开始)，Java NIO提供了与标准IO不同的IO工作方式。
*   标准的IO基于字节流和字符流进行操作的，而NIO是**基于通道（Channel）和缓冲区（Buffer）进行操作**，数据总是从通道读取到缓冲区中，或者从缓冲区写入到通道中。

*   **Non-blocking IO，是一种同步非阻塞的I/O模型**
*   3 大核心模块：**Channel、Buffers、Selectors**



NIO 与普通 I/O 的区别主要有以下两点：

*   NIO 是非阻塞的；IO 是阻塞的
*   **NIO 面向缓冲，I/O 面向流。**
*   NIO 有选择器



**AIO (Asynchronous I/O):** 

*   AIO 也就是 NIO 2。在 Java 7 中引入了 NIO 的改进版 NIO 2
*   它是**异步非阻塞的IO模型**



## 1、Channel

### 1> 概述

基本上，所有的 IO 在NIO 中都从一个Channel 开始。Channel 有点象流。 数据可以从Channel读到Buffer中，也可以从Buffer 写到Channel中

*   既可以从通道中读取数据，又可以写数据到通道。但流的读写通常是单向的
*   通道可以异步地读写。
*   通道中的数据总是要先读到一个Buffer，或者总是要从一个Buffer中写入。



JAVA NIO中的主要Channel 的实现：

*   FileChannel：从文件中读写数据。
*   DatagramChannel：能通过UDP读写网络中的数据。
*   SocketChannel：能通过TCP读写网络中的数据。
*   ServerSocketChannel：可以监听新进来的TCP连接，像Web服务器那样。对每一个新进来的连接都会创建一个SocketChannel。

### 2> 通道读取

**FileChannel读取数据到Buffer中的示例：**

```java
RandomAccessFile aFile = new RandomAccessFile("data/nio-data.txt", "rw");
FileChannel inChannel = aFile.getChannel();

ByteBuffer buf = ByteBuffer.allocate(48);//分配一个新的字节缓冲区。

int bytesRead = inChannel.read(buf);
while (bytesRead != -1) {

    System.out.println("Read " + bytesRead);
    buf.flip();//首先读取数据到Buffer，然后反转Buffer,接着再从Buffer中读取数据

    while(buf.hasRemaining()){
        System.out.print((char) buf.get());
    }

    buf.clear();
    bytesRead = inChannel.read(buf);
}
aFile.close();
```

### 3> 通道之间的数据传输

*   **transferTo()**：将数据从源通道传输到FileChannel中

*   **transferFrom()**：将数据从FileChannel传输到其他的channel中

    

**transferFrom()**：

```java
RandomAccessFile fromFile = new RandomAccessFile("fromFile.txt", "rw");
FileChannel      fromChannel = fromFile.getChannel();

RandomAccessFile toFile = new RandomAccessFile("toFile.txt", "rw");
FileChannel      toChannel = toFile.getChannel();

long position = 0;
long count = fromChannel.size();

toChannel.transferFrom(position, count, fromChannel);

fromChannel.transferTo(position, count, toChannel);
```

注意：

**在SoketChannel的实现中，只会传输此刻准备好的数据（可能不足count字节）。不会将请求的所有数据(count个字节) 全部传输到FileChannel中。**



### 4> scatter/gather

scatter/gather用于描述从Channel中读取或者写入到Channel的操作。

*   **分散（scatter）**：从Channel中读取是指在读操作时将读取的数据写入多个buffer中。因此，Channel将从Channel中读取的数据“分散（scatter）”到多个Buffer中。
*   **聚集（gather）**：写入Channel是指在写操作时将多个buffer的数据写入同一个Channel，因此，Channel 将多个Buffer中的数据“聚集（gather）”后发送到Channel。

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body   = ByteBuffer.allocate(1024);

ByteBuffer[] bufferArray = { header, body };

channel.read(bufferArray);
channel.write(bufferArray);
```

## 2、Buffers

Java NIO中的Buffer用于和NIO通道进行交互，数据是从通道读入缓冲区，从缓冲区写入到通道中的。



### 1> 实现类

Java NIO里关键的Buffer实现：

*   ByteBuffer
*   CharBuffer
*   DoubleBuffer
*   FloatBuffer
*   IntBuffer
*   LongBuffer
*   ShortBuffer

这些Buffer覆盖了你能通过IO发送的基本数据类型：**byte, short, int, long, float, double 和 char。**

Java NIO 还有个 MappedByteBuffer，用于表示内存映射文件



### 2> 工作原理

为了理解Buffer的工作原理，需要熟悉它的三个属性：

*   **capacity**：**缓冲区最大内存容量**，你只能往里写byte、long，char等类型。一旦Buffer满了，需要将其清空（通过读数据或者清除数据）才能继续写数据往里写数据
*   **position**：表示当前的位置；当将Buffer从写模式切换到读模式，position会被重置为0；每次读写都会向前移动
*   **limit**：
    *   读模式，表示剩余数据容量。
    *   写模式表示最多数据容量，limit等于Buffer的capacity；
    *   当写模式切换到读模式时，limit会被设置成写模式下的position值

position和limit的含义取决于Buffer处在读模式还是写模式



### 3> 读写过程

**Buffer读写数据四个步骤：**

1.  写入数据到Buffer，buffer会记录下写了多少数据
2.  调用`flip()`方法，该方法将Buffer从写模式切换到读模式。
3.  从Buffer中读取数据，在读模式下，可以读取之前写入到buffer的所有数据。
4.  调用`clear()`方法或者`compact()`方法：清空缓冲区，clear()方法会清空整个缓冲区。compact()方法只会清除已经读过的数据，未读的数据都被移到缓冲区的起始处，新写入的数据将放到缓冲区未读数据的后面。



**Buffer#flip()方法**

flip方法将Buffer从写模式切换到读模式。调用flip()方法会将position设回0，并将limit设置成之前position的值。



**状态变量的改变过程举例：**

① 新建一个大小为 8 个字节的缓冲区，此时 position 为 0，而 limit = capacity = 8。capacity 变量不会改变，下面的讨论会忽略它。



![1bea398f-17a7-4f67-a90b-9e2d243eaa9a.png](assets/1bea398f-17a7-4f67-a90b-9e2d243eaa9a.png)

② 从输入通道中读取 5 个字节数据写入缓冲区中，此时 position 为 5，limit 保持不变。

![80804f52-8815-4096-b506-48eef3eed5c6.png](assets/80804f52-8815-4096-b506-48eef3eed5c6.png)

③ 在将缓冲区的数据写到输出通道之前，需要先调用 flip() 方法，这个方法将 limit 设置为当前 position，并将 position 设置为 0。

![952e06bd-5a65-4cab-82e4-dd1536462f38.png](assets/952e06bd-5a65-4cab-82e4-dd1536462f38.png)

④ 从缓冲区中取 4 个字节到输出缓冲中，此时 position 设为 4。

![b5bdcbe2-b958-4aef-9151-6ad963cb28b4.png](assets/b5bdcbe2-b958-4aef-9151-6ad963cb28b4.png)

⑤ 最后需要调用 clear() 方法来清空缓冲区，此时 position 和 limit 都被设置为最初位置。

![67bf5487-c45d-49b6-b9c0-a058d8c68902.png](assets/67bf5487-c45d-49b6-b9c0-a058d8c68902.png)

### 4> 代码示范

```java
public static void fastCopy(String src, String dist) throws IOException {
    /* 获得源文件的输入字节流 */
    FileInputStream fin = new FileInputStream(src);
    /* 获取输入字节流的文件通道 */
    FileChannel fcin = fin.getChannel();
    /* 获取目标文件的输出字节流 */
    FileOutputStream fout = new FileOutputStream(dist);
    /* 获取输出字节流的文件通道 */
    FileChannel fcout = fout.getChannel();
    /* 为缓冲区分配 1024 个字节 */
    ByteBuffer buffer = ByteBuffer.allocateDirect(1024);
    while (true) {
        /* 从输入通道中读取数据到缓冲区中 */
        int r = fcin.read(buffer);
        /* read() 返回 -1 表示 EOF */
        if (r == -1) {
            break;
        }
        /* 切换读写 */
        buffer.flip();
        /* 把缓冲区的内容写入输出文件中 */
        fcout.write(buffer);
        /* 清空缓冲区 */
        buffer.clear();
    }
}

```



### 5> 常用方法

**allocate()**：分配一个新的字节缓冲区

**flip()** ：将Buffer从写模式切换到读模式。调用flip()方法会将position设回0，并将limit设置成之前position的值。

**get()**：从Buffer中读取数据，另一种方式，从Buffer读取数据到Channel。

```java
// 从Buffer读取数据到Channel的例子：
int bytesWritten = inChannel.write(buf);

// 使用get()方法从Buffer中读取数据的例子
byte aByte = buf.get();
```

**rewind()**：将position设回0，所以你可以重读Buffer中的所有数据。limit保持不变，仍然表示能从Buffer中读取多少个元素（byte、char等）。



**clear()与compact()**

*   clear()方法，position将被设回0，limit被设置成 capacity的值。换句话说，Buffer 被清空了。
*   compact()方法，将所有未读的数据拷贝到Buffer起始处，然后将position设到最后一个未读元素正后面。limit属性依然像clear()方法一样，设置成capacity。现在Buffer准备好写数据了，但是不会覆盖未读的数据。



**mark()与reset()**

*   可以标记Buffer中的一个特定position。之后可以通过调用Buffer.reset()方法恢复到这个position



**equals()与compareTo()**

*   equals() ：判断是否相等，通过（类型、剩余容量个数、）
*   compareTo()：比较两个Buffer的剩余元素个数(byte、char等)



## 3、Selectors

### 1> 概述

**Selectors（选择器）**：用于监听多个通道的事件

通过选择器实现了IO 的多路复用模型，一个线程可以使用一个选择器 ，然后通过轮询的方式去监听多个通道 Channel 上的事件，从而让一个线程就可以处理多个事件。避免了进入阻塞状态一直等待。

注意：

只有套接字 Channel 才能配置为非阻塞，而 FileChannel 不能，为 FileChannel 配置非阻塞也没有意义。

![overview-selectors.png](assets/overview-selectors.png)

### 2> 选择器创建

```java
Selector selector = Selector.open();
```

### 3> 将通道注册到选择器上

```java
ServerSocketChannel ssChannel = ServerSocketChannel.open();
channel.configureBlocking(false);  // 非阻塞模式
SelectionKey key = channel.register(selector, Selectionkey.OP_READ);
```

ServerSocketChannel  可以设置成非阻塞模式。在非阻塞模式下，accept() 方法会立刻返回，如果还没有新进来的连接,返回的将是null。 因此，需要检查返回的SocketChannel是否是null

```java
ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
serverSocketChannel.socket().bind(new InetSocketAddress(9999));
serverSocketChannel.configureBlocking(false); // 非阻塞模式

while(true){
    SocketChannel socketChannel =  serverSocketChannel.accept();
    if(socketChannel != null){
        //do something with socketChannel...
    }
}
```



可以监听四种不同类型的事件：

1.  SelectionKey.OP_READ
2.  SelectionKey.OP_WRITE
3.  SelectionKey.OP_CONNECT
4.  SelectionKey.OP_ACCEPT

```java 
public static final int OP_READ = 1 << 0;  
public static final int OP_WRITE = 1 << 2;
public static final int OP_CONNECT = 1 << 3;
public static final int OP_ACCEPT = 1 << 4;
```

可以用“位或”操作符将常量连接起来，如下：

```java
int interestSet = SelectionKey.OP_READ | SelectionKey.OP_WRITE;
```

### 4> 监听事件

一旦向Selector注册了一或多个通道，就可以调用几个重载的select()方法。

下面是select()方法：

*   int select()：阻塞到至少有一个通道在你注册的事件上就绪了；返回的int值表示有多少通道已经就绪
*   int select(long timeout)：和select()一样
*   int selectNow()：不会阻塞，不管什么通道就绪都立刻返回

```java
int num = selector.select();
```

### 5> 获取到达事件

**selectedKeys()**：已选择的键集合

*   当像Selector注册Channel时，Channel.register()方法会返回一个SelectionKey 对象。这个对象代表了注册到该Selector的通道。
*   可以通过SelectionKey的selectedKeySet()方法访问这些对象。

```java
Set selectedKeys = selector.selectedKeys();
Iterator keyIterator = selectedKeys.iterator();
while(keyIterator.hasNext()) {
    SelectionKey key = keyIterator.next();
    if(key.isAcceptable()) {
        // a connection was accepted by a ServerSocketChannel.
    } else if (key.isConnectable()) {
        // a connection was established with a remote server.
    } else if (key.isReadable()) {
        // a channel is ready for reading
    } else if (key.isWritable()) {
        // a channel is ready for writing
    }
    keyIterator.remove();
}
```

这个循环遍历已选择键集中的每个键，并检测各个键所对应的通道的就绪事件。

注意每次迭代末尾的 `keyIterator.remove()`  调用。Selector 不会自己从已选择键集中移除SelectionKey实例。必须在处理完通道时自己移除。下次该通道变成就绪时，Selector会再次将其放入已选择键集中。



### 6> 代码实践

套接字 NIO 实例

客户端：

```java
public class NIOClient {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("127.0.0.1", 8888);
        OutputStream out = socket.getOutputStream();
        String s = "hello world";
        out.write(s.getBytes());
        out.close();
    }
}
```

服务端：

```java
public class NIOServer {
    public static void main(String[] args) throws IOException {
		// 创建一个选择器
        Selector selector = Selector.open();
		// 创建一个监听通道
        ServerSocketChannel ssChannel = ServerSocketChannel.open();
        ssChannel.configureBlocking(false);  // 非阻塞方式
        // 将通道注册到选择器
        ssChannel.register(selector, SelectionKey.OP_ACCEPT);// 监听接收事件

        // 通过通过监听通道获取一个Socket 服务端
        ServerSocket serverSocket = ssChannel.socket();
        InetSocketAddress address = new InetSocketAddress("127.0.0.1", 8888);
        serverSocket.bind(address);

        while (true) {// 循环监听
            selector.select();   // 阻塞式 监听
            Set<SelectionKey> keys = selector.selectedKeys(); // 获取已选择的键集合
            
            Iterator<SelectionKey> keyIterator = keys.iterator();
            while (keyIterator.hasNext()) {
                SelectionKey key = keyIterator.next();
                if (key.isAcceptable()) { // 判断是接收事件
                    // 获取事件的通道
                    ServerSocketChannel ssChannel1 
                        		= (ServerSocketChannel) key.channel();

                    // 监听新进来的连接
                    // 服务器会为每个新连接创建一个 SocketChannel
                    SocketChannel sChannel = ssChannel1.accept();  
                    // 非阻塞方式,
                    sChannel.configureBlocking(false);

                    // 这个新连接主要用于从客户端读取数据
                    sChannel.register(selector, SelectionKey.OP_READ);

                } else if (key.isReadable()) {

                    SocketChannel sChannel = (SocketChannel) key.channel();
                    // 读取操作
                    System.out.println(readDataFromSocketChannel(sChannel));
                    sChannel.close();
                }

                keyIterator.remove(); // 手动移除实例
            }
        }
    }

    private static String readDataFromSocketChannel(SocketChannel sChannel) throws IOException {

        ByteBuffer buffer = ByteBuffer.allocate(1024);// 分配一个新的字节缓冲区。
        StringBuilder data = new StringBuilder();

        while (true) {
            buffer.clear(); // 清除此缓冲区
            int n = sChannel.read(buffer);
            if (n == -1) {
                break;
            }
            //调用flip()方法会将position设回0，并将limit设置成之前position的值。
            buffer.flip(); // 翻转这个缓冲区。写模式切换到读模式
            int limit = buffer.limit();
            char[] dst = new char[limit];
            for (int i = 0; i < limit; i++) {
                dst[i] = (char) buffer.get(i);
            }
            data.append(dst);
            buffer.clear(); // 清除此缓冲区
        }
        return data.toString();
    }
}
```



# 资料参考

*   [Java IO教程 | 并发编程网](http://ifeve.com/java-io/)
*   [CyC2018 | CS-Notes](https://github.com/CyC2018)

