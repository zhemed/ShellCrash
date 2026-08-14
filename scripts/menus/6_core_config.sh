#!/bin/sh
# Copyright (C) zhemed

[ -n "$__IS_MODULE_6_CORECONFIG_LOADED" ] && return
__IS_MODULE_6_CORECONFIG_LOADED=1

YAMLSDIR="$CRASHDIR"/yamls
JSONSDIR="$CRASHDIR"/jsons

#导入订阅、配置文件相关
set_singbox_adv(){ #自定义singbox配置文件
		echo "-----------------------------------------------"
		echo -e "支持覆盖脚本设置的模块有：\033[0m"
		echo -e "\033[36mlog dns ntp certificate experimental\033[0m"
		echo -e "支持与内置功能合并(但不可冲突)的模块有：\033[0m"
		echo -e "\033[36mendpoints inbounds outbounds providers route services\033[0m"
		echo -e "将相应json文件放入\033[33m$JSONSDIR\033[0m目录后即可在启动时自动加载"
		echo "-----------------------------------------------"
		echo -e "使用前请务必参考配置教程:\033[32;4m https://github.com/zhemed/ShellCrash/nWTjEpkSK \033[0m"
}
override(){ #配置文件覆写
	[ -z "$rule_link" ] && rule_link=1
	[ -z "$server_link" ] && server_link=1
	echo "-----------------------------------------------"
	echo -e "\033[30;47m 欢迎使用配置文件覆写功能！\033[0m"
	echo "-----------------------------------------------"
	echo -e " 1 自定义\033[32m端口及秘钥\033[0m"
	echo -e " 5 \033[32m自定义\033[0m高级功能"
	[ "$disoverride" != 1 ] && echo -e " 9 \033[33m禁用\033[0m配置文件覆写"
	echo "-----------------------------------------------"
	[ "$inuserguide" = 1 ] || echo -e " 0 返回上级菜单"
	read -p "请输入对应数字 > " num
	case "$num" in
	0)
	;;
	1)
		if [ -n "$(pidof CrashCore)" ];then
			echo "-----------------------------------------------"
			echo -e "\033[33m检测到服务正在运行，需要先停止服务！\033[0m"
			read -p "是否停止服务？(1/0) > " res
			if [ "$res" = "1" ];then
				"$CRASHDIR"/start.sh stop
				setport
			fi
		else
			setport
		fi
		override
	;;
	5)
		set_singbox_adv
		sleep 3
		override
	;;
	9)
		echo "-----------------------------------------------"
		echo -e "\033[33m此功能可能会导致严重问题！启用后脚本中大部分功能都将禁用！！！\033[0m"
		echo -e "如果你不是非常了解$crashcore的运行机制，切勿开启！\033[0m"
		echo -e "\033[33m继续后如出现任何问题，请务必自行解决，一切提问恕不受理！\033[0m"
		echo "-----------------------------------------------"
		sleep 2
		read -p "我确认遇到问题可以自行解决[1/0] > " res
		[ "$res" = '1' ] && {
			disoverride=1
			setconfig disoverride $disoverride
			echo "-----------------------------------------------"
			echo -e "\033[32m设置成功！\033[0m"
		}
		override
	;;
	*)
		errornum
	;;
	esac
}

jump_core_config(){ #调用工具下载
	. "$CRASHDIR"/starts/core_config.sh && get_core_config
	if [ "$?" = 0 ];then
		if [ "$inuserguide" != 1 ];then
			read -p "是否启动服务以使配置文件生效？(1/0) > " res
			[ "$res" = 1 ] && start_core || main_menu
			exit;
		fi
	fi
}
set_core_config_link(){ #直接导入配置
	echo "-----------------------------------------------"
	echo -e "\033[32m仅限导入完整的配置文件链接！！！\033[0m"
	echo "-----------------------------------------------"
	echo -e "注意：\033[31m此功能不兼容“跳过证书验证”功能，部分老旧\n设备可能出现x509报错导致节点不通\033[0m"
	echo -e "你也可以搭配在线订阅转换网站或者自建SubStore使用"
	echo "$crashcore" | grep -q 'singbox' &&echo -e "singbox内核建议使用自己的订阅转换服务"
	echo "-----------------------------------------------"
	echo -e "\033[33m0 返回上级菜单\033[0m"
	echo "-----------------------------------------------"
	read -p "请输入完整链接 > " link
	test=$(echo $link | grep -iE "tp.*://" )
	link=`echo ${link/\ \(*\)/''}`   #删除恶心的超链接内容
	link=`echo ${link//\&/\\\&}`   #处理分隔符
	if [ -n "$link" -a -n "$test" ];then
		echo "-----------------------------------------------"
		echo -e 请检查输入的链接是否正确：
		echo -e "\033[4;32m$link\033[0m"
		read -p "确认导入配置文件？原配置文件将被备份![1/0] > " res
			if [ "$res" = '1' ]; then
				#将用户链接写入配置
				Url=''
				Https="$link"
				setconfig Https "'$Https'"
				setconfig Url
				#获取在线yaml文件
				jump_core_config
			else
				set_core_config_link
			fi
	elif [ "$link" = 0 ];then
		i=
	else
		echo "-----------------------------------------------"
		echo -e "\033[31m请输入正确的配置文件链接地址！！！\033[0m"
		echo -e "\033[33m仅支持http、https、ftp以及ftps链接！\033[0m"
		sleep 1
		set_core_config_link
	fi
}

#配置文件主界面
set_core_config(){
	[ -z "$rule_link" ] && rule_link=1
	[ -z "$server_link" ] && server_link=1
	config_path="$JSONSDIR"/config.json
	echo "-----------------------------------------------"
	echo -e "\033[30;47m ShellCrash配置文件管理\033[0m"
	echo "-----------------------------------------------"
	if [ -f "$CRASHDIR"/v2b_api.sh ];then
		echo -e " 1 登录\033[33m获取订阅(推荐！)\033[0m"
	else
		echo -e " 1 在线\033[33m获取配置文件\033[0m(完整配置直链)"
	fi
	echo -e " 2 本地\033[33m上传完整配置文件\033[0m"
	echo -e " 3 设置\033[36m自动更新\033[0m"
	echo -e " 4 \033[32m自定义\033[0m配置文件"
	echo -e " 5 \033[33m更新\033[0m配置文件"
	echo -e " 6 \033[36m还原\033[0m配置文件"
	echo -e " 7 自定义浏览器UA  \033[32m$user_agent\033[0m"
	echo "-----------------------------------------------"
	[ "$inuserguide" = 1 ] || echo -e " 0 返回上级菜单"
	read -p "请输入对应数字 > " num
	case "$num" in
	0)
	;;
	1)
		if [ -f "$CRASHDIR"/v2b_api.sh ];then
			. "$CRASHDIR"/v2b_api.sh
			set_core_config
		else
			set_core_config_link
		fi
		set_core_config
	;;
	2)
		echo "-----------------------------------------------"
		echo -e "\033[33m请将本地配置文件上传到/tmp目录并重命名为config.json\033[0m"
		echo -e "\033[32m之后重新运行本脚本即可自动弹出导入提示！\033[0m"
		exit
	;;
	3)
		. "$CRASHDIR"/menus/5_task.sh && task_menu
		set_core_config
	;;
	4)
		checkcfg=$(cat $CFG_PATH)
		override
		if [ -n "$PID" ];then
			checkcfg_new=$(cat $CFG_PATH)
			[ "$checkcfg" != "$checkcfg_new" ] && checkrestart
		fi
		set_core_config
	;;
	5)
		if [ -z "$Url" -a -z "$Https" ];then
			echo "-----------------------------------------------"
			echo -e "\033[31m没有找到你的配置文件/订阅链接！请先输入链接！\033[0m"
			sleep 1
			set_core_config
		else
			echo "-----------------------------------------------"
			echo -e "\033[33m当前系统记录的链接为：\033[0m"
			echo -e "\033[4;32m$Url$Https\033[0m"
			echo "-----------------------------------------------"
			read -p "确认更新配置文件？[1/0] > " res
			if [ "$res" = '1' ]; then
				jump_core_config
			else
				set_core_config
			fi
		fi
	;;
	6)
		if [ ! -f ${config_path}.bak ];then
			echo "-----------------------------------------------"
			echo -e "\033[31m没有找到配置文件的备份！\033[0m"
			set_core_config
		else
			echo "-----------------------------------------------"
			echo -e 备份文件共有"\033[32m`wc -l < ${config_path}.bak`\033[0m"行内容，当前文件共有"\033[32m`wc -l < ${config_path}`\033[0m"行内容
			read -p "确认还原配置文件？此操作不可逆！[1/0] > " res
			if [ "$res" = '1' ]; then
				mv ${config_path}.bak ${config_path}
				echo "----------------------------------------------"
				echo -e "\033[32m配置文件已还原！请手动重启服务！\033[0m"
				sleep 1
			else
				echo "-----------------------------------------------"
				echo -e "\033[31m操作已取消！返回上级菜单！\033[0m"
				set_core_config
			fi
		fi
	;;
	7)
		echo "-----------------------------------------------"
		echo -e "\033[36m如果无法正确获取配置文件时可以尝试使用\033[0m"
		echo -e " 1 使用自动UA"
		echo -e " 2 不使用UA"
		echo -e " 3 使用自定义UA：\033[32m$user_agent\033[0m"
		echo "-----------------------------------------------"
		read -p "请输入对应数字 > " num
		case "$num" in
		0)
			user_agent=''
		;;
		1)
			user_agent='auto'
		;;
		2)
			user_agent='none'
		;;
		3)
			read -p "请输入自定义UA(不要包含空格和特殊符号！) > " text
			[ -n "$text" ] && user_agent="$text"
		;;
		*)
			errornum
		;;
		esac
		[ "$num" -le 3 ] && setconfig user_agent "$user_agent"
		set_core_config
	;;
	*)
		errornum
	;;
	esac
}
