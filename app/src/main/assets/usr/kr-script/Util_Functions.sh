export Status=$Data_Dir/Status.log
adb() (
    local ADB=`$which adb`
    if [[ $# -eq 0 ]]; then
        exec "$ADB"
    fi
    
    case "$1" in
        help | --help | kill-server | start-server | reconnect | devices | keygen | tcpip | connect | disconnect | usb | wait-for-*)
           exec "$ADB" "$@"
        ;;
        -reset)
            "$ADB" kill-server
            exec "$ADB" start-server
    esac
    
    
    [[ -z `"$ADB" devices | egrep -vi 'List of.*'` ]] && error "！无设备连接" && exit 126
    exec "$ADB" "$@"
)

error() {
    echo "$@" 1>&2
}

abort() {
    error "$@"
    sleep 3
    exit 1
}

abort2() {
    abort -e "$@\n\n错误代码：`cat $Status`"
}

show_progress() {
    [[ -n $2 ]] && echo "progress:[$1/$2]" || echo "progress:[$1/100]"
}

adb2() { 
    if [[ "$#" -eq 0 ]]; then
        adb shell
        if [[ $? -ne 0 ]]; then
            abort "没有设备连接无法继续哦⊙∀⊙！"
        fi
    elif [[ "$1" = "-s" && "$#" -eq 2 ]]; then
        shift
        adb shell < "$1"
    elif [[ "$1" = "-c" ]]; then
        shift
        adb shell "$@"
    fi
}

adbsu() {
    local a b
    a=`adb shell su --help | grep '\-c'`
    [[ -n "$a" ]] && b=true || b=false
        if [[ "$#" -eq 0 ]]; then
            adb shell su
        elif [[ "$1" = "-s" && "$#" -eq 2 ]]; then
            shift
            adb shell su < "$1"
        elif [[ "$1" = "-c" ]]; then
            shift
            $b && adb shell su -c \'"$@"\' || echo "Link@" | adb shell su
        fi
}

Start_Time() {
    Start_ns=`date +'%s%N'`
}

End_Time() {
    #小时、分钟、秒、毫秒、纳秒
    local h min s ms ns End_ns time ms1 ms2
    End_ns=`date +'%s%N'`
    time=`expr $End_ns - $Start_ns`
    [[ -z "$time" ]] && return 0
    ns=${time:0-9}
    s=${time%$ns}
    ms1=`expr $ns / 1000000`
    ms2=`expr $ns % 1000000`
    [[ -n "$ms2" ]] && ms=$ms1.$ms2 || ms=$ms1
    
        if [[ $s -ge 3600 ]]; then
            h=`expr $s / 3600`
            h=`expr $s % 3600`
            if [[ $s -ge 60 ]]; then
                min=`expr $s / 60`
                s=`expr $s % 60`
            fi
            echo "- 本次$1用时：$h小时$min分钟$s秒$ms毫秒"
        elif [[ $s -ge 60 ]]; then
            min=`expr $s / 60`
            s=`expr $s % 60`
            echo "- 本次$1用时：$min分钟$s秒$ms毫秒"
        elif [[ -n $s ]]; then
            echo "- 本次$1用时：$s秒$ms毫秒"
        else
            echo "- 本次$1用时：$ms毫秒"
        fi
}

grep_prop() {
    local J="s/^$1=//p"
    [[ -z "$2" ]] && { getprop $1; return $?; }
    [[ -f "$2" ]] && sed -n "$J" $2 2>/dev/null | head -n 1 || return 2
}

mkdir() {
    umask 022
    `$which mkdir` "$@"
}

touch() {
    umask 022
    `$which touch` "$@"
}

set_perm() {
    chown $2:$3 $1 || return 1
    chmod $4 $1 || return 1
    CON=$5
    [ -z $CON ] && CON=u:object_r:system_file:s0
    chcon $CON $1 || return 1
}

set_perm_recursive() {
    find $1 -type d 2>/dev/null | while read dir; do
        set_perm $dir $2 $3 $4 $6
    done
        find $1 -type f -o -type l 2>/dev/null | while read file; do
            set_perm $file $2 $3 $5 $6
        done
}

mktouch() {
    mkdir -p ${1%/*} 2>/dev/null
    [[ -z $2 ]] && touch "$1" || echo "$2" > "$1"
    chmod 644 "$1"
}

Power() {
    echo "`cat /sys/class/power_supply/battery/capacity 2>/dev/null`%"
}
