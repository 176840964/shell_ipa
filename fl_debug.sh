#!/bin/bash

cd ~/ios/IFReader

SCHEME_NAME="FLReader"
DATE=$(date +"%m%d_%H%M")
OUT_FILE_NAME=${SCHEME_NAME}${DATE}
CONFIG_DIR="Debug"

#工程配置文件路径
project_infoplist_path=./${SCHEME_NAME}/Info.plist
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})

FILE_NAME="V${bundleVersion}_${DATE}"

#package
xcodebuild clean -scheme ${SCHEME_NAME}
xcodebuild archive -scheme ${SCHEME_NAME} -archivePath ~/Desktop/${OUT_FILE_NAME}.xcarchive
xcodebuild -exportArchive -archivePath ~/Desktop/${OUT_FILE_NAME}.xcarchive -exportPath ~/Desktop/${OUT_FILE_NAME} -exportOptionsPlist  ./ExportOptions.plist

mkdir -p ~/Desktop/${FILE_NAME}
mv ~/Desktop/${OUT_FILE_NAME}/${SCHEME_NAME}.ipa ~/Desktop/${FILE_NAME}/${FILE_NAME}.ipa
cp ./${SCHEME_NAME}.plist ~/Desktop/${FILE_NAME}/${FILE_NAME}.plist

cd ~/Desktop/${FILE_NAME}
/usr/libexec/PlistBuddy -c "Set :items:0:assets:0:url https://run.motie.cn/iosdev/"${SCHEME_NAME}_ipa"/"${CONFIG_DIR}"/"${FILE_NAME}".ipa" ./${FILE_NAME}.plist

/usr/libexec/PlistBuddy -c "Set :items:0:metadata:bundle-version "${bundleVersion}"" ./${FILE_NAME}.plist

#当前脚本路径
cd ~/shell/ipa_about
SCRIPT_PATH=`dirname $0`
$SCRIPT_PATH/upload_ipa.sh ${FILE_NAME} ${SCHEME_NAME}_ipa/${CONFIG_DIR}
