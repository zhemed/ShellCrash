<h1 align="center">
  <br>ShellCrash<br>
</h1>


  <p align="center">
	<a target="_blank" href="https://github.com/SagerNet/sing-box/releases">
    <img src="https://img.shields.io/github/release/SagerNet/sing-box.svg?style=flat-square&label=Core">
  </a>
  <a target="_blank" href="https://github.com/zhemed/ShellCrash/releases">
    <img src="https://img.shields.io/github/release/zhemed/ShellCrash.svg?style=flat-square&label=ShellCrash&colorB=green">
  </a>
</p>

中文 | [English](README_EN.md) 

功能简介：
--

~通过管理脚本在Shell环境下便捷使用官方 sing-box 内核<br>
~支持在Shell环境下管理<br>
~支持在线导入配置直链及本地配置文件<br>
~支持配置定时任务，支持配置文件定时更新<br>
~支持在线安装及使用本地网页面板管理内置规则<br>
~支持路由模式、本机模式等多种模式切换<br>
~支持在线更新<br>

设备支持：
--

~支持各种基于OpenWrt或使用OpenWrt二次定制开发的路由器设备<br>
~支持各种运行标准Linux系统（如Debian/CenOS/Armbian等）的设备<br>
~兼容Padavan固件（保守模式）、潘多拉固件以及华硕/梅林固件<br>
~兼容各类使用Linux内核定制开发的各类型设备<br>

——————————<br>
~更多设备支持，请提issue或前往项目主页反馈（需提供设备名称及运行uname -a返回的设备核心信息）<br>

## 常见问题：

[ShellCrash常见问题 | zhemed's Blog](https://github.com/zhemed/ShellCrash/chang-jian-wen-ti/)

## 使用方式：

~确认设备已经开启SSH并获取root权限（带GUI桌面的Linux设备可使用自带终端安装）<br>
~使用SSH连接工具（如putty，JuiceSSH，系统自带终端等）路由器或Linux设备的SSH管理界面或终端界面

~之后在SSH界面执行目标设备对应的安装命令，并按照后续提示完成安装<br>

### 在线安装：<br>

~**标准 Linux 设备（curl）：**<br>
```shell
sudo -i #切换到root用户，如果需要密码，请输入密码
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && bash -c "$(curl -kfsSl $url/install.sh)" && . /etc/profile &> /dev/null
```

~**标准 Linux 设备（wget）：**<br>
```shell
sudo -i #切换到root用户，如果需要密码，请输入密码
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && bash /tmp/install.sh && . /etc/profile &> /dev/null
```

~**路由/嵌入式设备（curl）：**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && sh -c "$(curl -kfsSl $url/install.sh)" && . /etc/profile &> /dev/null
```

~**路由/嵌入式设备（wget）：**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**老旧设备（低版本 wget，不支持证书参数）：**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**虚拟机（推荐 Alpine 镜像）：**<br>
```shell
#安装必要依赖
apk add --no-cache wget openrc ca-certificates tzdata nftables iproute2 dcron
#执行安装命令
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**Docker：**<br>
请前往[ShellCrash官方Docker镜像](https://hub.docker.com/r/zhemed/shellcrash)

### **本地安装：**<br>

如使用在线安装出现问题，请参考：[本地安装ShellCrash的教程 | zhemed's Blog](https://github.com/zhemed/ShellCrash/bdaz) 使用本地安装！<br>

### 使用脚本：<br>

安装完成管理脚本后，执行如下命令使用~

```Shell
crash 		#进入对话
crash -h 	#帮助列表
```

#### **运行时的额外依赖**：<br>

> 大部分的设备/系统都已经预装了以下的大部分依赖，使用时如无影响可以无视之

```shell
curl/wget		必须		全部缺少时无法在线安装及更新，无法使用节点保存功能
iptables/nftables	重要		缺少时只能使用纯净模式
crontab			较低		缺少时无法启用定时任务功能
net-tools		极低		缺少时无法正常检测端口占用
ubus/iproute-doc	极低		缺少时无法正常获取本机host地址
```



更新日志：
--

### [点击查看](https://github.com/zhemed/ShellCrash/releases)

交流反馈：
--
### [项目主页](https://github.com/zhemed/ShellCrash) 

机场推荐：
--

#### [Dler-墙洞，多年稳定运行，功能齐全](https://dler.pro/auth/register?affid=89698)<br>

#### [大米-群友力荐，流媒体解锁，月付推荐](https://1s.bigmeok.me/user#/register?code=2PuWY9I7)<br>
