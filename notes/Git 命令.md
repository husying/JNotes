# Git 命令

## 下载项目

通过 `git clone` 克隆远程仓库

```shell
git clone https://github.com/hsy-nfox/Job-Notes.git
```



## 提交代码

```shell
git add .
git commit -m "注释"
git push origin master
```







## 更新代码

```shell
git pull  # 更新, 这里需要确保不会冲突
```



### 冲突解决

如果您舍弃线上的文件，则在推送时选择强制推送，强制推送需要执行下面的命令(默认不推荐该行为)：

```shell
$ git push origin master -f
```

如果您选择保留线上的 readme 文件,则需要先执行：

```shell
$ git pull origin master
```



