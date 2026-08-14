#!/bin/sh
# Copyright (C) zhemed

. "$CRASHDIR"/libs/urlencode.sh
. "$CRASHDIR"/libs/check_target.sh
. "$CRASHDIR"/libs/web_get_bin.sh
. "$CRASHDIR"/libs/compare.sh
. "$CRASHDIR"/libs/set_config.sh

update_servers() { #更新servers.list
    get_bin "$TMPDIR"/servers.list public/servers.list
    [ "$?" = 0 ] && mv -f "$TMPDIR"/servers.list "$CRASHDIR"/configs/servers.list
}
gen_ua(){  #自动生成ua
    [ -z "$user_agent" -o "$user_agent" = "auto" ] && {
        if echo "$crashcore" | grep -q 'singbox'; then
            user_agent="sing-box/singbox/$core_v"
        elif [ "$crashcore" = meta ]; then
            user_agent="clash.meta/mihomo/$core_v"
        else
            user_agent="clash"
        fi
    }
    [ "$user_agent" = "none" ] && unset user_agent
}
get_core_config() { #下载内核配置文件
    gen_ua
	#仅支持完整配置文件直链，不再使用第三方订阅转换服务
    if [ -z "$Https" ]; then
        echo "-----------------------------------------------"
        logger "检测到订阅链接，本项目已移除第三方订阅转换服务！" 31
        echo -e "\033[31m请使用完整配置文件直链（配置文件管理-在线获取配置文件）或本地导入！\033[0m"
        exit 1
    fi
	Https=$(echo $Https | sed 's/\\&/\&/g')   #还原转义
    #输出
    echo "-----------------------------------------------"
    logger "正在连接服务器获取【$target】配置文件…………"
    echo -e "链接地址为：\033[4;32m$Https\033[0m"
    echo 可以手动复制该链接到浏览器打开并查看数据是否正常！
    #获取在线config文件
    core_config_new="$TMPDIR"/"$target"_config."$format"
    rm -rf "$core_config_new"
    webget "$core_config_new" "$Https" echoon rediron skipceron "$user_agent"
    if [ "$?" != "0" ]; then
        echo "-----------------------------------------------"
        logger "配置文件获取失败！" 31
        echo -e "\033[31m请检查链接格式以及网络连接状态！\033[0m"
        echo -e "\033[32m也可用浏览器下载以上链接后，手动上传到/tmp目录后执行crash命令本地导入！\033[0m"
        echo "-----------------------------------------------"
        exit 1
    fi
    Https=""
    . "$CRASHDIR"/starts/singbox_config_check.sh
	check_config
    #如果不同则备份并替换文件
    if [ -s "$core_config" ]; then
        compare "$core_config_new" "$core_config"
        [ "$?" = 0 ] || mv -f "$core_config" "$core_config".bak && mv -f "$core_config_new" "$core_config"
    else
        mv -f "$core_config_new" "$core_config"
    fi
    echo -e "\033[32m已成功获取配置文件！\033[0m"
    return 0
}
