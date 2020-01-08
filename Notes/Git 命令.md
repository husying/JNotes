# Git 命令

# 下载项目

通过 `git clone` 克隆远程仓库

```shell
git clone https://github.com/hsy-nfox/Job-Notes.git
```



# 提交代码

```shell
git add .
git commit -m "注释"
git push origin master
```







# 更新代码

```shell
git pull  # 更新, 这里需要确保不会冲突
```



问题： 使用 `git pull` 提示如下：

```shell
Already up to date.
```

然后 使用 git status

```shell
$ git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md
        modified:   "java/Java\345\237\272\347\241\200.md"
        modified:   "notes/Git \345\221\275\344\273\244.md"

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        java/Java IO.md
        "notes/JDK \347\211\210\346\234\254\347\211\271\346\200\247.md"

no changes added to commit (use "git add" and/or "git commit -a")

```

主要是`Your branch is up to date with 'origin/master'.`  这根本原因是版本分支的问题

**解决方式**

这时候我们就需要新建一个分支

```
$ git branch newbranch  
```

然后检查分支是否创建成功

```
$ git branch 
```

会有如下提示（前面的*代表的是当前你所在的工作分支）



然后切换到你的新分支

```
$ git checkout newbranch
```

如果不放心，还可以 $ git branch确认下

然后将你的改动提交到新分支上

```
$ git add . 
$ git commit -m "18.03.01"
```

然后`git status`检查是否成功



然后切换到主分支

```
$ git checkout master 
```

然后将新分支提交的改动合并到主分支上

```
$ git merge newbranch  
```

然后就可以push代码了

```
$ git push -u origin master
```

最后还可以删除这个分支

```
$ git branch -D newbranch
```



----

## 冲突解决

如果您舍弃线上的文件，则在推送时选择强制推送，强制推送需要执行下面的命令(默认不推荐该行为)：

```shell
git push origin master -f
```

如果您选择保留线上的 readme 文件,则需要先执行：

```shell
git pull origin master
```



## **强制覆盖**

  

```shell
git fetch --all
git reset --hard origin/master
git pull
```

