#!/bin/bash

#-------------------
# 功能：上传ipa相关文件到ftp
# 使用方法：
# 1、参数1 桌面的文件夹名 把需要上传的文件放在此文件夹中
# 2、参数2 ftp的上传路径
#
#
#-------------------

FILE_NAME=$1
FTP_DIR_NAME=$2
HOST='run.motie.cn'
PORT='2000'
USERNAME='iosdev'
PD='motieiosdev'

lftp ${USERNAME}:${PD}@${HOST}:${PORT}
set ftp:passive-mode 1#被动模式
cd ${FTP_DIR_NAME}
lcd ~/Desktop/${FILE_NAME}
mput ${FILE_NAME}.* #批量上传
bye
