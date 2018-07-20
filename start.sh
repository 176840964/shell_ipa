#!/bin/bash

#-------------------------
# 功能：凤凰打包的入口shell
# 使用方法：
# 1、把脚本拖入终端.
# 2、参数1：workspace所在的文件路径
# 3、参数2：workspace文件名，不需要后缀
# 4、参数3：scheme
# 5、参数4：ftp中文件路径 0：Debug 1：Release 
# 6、参数5：上传ftp 1：上传  
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
 echo "参数说明：1.workspace所在路径 2.workspace文件名，不需要后缀 3.scheme 4.是否上传ftp（可选）==1）"
 exit
elif [ ! -d $1 ];then
 echo "Params Error!! The first param must be a dictionary."
 exit
fi

FILE_PATH=$1
WORKSPACE_FILE_NAME=$2
SCHEME_NAME=$3
UPLOAD_TO_FTP=$4
DATE=$(date +"%m%d_%H%M")
OUT_FILE_NAME=${SCHEME_NAME}${DATE}

#工程配置文件路径
project_infoplist_path=${FILE_PATH}/${SCHEME_NAME}/${SCHEME_NAME}/Info.plist
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})

#当前脚本路径
SCRIPT_PATH=`dirname $0`
#执行打包脚本
$SCRIPT_PATH/package_ipa.sh ${FILE_PATH} ${WORKSPACE_FILE_NAME} ${SCHEME_NAME} $4 ${OUT_FILE_NAME}

CONFIG_DIR="Debug"
if [ $4 -eq 1 ];then
	CONFIG_DIR="Release"
fi

FILE_NAME="V${bundleVersion}_${DATE}"
mkdir -p ~/Desktop/${FILE_NAME}
mv ~/Desktop/${OUT_FILE_NAME}/${SCHEME_NAME}.ipa ~/Desktop/${FILE_NAME}/${FILE_NAME}.ipa
cp ${FILE_PATH}/${SCHEME_NAME}/${SCHEME_NAME}.plist ~/Desktop/${FILE_NAME}/${FILE_NAME}.plist

cd ~/Desktop/${FILE_NAME}
/usr/libexec/PlistBuddy -c "Set :items:0:assets:0:url https://run.motie.cn/iosdev/"${SCHEME_NAME}_ipa"/"${CONFIG_DIR}"/"${FILE_NAME}".ipa" ./${FILE_NAME}.plist
#/usr/libexec/PlistBuddy -c "Set :items:0:assets:0:url https://run.motie.cn/iosdev/laikan/"${FILE_NAME}".ipa" ./${FILE_NAME}.plist
/usr/libexec/PlistBuddy -c "Set :items:0:metadata:bundle-version "${bundleVersion}"" ./${FILE_NAME}.plist

if [ $# -eq 5 ] && [ $5 -eq 1 ];then
 #上传ftp
 #$SCRIPT_PATH/upload_ipa.sh ${FILE_NAME} laikan
 $SCRIPT_PATH/upload_ipa.sh ${FILE_NAME} ${SCHEME_NAME}_ipa/${CONFIG_DIR}
fi
