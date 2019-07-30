# DMBR
Docker MySql 的备份与恢复脚本

通过此脚本能够备份和恢复Docker下的Mysql数据库

## 如何使用？

1. 备份容器 5bd1df2a8edb 下的 school 库

./dmb.sh -c 5bd1df2a8edb -d school 

1. 将SQL导入到数据库中

./dmr.sh -c 5bd1df2a8edb -d new_school -f 20191209.sql
