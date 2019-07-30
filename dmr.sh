#!/bin/bash
#Docker Mysql Rescover   导入SQL文件，恢复数据
#为防止误删数据库，恢复数据须创建新库,可以根据实际情况自行修改
function Usage(){
  echo "command [-f <Sql文件>] [-d <需要导入数据的数据库>] [-c <容器ID>] [-h 帮助]"
  exit -1
}
while getopts ":c:d:h:f:" opt
do
   case $opt in  
        c)  
        container=$OPTARG
        ;;  
        d)  
        dbName=$OPTARG
        ;;
	f)  
        sqlFileName=$OPTARG
        ;;  
        ?)  
        Usage
        ;;  
   esac
done

###########################默认值配置########################
container=${container:="5bd1df2a8edb"}
dbName=${dbName:="law_item"}
#############################################################

#判断文件是否存在
if [ ! $sqlFileName ] ;then
echo "未指定Sql文件"
Usage
exit
fi
if [ ! -e $sqlFileName ] ;then
   echo "文件不存在"
   exit
fi

#确认信息
echo "#================配置检查============================"
echo -e "#操作：\t\t 恢复数据MySql"
echo -e "#备份文件：\t $sqlFileName"
echo -e "#容器：\t\t $container"
echo -e "#数据库：\t $dbName"
echo -e "#确认【y/n】:\c"
read select
echo "#============================================"


if [ $select = "y" ]; then
#不建议将密码以明文方式存储，尤其是正式环境
echo "请数据库输入密码："
read -s password

echo "正在创建数据库....."
#创建表
docker exec -i $container mysql -uroot -p$password << EOF 
create database $dbName; 
EOF

#如果创建表成功,导入数据
if [ 0 -eq $? ]; then
echo "创建数据库完成，正在导入数据...." 
command_rescover="docker exec -i $container mysql -uroot -p$password $dbName < $sqlFileName"
eval $command_rescover
if [ 0 -eq $? ]; then echo "恢复完成"; else echo "恢复失败"; fi	
fi
fi
