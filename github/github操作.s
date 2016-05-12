








1:建立仓库
 git init

2:添加到仓库
 git add * | file

3:提交
 git commit -m "注释内容"


4:上传远程git(前提做好准备)

git push origin master

git push -u origin master //首次执行



=================== 4 准备工作 ===================
添加ssh-key的到github 上  

git remote add origin git@github.com:Gooooodman/django_test.git

git push -u origin master  // 首次要-u

如报错:
是否github上有文件没有在本地有则拉下来在上一步操作
git pull origin master



如报错：
加入key
ssh-keygen -C 'Email地址' -t rsa

git push  
error: The requested URL returned error: 403 Forbidden while accessing https://github.com/wangz/future.git/info/refs 

改为：
[remote "origin"]  
    url = https://Gooooodman@github.com/Gooooodman/example.git 




报错：
To https://Gooooodman@github.com/Gooooodman/modify_time.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://Gooooodman@github.com/Gooooodman/modify_time.git'
To prevent you from losing history, non-fast-forward updates were rejected
Merge the remote changes before pushing again.  See the Note about



git pull



报错：
[root@salt-client-02 LTE]# git push origin master
To git@github.com:Gooooodman/django_demo.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'git@github.com:Gooooodman/django_demo.git'
To prevent you from losing history, non-fast-forward updates were rejected
Merge the remote changes before pushing again.  See the 'Note about
fast-forwards' section of 'git push --help' for details.

解决：
[root@salt-client-02 LTE]# git pull
You have not concluded your merge (MERGE_HEAD exists).
Please, commit your changes before you can merge.
[root@salt-client-02 LTE]# git commit -m "增加语法高亮 SyntaxHighlighter"
[master da01ee4] 增加语法高亮 SyntaxHighlighter
[root@salt-client-02 LTE]# git push origin master
Counting objects: 363, done.
error: unable to find 3d0c70edc48f59415ff1ac110e664b05c23ddcdf
Compressing objects: 100% (344/344), done.
Writing objects: 100% (348/348), 621.70 KiB, done.
Total 348 (delta 78), reused 0 (delta 0)
To git@github.com:Gooooodman/django_demo.git
   5cb7c73..da01ee4  master -> master






测试：
ssh -v git@github.com


==============================================



git status  查看


git diff readme.txt  比较





回退：


git log  显示提交日志

git log --pretty=oneline  精简显示

git reset --hard HEAD^ 回退上一版本

用HEAD表示当前版本，也就是最新的提交3628164...882e1e0（注意我的提交ID和你的肯定不一样），上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100。



如果找不到日志

git reset --hard 3628164  //找到提交版本号 3628164


git reflog  记录每一次命令,以便确定要回到未来的哪个版本。


撤销
 git checkout -- readme.txt   //丢弃工作区的修改

命令git checkout -- readme.txt意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：

一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；

一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。

总之，就是让这个文件回到最近一次git commit或git add时的状态

--很重要，没有--，就变成了“切换到另一个分支”的命令



git reset HEAD readme.txt  //HEAD 回到工作区的版本

//
场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。

场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，第二步按场景1操作。

场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考版本回退一节，不过前提是没有推送到远程库。
//









删除

rm file 

git rm file 

git commit -m 'rm file'


恢复

git checkout -- file 








