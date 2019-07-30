#!/bin/bash
#Docker MySql Backup 备份指定容器数据库
function Usage(){
  echo "command [-d <需要备份的数据库>] [-c <容器ID>] [-h 帮助]"
  exit -1
}
while getopts ":c:d:h:" opt
do
   case $opt in 
   	c)
	container=$OPTARG
	;;
   	d)
	dbName=$OPTARG
	;;
	?)
	Usage
	;;
   esac
done
###########################默认配置####################
container=${container:="5bd1df2a8edb"}
dbName=${dbName:="dbName"}
######################################################

#确认信息
echo "#================配置检查============================"
echo -e "#操作：\t\t 备份MySql"
echo -e "#容器：\t\t $container"
echo -e "#数据库：\t $dbName"
echo -e "#确认【y/n】:\c"
read select
echo "#============================================"

if [ $select = "y" ]; then
echo "请输入数据库密码："
read -s password
command_backup="docker exec -it $container mysqldump -uroot -p$password $dbName > $container@${dbName}@$(date +%Y%m%d%H%M%S).sql"
echo "正在生成备份文件: $container@${dbName}@$(date +%Y%m%d%H%M%S).sql"
eval $command_backup
if [ 0 -eq $? ]; then echo "备份完成"; else echo "备份失败"; fi
fi
