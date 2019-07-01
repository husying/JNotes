# Linux常用命令



切换ROOT 用户

```shell
su root
```





# mysql

[MySQL安装 | 菜鸟教程](https://www.runoob.com/mysql/mysql-install.html)

安装前，我们可以检测系统是否自带安装 MySQL:

```shell
rpm -qa | grep mysql
```

如果你系统有安装，那可以选择进行卸载:

```shell
rpm -e mysql　　// 普通删除模式
rpm -e --nodeps mysql　　// 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除
```

**安装 MySQL：**

接下来我们在 Centos7 系统下使用 yum 命令安装 MySQL，需要注意的是 CentOS 7 版本中 MySQL数据库已从默认的程序列表中移除，所以在安装前我们需要先去官网下载 Yum 资源包，下载地址为：<https://dev.mysql.com/downloads/repo/yum/>

![img](assets/repo-name-small.png)

```shell
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
yum install mysql-server
```

权限设置：

```shell
chown mysql:mysql -R /var/lib/mysql
```

初始化 MySQL：

```shell
mysqld --initialize
```

启动 MySQL：

```shell
systemctl start mysqld
```

查看 MySQL 运行状态：

```shell
systemctl status mysqld
```

## 验证 MySQL 安装

使用 mysqladmin 命令来检查服务器的版本

```shell
[root@host]# mysqladmin --version
```

linux上该命令将输出以下结果，该结果基于你的系统信息：

```shell
mysqladmin  Ver 8.23 Distrib 5.0.9-0, for redhat-linux-gnu on i386
```

如果以上命令执行后未输出任何信息，说明你的Mysql未安装成功。





连接到本机上的MYSQL 

```shell
mysql -uroot -p
```

连接到远程主机上的MYSQL  

```shell
# 假设远程主机的IP为：10.0.0.1，用户名为root,密码为123。则键入以下命令： 

mysql -h10.0.0.1 -uroot -p123 
```

退出MYSQL命令

```shell
exit
```

