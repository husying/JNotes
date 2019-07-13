# Redis

# 1、Redis 是什么？

* 是开源的高性能键值非关系型数据库。
* 支持多种类型：包括string、list、set、zset(有序集合)和hash
* 基于内存，可持久化



NoSQL（**Not Only SQL**），泛指非关系型的数据库

* 数据之间无关系，随意扩展
* 数据存储简单，可以存在内存中，读写速度快
* 不需要建表、字段。自定义格式



**Redis、Memcached、MongoDB区别：**

* Redis：
  * 基于内存操作的非关系型数据库，采用单线程-多路复用IO模型，
  * key-value方式存储，支持多种类型：包括string、hash、list、set、zset。不支持索引
  * 支持AOF和RDB两种持久化方式
  * 事务支持比较弱，只能保证事务中的每个操作连续执行
  * 使用场景：适用于对读写效率要求都很高，数据处理业务复杂和对安全性要求较高的系统；数据量较小的更性能操作和运算，Redis 只使用单核，而 Memcached 可以使用多核，所以平均每一个核上Redis在存储小数据时比Memcached性能更高。 
* Memcached：
  * 高性能的分布式的内存对象缓存系统，内存型数据库，且分布式不是在服务器端实现的，而是在客户端应用中实现的
  * key-value方式存储，数据结构单一，类似关系型数据库，支持索引，查询语言丰富，单个key-value大小有限，**一个String的value最大只支持1MB，而Redis最大支持512MB**
  * 不支持数据持久化，一旦挂了数据就都丢失了，如果想实现高可用，也是需要客户端进行双写才可以。
  * 事务方面采用 cas 保证一致性
  * 使用场景：
    * 通常在**访问量高**的Web网站和应用中使用MemCache，用来缓解数据库的压力，并且**提升网站和应用的响应速度**。
    * 用于在动态系统中减少数据库负载，提升性能；做缓存，提高性能（适合读多写少，对于数据量比较大，可以采用 sharding，如人人网大量查询用户信息、好友信息、文章信息等）。 
* MongoDB:
  * 基于分布式文件存储的文档型非关系型数据库，其优势在于查询功能比较强大，能存储海量数据。适合大数据量的存储，依赖操作系统 VM 做内存管理，吃内存也比较厉害
  * 文件存储格式为BSON（一种JSON的扩展）
  * 1.8 版本开始采用 binlog 方式支持持久化的可靠性
  * 不支持事务。
  * 使用场景：主要解决海量数据的访问效率问题。



**Memcached应用场景**

通常在**访问量高**的Web网站和应用中使用MemCache，用来缓解数据库的压力，并且**提升网站和应用的响应速度**。

**在应用程序中，我们通常在以下节点来使用MemCached：**

1. 访问频繁的数据库数据（身份token、首页动态）
2. 访问频繁的查询条件和结果
3. 作为Session的存储方式（提升Session存取性能）
4. 页面缓存
5. 更新频繁的非重要数据（访客量、点击次数）
6. 大量的hot数据

------

# 2、Redis 的优缺点

- 优点：

  1. **速度快，效率高：** 基于内存的操作，单线程多CPU，没有线程上下文切换，采用单线程-多路复用IO模型

  2. **持久化：** 支持AOF和RDB两种持久化方式

  3. **支持主从复制：** 主机会自动将数据同步到从机，可以进行读写分离。

  4. **数据类型丰富：** 除了支持string类型的value外还支持string、hash、set、sortedset、list等数据结构。

     

- **缺点：数据不一致**

  1. 主从同步，如果主机宕机，宕机前有一部分数据没有同步到从机，会导致数据不一致。

  2. q全量复制：当数据量较大时，会对主从节点和网络造成很大的开销




**Redis  为什么采用单线程？**

- 因为Redis是基于内存的操作，CPU不是Redis的瓶颈，Redis的瓶颈最有可能是机器内存的大小或者网络带宽

**Redis  单线程为什么还能这么快？**

- 因为Redis是基于内存的操作。单线程操作，避免了频繁的上下文切换
- 采用了非阻塞I/O多路复用机制

**Redis  单线程如何处理那么多的并发客户端连接？**

- redis 采用网络I/O**多路复用技术**来保证在多连接的时候， 系统的高吞吐量。

**Redis 为什么不合适当数据库来，只适合用来做缓存？**

- 不分表，没有schema，没有索引，没有外键，缺少int/date等基本数据类型

---

# 3、Redis 用来做什么

* **热点数据缓存** ：经常会被查询，但是不经常被修改或者删除的数据，特别适合将运行结果放入缓存，内存的读写速度远快于硬盘
* **Session 缓存** ： 使用hash
* **排行榜或计数** ：使用zset 中含有的scode
* **消息队列**：使用list 类型
* **发布和订阅**： 使用Stream类型



---

# 4、Redis 的数据类型

String、List、Hash、Set、zset(有序集合)

所有的数据结构都是以唯一的 key字符串作为名称，然后通过这个唯一 key 值来获取相应的 value 数据。

Redis5.0 增加了一个数据结构 **Stream**，它是一个新的强大的支持多播的可持久化的消息队列

------

**String（字符串）：**

* Redis 的字符串是动态字符串，是可以修改的字符串，内部结构实现上类似于 Java 的ArrayList，采用预分配冗余空间的方式来减少内存的频繁分配
* 扩容都是加倍现有的空间，但字符串最大长度为 512M
* 作为字符型：常见的用途就是缓存用户信息
* 作为整数型：可用来计数，如果 value 值是一个整数，还可以对它进行自增操作。自增是有范围的，它的范围是
  signed long 的最大最小值，超过了这个值，Redis 会报错
* 操作命令：get、set、expire（设置过期时间）、incr（自增一次）、incrby（自增 指定大小）

**list（列表）**：

* 相当于 Java 语言里面的 LinkedList， 插入和删除操作非常快，索引定位很慢
* 当列表弹出了最后一个元素之后，该数据结构自动被删除，内存被回收
* 列表结构常用来做异步队列使用
* 首先在列表元素较少的情况下会使用一块连续的内存存储，这个结构是 **ziplist**
* 操作命令：
  * rpush：在列表中添加一个或多个值
  * lpop：移出并获取列表的第一个元素
  * rlop：移出并获取列表的最后一个元素
  * llen：获取列表长度
  * lindex：通过索引获取列表中的元素
  * lrange：获取列表指定范围内的元素；做基于redis的分页功能，性能极佳

**hash**：

* 相当于 Java 语言里面的 HashMap，它是无序字典，同样的数组 + 链表二维结构
* Redis为了高性能，不能堵塞服务，所以采用了**渐进式 rehash 策略**。
  * 渐进式 rehash ：在 rehash 的同时，保留新旧两个 hash 结构，查询时会同时查询两个hash 结构，然后在后续的定时任务中以及 hash 的子指令中，循序渐进地将旧 hash 的内容一点点迁移到新的 hash 结构中。当 hash 移除了最后一个元素之后，该数据结构自动被删除，内存被回收
* 在做单点登录的时候，就是用这种数据结构存储用户信息，以cookieId作为key，设置30分钟为缓存过期时间，能很好的模拟出类似session的效果。
* 操作命令：
  * hset：将哈希表 key 中的字段 field 的值设为 value 。
  * hlen：获取哈希表中字段的数量
  * hgetall：获取在哈希表中指定 key 的所有字段和值
  * hget：获取存储在哈希表中指定字段的值。

**set（集合）**

* 相当于 Java 语言里面的 HashSet，它内部的键值对是无序的唯一的
* 可以做**全局去重的功能**；另外，就是利用交集、并集、差集等操作，可以计算共同喜好，全部的喜好，自己独有的喜好等功能。
* 操作命令：
  * sadd：向集合添加一个或多个成员
  * scard：获取集合的成员数
  * sismember：判断 member 元素是否是集合 key 的成员
  * smembers：

**zset(有序列表)**

* 它是一个 set，保证了内部value 的唯一性，另一方面它可以给每个 value 赋予一个 score，代表这个 value 的排序权重。
* 它的内部实现的是**跳跃列表**的数据结构。
* 可以做**排行榜应用，取TOP N操作**。



**通用规则**

list/set/hash/zset 这四种数据结构是容器型数据结构，共享下面两条通用规则

* create if not exists：如果容器里元素没有了，那么立即删除元素，释放内存
* drop if no elements：如果容器不存在，那就创建一个，再进行操作



**过期时间**

Redis 所有的数据结构都可以设置过期时间，时间到了，Redis 会自动删除相应的对象

**注意**：如果一个字符串已经设置了过期时间，然后你调用了set 方法修改了它，它的过期时间会消失

---

# 5、Redis 的持久化

redis提供两种方式进行持久化，

- RDB：以在指定的时间间隔内生成数据集的**时间点快照**
- AOF：采用日志的形式来记录每个**写操作**，并**追加**到文件中



**AOF有3种同步策略：每秒同步、每修改同步和不同步**



**RDB 和AOF 优缺点：**

- RDB：适合大规模的数据恢复；数据的完整性和一致性不高，因为RDB可能在最后一次备份时宕机了。
- RDB：可能造成服务器停止服务
  - 通过  fork 子进程来协助完成数据持久化工作的，因此，如果当数据集较大时，可能会导致整个服务器停止服务几百毫秒，甚至是1秒钟。
- AOF：数据安全性更高，数据易恢复
- AOF：数据的完整性和一致性更高；为AOF记录的内容多，文件会越来越大，数据恢复也会越来越慢。
- 对同样的数据集，AOF 文件通常要大于等价的 RDB 文件
- 根据同步策略的不同，AOF在运行效率上往往会慢于RDB



**AOF文件的体积过大的解决办法**：redis引入了AOF**重写机制压缩文件**



**AOF 重写（bgrewriteaof ）：**

* Redis 提供了 bgrewriteaof 指令用于对 AOF 日志进行瘦身。原理就是开辟一个子进程对内存进行遍历转换成一系列 Redis 的操作指
* bgrewriteaof 命令：通过**移除**AOF文件中的**冗余命令**来**重写**（rewrite）AOF文件
* AOF持久化也可以通过设置auto-aof-rewrite-percentage选项和auto-aof-rewrite-min-size选项来`自动执行`BGREWRITEAOF

------

# 6、Redis集群

场景：

- **解决单点故障问题**
- **Redis 分片的实现（重点：Redis集群是redis分片的事实标准）**

[集群参考](https://www.cnblogs.com/51life/p/10233340.html)



Redis Sentinal着眼于高可用，在master宕机时会自动将slave提升为master，继续提供服务。

Redis Cluster着眼于扩展性，在单个redis内存不足时，使用Cluster进行分片存储。

------

## 1> 主从复制

同步分为：全量同步和增量同步

**全量同步：**

* 当slave启动后，主动向master发送SYNC命令。
* master接收到SYNC命令后在后台保存快照（RDB持久化）和缓存保存快照这段时间的命令，然后将保存的快照文件和缓存的命令发送给slave。
* slave接收到快照文件和命令后加载快照文件和缓存的执行命令。
* 复制初始化后，master每次接收到的写命令都会同步发送给slave，保证主从数据一致性。

**增量同步：**

* Redis增量复制是指Slave初始化后开始正常工作时主服务器发生的写操作同步到从服务器的过程。 
* 增量复制的过程主要是主服务器每执行一个写命令就会向从服务器发送相同的写命令，从服务器接收并执行收到的写命令。



**全量复制：**

* 复制过程中主机会fork出一个子进程对内存做一份快照，并将子进程的内存快照保存为文件发送给从机，这一过程需要确保主机有足够多的空余内存
* 全量复制当数据量较大时，会对主从节点和网络造成很大的开销
  * **全量复制开销，主要有以下几项。**
  * bgsave 时间
  * RDB 文件网络传输时间
  * 从节点清空数据的时间
  * 从节点加载 RDB 的时间



主从复制特点：

- 一主多从，采用异步复制
- 主从复制对于主和从服务器都是非阻塞的，所以从服务器在进行主从复制同步时，主redis仍然可以处理外界的访问请求，自己也能正常工作，只不过去的是原来的数据
- 主从复制对于从redis服务器来说也是非阻塞的
- 提高了redis服务的扩展性

------

## 2> sentinel集群

哨兵任务：**监控**(Monitoring)、**提醒**(Notification)、**自动故障迁移**

* 它负责持续监控主从节点的健康，当主节点挂掉时，自动选择一个最优的从节点切换为主节点。
* 客户端来连接集群时，会首先连接 sentinel，通过 sentinel 来查询主节点的地址，然后再去连接主节点进行数据交互。
* 当主节点发生故障时，客户端会重新向 sentinel 要地址，sentinel 会将最新的主节点地址告诉客户端。
* 如此应用程序将无需重启即可自动完成节点切换。

---

**高可用原理**：

**1.三个定时监控任务**

* **每隔10秒，向主从节点发送info命令获取拓扑结构**
* **每隔2秒，在频道上广播对当前的对主节点判断，每个Sentinel节点都会订阅该频道**
* **每隔一秒，心跳检测，向主从节点ping**

**2.主观下线**：哨兵节点ping不通从节点，直接判定失败

**3.客观下线**：哨兵节点ping不通主节点，向其他哨兵节点咨询，过半直接判定失败

**4.领导者哨兵节点选举**：当主节点下线，哨兵节点向其他哨兵节点发送请求成为领导者命令，投票过半称为领导者。然后选出主节点

**5.故障转移**：选一个**优先级最高**、**复制偏移量最大**、**id最小**的从节点作为主节点；然后在哨兵节点集合中更新主节点

------

**哨兵选举：** **因为只能有一个sentinel节点去完成故障转移**

- 发现master下线的哨兵节点（我们称他为A）向每个哨兵发送命令，要求对方选自己为领头哨兵
- 如果目标哨兵节点没有选过其他人，则会同意选举A为领头哨兵
- 如果有超过一半的哨兵同意选举A为领头，则A当选
- 如果有多个哨兵节点同时参选领头，此时有可能存在一轮投票无竞选者胜出，此时每个参选的节点等待一个随机时间后再次发起参选请求，进行下一轮投票精选，直至选举出**领头哨兵**
- 选出领头哨兵后，领头者开始对进行故障恢复，



**主节点的选取规则如下：**

- 先优先级最高的，可以通过slave-priority配置
- 复制偏移量最大（即复制越完整）的当选
- 如果以上条件都一样，选取id最小的slave

挑选出需要继任的slaver后，领头哨兵向该数据库发送命令使其升格为master，然后再向其他slave发送命令接受新的master，最后更新数据。将已经停止的旧的master更新为新的master的从数据库，使其恢复服务后以slave的身份继续运行。	

---

**消息丢失：**

* Redis 主从采用异步复制，意味着当主节点挂掉时，从节点可能没有收到全部的同步消息，这部分未同步的消息就丢失了。
* Sentinel 无法保证消息完全不丢失，但是也尽可能保证消息少丢失。
  * 它有两个选项可以限制主从延迟过大。
  * min-slaves-to-write 1：表示主节点必须至少有一个从节点在进行正常复制，否则就停止对外写服务，丧失可用性
  * min-slaves-max-lag 10：表示如果 10s 没有收到从节点的反馈，就意味着从节点同步不正常，要么网络断开了，要么一直没
    有给反馈。

------

## 3> Cluster集群

特点：**无中心结构、使用数据分片引入哈希槽**

- **无中心结构**，每个节点保存数据和整个集群状态，每个节点都和其他所有节点连接
- 使用**数据分片引入哈希槽**（16384）来实现，节点间数据共享，可动态调整数据分布；Redis Cluster 提供了工具 redis-trib 可以让运维人员手动调整槽位的分配情况
- 高可用性，可扩展到1000个节点，节点可动态添加或删除
- 高可用性，当主节点出现宕机或网络断线等不可用时，从节点能自动提升为主节点进行处理（投票过半）。  

**容错：**

* 单主节点故障时，集群会自动将其中某个从节点提升为主节点（投票过半）
* 如果某个主节点没有从节点，那么当它发生故障时，集群将完全处于不可用状态。
  * 不过 Redis 也提供了一个参数 **cluster-require-full-coverage** 可以**允许部分节点故障**，其它节点还可以继续提供对外访问。

**网络抖动**：

* Redis Cluster 提供了一种选项 cluster-node-timeout，表示当某个节点持续 **timeout 的时间失联**时，才可以认定该节点出现故障，需要进行主从切换
* 另外一个选项 cluster-slave-validity-factor 作为倍乘系数来放大这个超时时间来宽松容错的紧急程度。如果这个系数为零，那么主从切换是不会抗拒网络抖动的。如果这个系数大于 1，它就成了主从切换的**松弛系数**

------

# 7、数据淘汰策略

redis 内存数据集大小上升到一定大小的时候，Redis 会根据自身数据淘汰策略，加载热数据到内存。

redis 提供 6种数据淘汰策略：

- volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
- volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
- volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰

----------->>>>>>>>>>>>>>>>>上3种已设置过期时间<<<<<<<<<<-----------------------------------------

- allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
- allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
- no-enviction（驱逐）：禁止驱逐数据

------

# 8、Redis 事物

redis事务是通过MULTI，EXEC，DISCARD和WATCH四个原语实现的。

redis事务分别是 multi/exec/discard。

- multi 指示事务的开始，
- exec 指示事务的执行，
- discard 指示事务的丢弃。用于丢弃事务缓存队列中的所有指令，在 exec执行之前。

Redis 的事务根本**不能算「原子性」**，而仅仅是**满足了事务的「隔离性」**，隔离性中的串行化——当前执行的事务有着不被其它事务打断的权利。



**watch 机制**

* Redis 提供了这种 watch 的机制，它就是一种乐观锁**（CAS）**

* watch 会在事务开始之前盯住 1 个或多个关键变量，当事务执行时，也就是服务器收到了 exec 指令要顺序执行缓存的事务队列时，Redis 会检查关键变量自 watch 之后，是否被修改了 (包括当前事务所在的客户端)。如果关键变量被人动过了，exec 指令就会返回 null回复告知客户端事务执行失败，这个时候客户端一般会选择重试。



**注意事项：**Redis 禁止在 multi 和 exec 之间执行 watch 指令，而必须在 multi 之前做好盯住关键变量，否则会出错。



**为什么Redis不支持回滚**

* Redis 命令只会因为错误的语法而失败（并且这些问题不能在入队时发现），或是命令用在了错误类型的键上面：
* 这也就是说，从实用性的角度来说，失败的命令是由编程错误造成的，而这些错误应该在开发的过程中被发现，而不应该出现在生产环境中。 
* 因为不需要对回滚进行支持，所以 Redis 的内部可以保持简单且快速。 

---

# 9、Redis 序列化协议

RESP 是 Redis 序列化协议的简写。它是一种直观的文本协议，优势在于实现异常简单，解析性能极好

Redis 协议将传输的结构数据分为 5 种最小单元类型，单元结束时统一加上回车换行符号\r\n。
1、单行字符串 以 + 符号开头。
2、多行字符串 以 $ 符号开头，后跟字符串长度。
3、整数值 以 : 符号开头，后跟整数的字符串形式。
4、错误消息 以 - 符号开头。
5、数组 以 * 号开头，后跟数组的长度。

单行字符串 hello world	+hello world\r\n

多行字符串 hello world	$11\r\nhello world\r\n   多行字符串当然也可以表示单行字符串。

整数 1024 		:1024\r\n

错误 参数类型错误	-WRONGTYPE Operation against a key holding the wrong kind of value

数组 [1,2,3]	*3\r\n:1\r\n:2\r\n:3\r\n

NULL 用多行字符串表示，不过长度要写成-1。		$-1\r\n

空串 用多行字符串表示，长度填 0。 	$0\r\n\r\n

---

# 10、常见问题

## 1> 缓存和数据库一致性问题

使用redis过程中，通常会这样做：先读取缓存，如果缓存不存在，则读取数据库，插入缓存

**场景1：**

- 更新数据库成功了，更新缓存是失败、导致数据不一致

**解决方案：**

- 先删除缓存，然后在更新数据库，如果删除缓存失败，那就不要更新数据库，
- 如果说删除缓存成功，而更新数据库失败，那查询的时候只是从数据库里查了旧的数据而已，
- 这样就能保持数据库与缓存的一致性。

**场景2：**

- 在高并发的情况下，线程A已经删除缓存，还未更新数据库时，线程B 发现缓存没有就从数据库查询，然后插入缓存；随后线程A 完成更新。此时，缓存和数据库就不一致

**解决方案：**

- 采用队列，将写操作放入队列，缓存中查不到数据时，去队列中查是否在更新。如果队列中有，则读操作也加入队列

------

## 2> 缓存的并发竞争问题

问题描述：

- 多客户端同时并发写一个key，可能本来应该先到的数据后到了，导致数据版本错了。
- 或者是多客户端同时获取一个key，修改值之后再写回去，只要顺序错了，数据就错了。

解决方案：

- 首先使用**分布式锁**，确保同一时间，只能有一个系统实例在操作某个key
- 修改key的值时，要先判断这值的**时间戳**是否比缓存里的值的时间戳更靠后，如果是旧数据就不要更新了

---

## 3> Redis 热点键问题

**问题产生的原因**

- 这个key是一个热点key（例如一个重要的新闻，一个热门的八卦新闻等等），所以这种key访问量可能非常大。
- 缓存的构建是需要一定时间的。（可能是一个复杂计算，例如复杂的sql、多次IO、多个依赖(各种接口)等等）于是就会出现一个致命问题：在缓存失效的瞬间，有大量线程来构建缓存，造成后端负载加大，甚至可能会让系统崩溃 。

**危害：**

- 流量集中，达到物理网卡上限
- 请求过多，缓存分片服务被打垮
- DB 击穿，引起业务雪崩



**如何发现热点数据**

- 统计请求次数
- DB 计算热点时，主要运用的方法和优势有：
  - 基于统计阀值的热点统计
  - 基于统计周期的热点统计
  - 基于版本号实现的无需重置初值统计方法
  - DB 计算同时具有对性能影响极其微小、内存占用极其微小等优点

**解决方法：**

**方案1：** 解决缓存失效引起的问题

- 使用互斥锁(mutex key)，单机用synchronized,lock等，分布式用分布式锁。"提前"使用互斥锁 

- 缓存过期时间不设置，而是设置在key对应的value里。如果检测到存的时间超过过期时间则异步更新缓存。

- 在value设置一个比过期时间t0小的过期时间值t1，当t1过期的时候，延长t1并做更新缓存操作。

  

**方案2：** key访问量过大引起

阿里云数据库解热点之道：**读写分离方案**

- SLB 层做负载均衡（SLB（集群转发层）指的是负载转发用户请求的SLB集群）
- Proxy 层做读写分离自动路由
- Master 负责写请求
- ReadOnly 节点负责读请求
- Slave 节点和 Master 节点做高可用
- 实际过程中
  -  Client 将请求传到 SLB，SLB 又将其分发至多个 Proxy 内，
  - 通过 Proxy 对请求的识别，将其进行分类发送。例如，将同为 Write 的请求发送到 Master 模块内，
  - 而将 Read 的请求发送至 ReadOnly 模块。而模块中的只读节点可以进一步扩充，从而有效解决热点读的问题。
  - 读写分离同时具有可以灵活扩容读热点能力、可以存储大量热点Key、对客户端友好等优点。
- Proxy 架构的主要有以下优点：
  - Proxy 本地缓存热点，读能力可水平扩展
  - DB 节点定时计算热点数据集合
  - DB 反馈 Proxy 热点数据
  - 对客户端完全透明，不需做任何兼容

此方案优点：

- 阿里云在解决热点 Key 上较传统方法相比都有较大的提高，无论是基于读写分离方案还是热点数据解决方案，在实际处理环境中都可以做灵活的水平能力扩充、都对客户端透明、都有一定的数据不一致性。此外读写分离模式可以存储更大量的热点数据，而基于 Proxy 的模式有成本上的优势。

---

## 4> 缓存穿透、雪崩和击穿问题

**缓存穿透：**

- 访问一个不存在的key，缓存不起作用，请求会穿透到DB，流量大时DB会挂掉。
- 解决办法：
  - 采用**布隆过滤器**
  - 访问key未在DB查询到值，也将空值写进缓存，但可以设置较短过期时间。

**缓存雪崩**：

- 大量的key设置了相同的过期时间，导致在缓存在同一时刻全部失效，造成瞬时DB请求量大、压力骤增，引起雪崩。
- 解决办法：
  - 用**锁/分布式锁**或者**队列串行访问**；一般并发量不是特别多的时候，使用最多的解决方案是加锁排队
  - **缓存失效时间均匀分布**；避免缓存集中失效，不同的key设置不同的超时时间

**缓存击穿**：

- 一个存在的key，在缓存过期的一刻，同时有大量的请求，这些请求都会击穿到DB，造成瞬时DB请求量大、压力骤增。
- 解决办法：
  - 去数据库读数据时加分布式锁
  - 设置热点数据永远不过期

---

# 11、布隆过滤器

**布隆过滤器的巨大用处就是，能够迅速判断一个元素是否在一个集合中**

**三个使用场景：**

1. 网页爬虫对URL的去重，避免爬取相同的URL地址
2. 反垃圾邮件，从数十亿个垃圾邮件列表中判断某邮箱是否垃圾邮箱（同理，垃圾短信）
3. 缓存击穿，将已存在的缓存放到布隆过滤器中，当黑客访问不存在的缓存时迅速返回避免缓存及DB挂掉。

布隆过滤器可以理解为一个不怎么精确的 set 结构，当你使用它的 contains 方法判断某个对象是否存在时，它可能会误判

**原理**

- 其内部维护一个0  和 1  的bit数组，
- 布隆过滤器有一个误判率的概念，误判率越低，则数组越长，所占空间越大。误判率越高则数组越小，所占的空间越小。

**基本指令：**

- bf.add 添加元素，一次添加一个元素
- bf.exists 查询元素是否存在，一次判读一个元素
- bf.madd ：添加元素，，一次添加多个元素
- bf.mexists：查询元素是否存在，一次判读多个元素



---

# 12、使用场景

## 1> 热数据缓存

经常会被查询，但是不经常被修改或者删除的数据，特别适合将运行结果放入缓存，内存的读写速度远快于硬盘

**什么数据可以放缓存**

* 不需要实时更新但是又极其消耗数据库的数据
* 需要实时更新，但是更新频率不高的数据
* 在某个时刻访问量极大而且更新也很频繁的数据

这类数据包括比如涉及到钱、密钥、业务关键性核心数据等不能放入缓存

---

## 2> session缓存

使用hash

---

## 3> 排行榜

zset，命令：zadd

## 4> 计数器

统计点击数

## 5> 最新列表

list，命令lpush

## 6> Redis的分布式锁

一般是使用 **setnx 指令获取锁**、**del 指令释放锁**

set成功表示获取锁，set失败表示获取失败，失败后需要重试。

- setNx一个锁key，相应的value为当前时间加上过期时间的时钟；
- 如果setNx成功，或者当前时钟大于此时key对应的时钟则加锁成功，否则加锁失败退出；
- 释放锁时判断当前时钟是否小于锁key的value，如果是则执行删除锁key的操作。

```java
public class RedisTool {

    private static final String LOCK_SUCCESS = "OK";
    private static final String SET_IF_NOT_EXIST = "NX";
    private static final String SET_WITH_EXPIRE_TIME = "PX";
    private static final Long RELEASE_SUCCESS = 1L;

    /**
     * 尝试获取分布式锁
     * @param jedis Redis客户端
     * @param lockKey 锁
     * @param requestId 请求标识
     * @param expireTime 超期时间
     * @return 是否获取成功
     */
    public static boolean tryGetDistributedLock(Jedis jedis, String lockKey, String requestId, int expireTime) {

        String result = jedis.set(lockKey, requestId, SET_IF_NOT_EXIST, SET_WITH_EXPIRE_TIME, expireTime);

        if (LOCK_SUCCESS.equals(result)) {
            return true;
        }
        return false;

    }
	/**
     * 释放分布式锁
     * @param jedis Redis客户端
     * @param lockKey 锁
     * @param requestId 请求标识
     * @return 是否释放成功
     */
    public static boolean releaseDistributedLock(Jedis jedis, String lockKey, String requestId) {

        String script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end";
        Object result = jedis.eval(script, Collections.singletonList(lockKey), Collections.singletonList(requestId));

        if (RELEASE_SUCCESS.equals(result)) {
            return true;
        }
        return false;

    }
}
```



[参考](https://www.cnblogs.com/linjiqin/p/8003838.html)

**错误示例1**

比较常见的错误示例就是使用`jedis.setnx()`和`jedis.expire()`组合实现加锁，代码如下：

```java
public static void wrongGetLock1(Jedis jedis, String lockKey, String requestId, int expireTime) {

    Long result = jedis.setnx(lockKey, requestId);
    if (result == 1) {
        // 若在这里程序突然崩溃，则无法设置过期时间，将发生死锁
        jedis.expire(lockKey, expireTime);
    }
}
//setnx()方法作用就是SET IF NOT EXIST，expire()方法就是给锁加一个过期时间。乍一看好像和前面的set()方法结果一样，然而由于这是两条Redis命令，不具有原子性，如果程序在执行完setnx()之后突然崩溃，导致锁没有设置过期时间。那么将会发生死锁。网上之所以有人这样实现，是因为低版本的jedis并不支持多参数的set()方法。
```

**错误示例2**

```java
public static boolean wrongGetLock2(Jedis jedis, String lockKey, int expireTime) {

    long expires = System.currentTimeMillis() + expireTime;
    String expiresStr = String.valueOf(expires);

    // 如果当前锁不存在，返回加锁成功
    if (jedis.setnx(lockKey, expiresStr) == 1) {
        return true;
    }

    // 如果锁存在，获取锁的过期时间
    String currentValueStr = jedis.get(lockKey);
    if (currentValueStr != null && Long.parseLong(currentValueStr) < System.currentTimeMillis()) {
        // 锁已过期，获取上一个锁的过期时间，并设置现在锁的过期时间
        String oldValueStr = jedis.getSet(lockKey, expiresStr);
        if (oldValueStr != null && oldValueStr.equals(currentValueStr)) {
            // 考虑多线程并发的情况，只有一个线程的设置值和当前值相同，它才有权利加锁
            return true;
        }
    }
        
    // 其他情况，一律返回加锁失败
    return false;

}
//错误分析
//1. 由于是客户端自己生成过期时间，所以需要强制要求分布式下每个客户端的时间必须同步。 
//2. 当锁过期的时候，如果多个客户端同时执行jedis.getSet()方法，那么虽然最终只有一个客户端可以加锁，但是这个客户端的锁的过期时间可能被其他客户端覆盖。
//3. 锁不具备拥有者标识，即任何客户端都可以解锁。
```



**错误示例3**

```java
public static void wrongReleaseLock1(Jedis jedis, String lockKey) {
    jedis.del(lockKey);
}
//这种不先判断锁的拥有者而直接解锁的方式，会导致任何客户端都可以随时进行解锁，即使这把锁不是它的
```



**错误示例4**

```java
public static void wrongReleaseLock2(Jedis jedis, String lockKey, String requestId) {
    // 判断加锁与解锁是不是同一个客户端
    if (requestId.equals(jedis.get(lockKey))) {
        // 若在此时，这把锁突然不是这个客户端的，则会误解锁
        jedis.del(lockKey);
    }
}
//错误分析
//分成两条命令去执行了；如代码注释，问题在于如果调用jedis.del()方法的时候，这把锁已经不属于当前客户端的时候会解除他人加的锁
场景:
客户端A加锁，一段时间之后客户端A解锁，在执行jedis.del()之前，锁突然过期了，此时客户端B尝试加锁成功，然后客户端A再执行del()方法，则将客户端B的锁给解除了。
```



------

**问题：**

- 1、死锁问题：如果逻辑执行到中间出现异常了，可能会导致 del 指令没有被调用，这样就会陷入死锁，锁永远得不到释放
  - expire  给锁加上一个过期时间
- 2、死锁问题：如果在 setnx 和 expire 之间服务器进程突然挂掉了，可能是因为机器掉电或者是被人为杀掉的，就会导致 expire 得不到执行，也会造成死锁。
  - Redis 2.8 版本中作者加入了 set 指令的扩展参数，使得 setnx 和expire 指令可以一起执行，彻底解决了分布式锁的乱象。
- 3、超时问题：如果在加锁和释放锁之间的逻辑执行的太长，以至于超出了锁的超时限制，就会出现问题，锁被其他线程拿走了
  - 为 set 指令的 value 参数设置为一个随机数，释放锁时先匹配随机数是否一致，然后再删除 key。匹配 value 和删除 key 不是一个原子操作，Redis 也没有提供类似于 delifequals 这样的指令，这就需要使用 Lua 脚本来处理了，因为 Lua 脚本可以保证连续多个指令的原子性执行
- 4、如果客户端在处理请求时加锁没加成功怎么办
  - 一般有 3 种策略来处理加锁失败
    - 1、直接抛出异常，通知用户稍后重试；
    - 2、sleep 一会再重试；
    - 3、将请求转移至延时队列，过一会再试

------

## 7> 分布式唯一序列号

**分布式全局唯一ID的生成方法**

* 利用数据库自增序列或字段
* UUID：无法排序
* Redis 生成ID：灵活方便，性能比数据库好；缺点：需要要引入，编码和配置的工作量大，多环境运维很麻烦
* Twitter 的snowflake算法 ：高性能，低延迟；独立的应用；按时间有序。缺点：需要独立的开发和部署
* Flicker：采用了MySQL自增长ID的机制 ，缺点：服务重启时内存中有未使用的ID，导致ID空洞



[redis 唯一ID参考](https://blog.csdn.net/hengyunabc/article/details/44244951)

---

## 8> 限流策略

1、简单限流

* 通过zset 数据结构的 score 值

2、漏斗限流

* Redis 4.0 提供了一个限流 Redis 模块，它叫 redis-cell。该模块也使用了漏斗算法，并提供了原子的限流指令
* 该模块只有 1 条指令 cl.throttle



## 9> 位操作（位图）

用于数据量上亿的场景下，例如几亿用户系统的签到，去重登录次数统计，某用户是否在线状态等等。

Redis 提供了位图数据结构，使用setbit、getbit、bitcount命令。

原理是：redis内构建一个足够长的数组，每个数组元素只能是0和1两个值，数组下标index表示上面例子的用户id（必须是数字哈）



## 10> Redis 的消息队列

- Redis 的消息队列不是专业的消息队列，它没有非常多的高级特性，**没有 ack 保证**，如果对消息的可靠性有着极致的追求，那么它就不适合使用。
- list(列表)作为异步消息队列使用，使用rpush/lpush操作入队列，使用 lpop 和 rpop 来出队列。
- **延时队列**：可以通过 Redis 的 zset(有序列表) 来实现



问题：

- 如果队列空了，客户端就会陷入 pop 的死循环，不停地 pop。这就是浪费生命的空轮询
  - 通常我们使用 sleep 来解决这个问题，让线程睡一会，睡个 1s 钟就可以了，但是这也会因睡眠会导致消息的延迟增大
  - 使用**blpop/brpop阻塞读：**在队列没有数据的时候，会立即进入休眠状态，一旦数据到来，则立刻醒过来。消息的延迟几乎为零
- 如果线程一直阻塞在哪里，Redis 的客户端连接就成了闲置连接，闲置过久，服务器一般会主动断开连接，减少闲置资源占用。这个时候 blpop/brpop 会抛出异常来
  - 注意捕获异常，还要重试
- Redis 作为消息队列为什么不能保证 100% 的可靠性
  - 消息不保证可靠，应该是消息被发送出去，消费者是否接收到消息redis不做保证，不像一般的mq，会有ack机制

------

## 11> Redis 发布订阅

PubSub模块

- 操作指令
  - publist：将信息发送到指定的频道。
  - psubscribe：订阅一个或多个符合给定模式的频道。
  - subscribe ：于订阅给定的一个或多个频道的信息。
- 缺点：
  - PubSub 的生产者传递过来一个消息，Redis 会直接找到相应的消费者传递过去。如果一个消费者都没有，那么消息直接丢弃
  - 如果 Redis 停机重启，PubSub 的消息是不会持久化的，毕竟 Redis 宕机就相当于一个消费者都没有，所有的消息直接被丢弃
  - 一个消费者突然挂掉了，重新连上的时候，这断连期间生产者发送的消息，对于这个消费者来说就是彻底丢失了。
- 补充：**近期 Redis5.0 新增了 Stream 数据结构**，**支持持久化消息队列**



**Stream ：** 参考了kafka的设计方式进行分组

- 每个 Stream 都有唯一的名称，它就是 Redis 的 key，在我们首次使用 xadd 指令追加消息时自动创建。
- 每个 Stream 都可以**挂多个消费组**，每个消费组会**有个游标** last_delivered_id 在 Stream数组之上往前移动，表示当前消费组已经消费到哪条消息了
- 每个消费组 (Consumer Group) 的状态都是**独立**的，相互不受影响。也就是说同一份Stream 内部的消息会被每个消费组都消费到。

------

## 12> HyperLogLog(基数统计)

Redis 在 2.8.9 版本添加了 HyperLogLog 结构。

HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。

HyperLogLog ：

- 优点在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定 的、并且是很小的。
- 在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存
- 操作指令：pfadd 和 pfcount、pfmerge（合并）



---

# 13、与Spring整合

## 1> redis与spring的整合方式

一般分为spring-data-redis整合和jedis整合，

* spring-data-redis整合
  * 引用的依赖：spring-data-redis
  * 通过org.springframework.data.redis.connection.jedis.JedisConnectionFactory来管理，即通过工厂类管理，然后通过配置的模版bean，操作redis服务，代码段中充斥大量与业务无关的模版片段代码，代码冗余，不易维护
  * spring 封装了 RedisTemplate 对象来进行对redis的各种操作
* jedis整合
  * 引用的依赖：jedis
  * jedis连接方式有：jedis/jedisPool 连接、ShardedJedis/ShardedJedisPool 连接、JedisCluster 连接
  * 通过redis.clients.jedis.JedisPool来管理，即通过池来管理，通过池对象获取jedis实例，然后通过jedis实例直接操作redis服务，剔除了与业务无关的冗余代码
  * JedisPool保证资源在一个可控范围内，并且提供了线程安全
  * ShardedJedisPool可以通过一致性哈希实现分布式存储。



## 2> StringRedisTemplate和RedisTemplate区别

* StringRedisTemplate继承RedisTemplate。

* 两者的数据是不共通的；也就是说StringRedisTemplate只能管理StringRedisTemplate里面的数据，RedisTemplate只能管理RedisTemplate中的数据。

* SDR默认采用的序列化策略有两种，一种是String的序列化策略，一种是JDK的序列化策略。

* StringRedisTemplate默认采用的是String的序列化策略，保存的key和value都是采用此策略序列化保存的

  RedisTemplate默认采用的是JDK的序列化策略，保存的key和value都是采用此策略序列化保存的。



**使用时注意事项:**

* 当你的Redis数据库里面本来存的是字符串数据或者是你要存取的数据就是字符串类型数据的时候，那么你就使用StringRedisTemplate即可;
* 但是如果你的数据是复杂的对象类型，而取出的时候又不想做任何数据转换，直接从Redis里面取出一个对象，那么使用RedisTemplate是更好的选择;
* RedisTemplate中存取数据都是字节数组。当Redis职工存入的数据是可读形式而非字节数组时，使用RedisTemplate取值的时候会无法获取导出数据，获得的值为null。可以使用StringRedisTemplate试试;



## 3> RedisTemplate中定义了5种数据结构操作

```java
`redisTemplate.opsForValue();　　``//操作字符串``redisTemplate.opsForHash();　　 ``//操作hash``redisTemplate.opsForList();　　 ``//操作list``redisTemplate.opsForSet();　　  ``//操作set``redisTemplate.opsForZSet();　 　``//操作有序set`
```



## 4> StringRedisTemplate常用操作

```java
stringRedisTemplate.opsForValue().set("test", "100",60*10,TimeUnit.SECONDS);//向redis里存入数据和设置缓存时间  
stringRedisTemplate.opsForValue().get("test")//根据key获取缓存中的val
stringRedisTemplate.boundValueOps("test").increment(-1);//val做-1操作
stringRedisTemplate.boundValueOps("test").increment(1);//val +1
stringRedisTemplate.getExpire("test")//根据key获取过期时间
stringRedisTemplate.getExpire("test",TimeUnit.SECONDS)//根据key获取过期时间并换算成指定单位 
stringRedisTemplate.delete("test");//根据key删除缓存
stringRedisTemplate.hasKey("546545");//检查key是否存在，返回boolean值 
stringRedisTemplate.opsForSet().add("red_123", "1","2","3");//向指定key中存放set集合
stringRedisTemplate.expire("red_123",1000 , TimeUnit.MILLISECONDS);//设置过期时间
stringRedisTemplate.opsForSet().isMember("red_123", "1")//根据key查看集合中是否存在指定数据
stringRedisTemplate.opsForSet().members("red_123");//根据key获取set集合
```

