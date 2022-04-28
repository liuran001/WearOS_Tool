export SD_PATH=$({SDCARD_PATH})
export EXECUTOR_PATH=$({EXECUTOR_PATH})
export TMPDIR=$({TEMP_DIR})
export HOME=$({START_DIR})
export APP_USER_ID=$({APP_USER_ID})
export SDK=$({ANDROID_SDK})
export Package_name=$({PACKAGE_NAME})
export Version_Name=$({PACKAGE_VERSION_NAME})
export Version_code=$({PACKAGE_VERSION_CODE})
export PREFIX=$({TOOLKIT})
export ANDROID_UID=$({ANDROID_UID})
export DATA_DIR=${HOME%/${Package_name}*}
export PATH0="$PATH"
export Pages=$PREFIX/pages
export ShellScript=$PREFIX/kr-script
export Data_Dir=$PREFIX/Data_Dir
export ELF1_Path="$PREFIX/xbin"
export which="$ELF1_Path/which"
export Core="$ShellScript/Util_Functions.sh"
export PATH="${ELF1_Path}:${PATH0}"
export TMP=/data/local/tmp
[[ -f $Core ]] && . $Core

if [[ -f "$1" ]]; then
    cd "$ShellScript"
    . "$@" &
else
    echo "${1} 脚本已丢失！"
fi
wait
exit 0
