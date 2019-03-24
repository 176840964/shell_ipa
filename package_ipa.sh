#!/bin/bash

#-------------------------
# 功能：为xcode工程打ipa包
# 使用方法：
# 1、把脚本拖入终端.
# 2、参数1：workspace所在的文件路径
# 3、参数2：workspace文件名，不需要后缀
# 4、参数3：scheme
# 5、参数4：configuration 0:QATest 1:Release
# 6、参数5：输出文件名
#
# 注意事项：如果没有成功报出问题:
# Permission denied。就是没有权限.
#
# 解决办法：
# 1、为其添加可执行权限，使用命令：chmod +x shell_ipa.sh (shell_ipa.sh 为脚本绝对路径).
# 2、修改该文件 脚本.sh 的权限，使用命令：
# sudo chmod 777 脚本的绝对目录.
# 然后再执行就 OK.
#-------------------------

#参数判断
if [ $# -lt 3 ] && [ $# -gt 4 ];then
 echo "参数说明：1.workspace所在路径 2.workspace文件名，不需要后缀 3.scheme 4.输出文件夹名（可选）"
 exit 
elif [ ! -d $1 ];then
 echo "Params Error!! The first param must be a dictionary."
 exit 
fi

FILE_PATH=$1
WORKSPACE_FILE_NAME=$2
SCHEME_NAME=$3

EXPORT_OPTIONS_FILE_NAME='ExportOptions'
CONFIGURATION=QATest
if [ $4 -eq 1 ];then
    EXPORT_OPTIONS_FILE_NAME='ExportOptions(ad-hoc)'
	CONFIGURATION=Release
fi

OUT_FILE_NAME=${SCHEME_NAME}$(date +"%m%d_%H%M")
if [ $# -eq 5 ];then
 OUT_FILE_NAME=$5
fi

#clean
xcodebuild clean -workspace ${FILE_PATH}/${WORKSPACE_FILE_NAME}.xcworkspace  -scheme ${SCHEME_NAME} -configuration ${CONFIGURATION}

#archive
xcodebuild archive -workspace ${FILE_PATH}/${WORKSPACE_FILE_NAME}.xcworkspace -scheme ${SCHEME_NAME} -configuration ${CONFIGURATION} -archivePath ~/Desktop/${OUT_FILE_NAME}.xcarchive

#export ipa
xcodebuild -exportArchive -archivePath ~/Desktop/${OUT_FILE_NAME}.xcarchive -exportPath ~/Desktop/${OUT_FILE_NAME} -exportOptionsPlist ${FILE_PATH}/${SCHEME_NAME}/${EXPORT_OPTIONS_FILE_NAME}.plist

