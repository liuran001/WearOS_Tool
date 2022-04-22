cat <<Han
<?xml version="1.0" encoding="utf-8"?>
<resource dir="file:///android_asset/Configuration_File" />
<group>
Han

cat <<Han
    <text visible="echo $show1">
        <slices>
            <slice bold="true" size="20" align="center" break="true">$title</slice>
        </slices>
    </text>
</group>
Han

if $show; then
cat <<Han
<group title="搜索">
    <action reload="true" interruptible="false">
        <title>搜索本页功能</title>
        <params>
            <param name="Content" title="输入你要搜索的功能标题，不区分大小写" required="true" />
        </params>
        <set>. ./Search_Content.sh \$Pages/ADB</set>
    </action>
    <page title="搜索结果" config-sh="cat \$Pages/ADB/Search_Results.xml" visible="[[ \`wc -l 2>/dev/null &#60; \$Pages/ADB/Search_Results.xml\` -gt 13 ]] &#38;&#38; echo 1 || echo 0"/>
</group>
<group title="连接设备信息">
<!-- START -->
    <action>
        <title>网络ADB模式下</title>
        <desc>点击获取详细信息</desc>
        <summary sh=". ./ADB/List_of_devices.sh -0"></summary>
        <set>. ./ADB/Connection_device_information.sh</set>
    </action>
<!-- END -->
<action reload="true" auto-off="true">
        <title>刷新连接状态</title>
</action>
</group>
<group title="连接与断开">
    <action reload="true">
        <title>连接/断开设备</title>
        <desc>请确保在同一WiFi局域网内，且对方设备已开启网络ADB服务</desc>
        <params>
            <param name="port" label="输入端口" value="5555" required="true" value-sh="grep_prop port \$Data_Dir/Connect_Network_adb.log"/>
            <param name="fs" label="选择方式" options-sh="printf 'l|连接\nd|断开\nr|重新连接'" required="true"value-sh="grep_prop fs \$Data_Dir/Connect_Network_adb.log"/>
            <param name="ip" title="输入要连接的设备ip地址"  required="true" value-sh="grep_prop ip \$Data_Dir/Connect_Network_adb.log"/>
        </params>
        <set>. ./ADB/Connect_Network_adb.sh</set>
    </action>
</group>
<group title="快捷功能">
    <action interruptible="false">
        <title>安装单个应用</title>
        <summary>支持apk/apks/xapk/apex文件，请确定开发者选项里的USB安装是否打开，如果初次安装那个应用，需要在弹出安装提示界面时选择继续安装才可以</summary>
        <set>. ./ADB/install_apk.sh</set>
        <params>
            <param name="Delete_APK" label="是否安装成功后自动删除安装包" type="switch" />
            <param name="File" type="file" editable="true" required="true" title="可输入文件绝对路径，也可以使用文件选择器选择文件" desc="温馨提示：可用「MT管理器」长按目录或文件 -->点属性 -->点击目录即可复制目录绝对路径，长按目录或长按名称即可复制文件绝对路径" />
        </params>
    </action>
    <action interruptible="true">
        <title>批量静默安装某目录里的所有安装包</title>
        <desc>该功能会循环遍历指定目录里的所有APK，进行静默安装。</desc>
        <summary>支持apk/apks/xapk/apex文件，请确定开发者选项里的USB安装是否打开，如果初次安装那个应用，需要在弹出安装提示界面时选择继续安装才可以</summary>
        <set>. ./ADB/Batch_installation.sh</set>
        <params>
            <param name="Search_Dir" label="搜索子目录下的模块？" type="checkbox" />
            <param name="Delete_APK" label="是否安装成功后自动删除安装包" type="switch" />
            <param name="log" label="同时打印安装日志到内部储存" type="switch" />
            <param name="File_Dir" title="可输入目录绝对路径，也可以通过文件选择器长按选定目录" type="folder" editable="true" required="true" desc="上面是默认路径，请自行根据需求更改目录，温馨提示：可用「MT管理器」长按目录或文件 -->点属性 -->点击目录即可复制目录绝对路径，长按目录或长按名称即可复制文件绝对路径" value-sh="Dir=\$Data_Dir/Batch_installation.log; if [[ -f \$Dir ]]; then cat \$Dir; else echo \$lu; fi " />
        </params>
    </action>
    <action interruptible="true">
        <title>推送文件</title>
        <desc>用于推送文件到对方设备</desc>
        <set>. ./ADB/Read_Push_files.sh -push</set>
        <params>
            <param name="Dir" title="可输入目录绝对路径，也可以通过文件选择器长按选定目录" type="folder" editable="true" />
            <param name="File" type="file" editable="true" title="当上面为空时可选取文件绝对路径，也可以使用文件选择器选择文件推送" desc="温馨提示：可用「MT管理器」长按目录或文件 -->点属性 -->点击目录即可复制目录绝对路径，长按目录或长按名称即可复制文件绝对路径" />
            <param name="Target" title="要推送到的对方设备目录" desc="默认路径内部储存根目录" required="true" value="/sdcard" />
        </params>
    </action>
    <action auto-off="true">
        <title>自定义dpi（屏幕密度）</title>
        <set>. ./ADB/dpi.sh</set>
        <params>
            <param name="dpi" title="请输入你要修改的dpi值，留空为恢复默认，为了保险默认限制为3位数字，设置过低可能会导致部分软件闪退哦﻿⊙∀⊙！" type="int" min="220" max="700" maxlength="3"/>
        </params>
    </action>
    <action auto-off="true">
        <title>自定义修改屏幕分辨率</title>
        <set>. ./ADB/Screen_Size.sh</set>
        <params>
            <param name="Screen_Size0" label="勾选这里为恢复默认" desc="当勾选时下方修改会无效" type="checkbox" />
            <param name="Screen_Size_X" title="输入屏幕横向数值" placeholder="例如：1080" type="int" />
            <param name="Screen_Size_Y" title="输入屏幕竖向数值" placeholder="例如：2400" type="int" />
        </params>
    </action>
    <action>
        <title>一键激活指令</title>
        <set>. ./ADB/Activation_Option_Set.sh</set>
        <params>
            <param name="APK" title="请选择应用 &amp; 功能：" options-sh=". ./ADB/Activation_Option.sh" />
        </params>
    </action>
</group>
<group title="功能区">
        <page title="应用程序管理" config-sh="cat \$Pages/ADB/APK.xml" />
        <page title="系统/网络ADB模式功能区" config-sh="cat \$Pages/ADB/System_Pattern.xml" />
        <page title="高级重启" config-sh="cat \$Pages/ADB/ADB_Advanced_Restart.xml" />
</group>
<group title='更多功能'>
    <action>
        <title>脚本执行器</title>
        <params>
            <param name="CMD" title="输入命令点击确认即可，多行命令用键盘上的回车换行" desc="可通过which 命令、去查找命令是否存在" required="true" value-sh="cat \$ShellScript/Shell2.sh" />
        </params>
        <set>. ./Shell.sh</set>
    </action>
    <action>
        <title>脚本执行器-执行.sh脚本</title>
        <params>
            <param name="File" type="file" suffix="sh" editable="true" title="可输入.sh文件绝对路径，也可以使用文件选择器选择文件" desc="温馨提示：可用「MT管理器」长按目录或文件 --&gt;点属性 --&gt;点击目录即可复制目录绝对路径，长按目录或长按名称即可复制文件绝对路径" required="true"/>
        </params>
        <set>cd /; . &#34;\$File&#34;</set>
    </action>
</group>
Han
fi
