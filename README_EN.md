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

[中文](README.md) | English

## Function introduction:
--
~Manage the official sing-box core in Shell environment through the management script<br>
~Manage everything in the Shell environment<br>
~Support online import of full configuration links and local config files<br>
~Support scheduled tasks and scheduled config updates<br>
~Support online installation of a local web dashboard to manage built-in rules<br>
~Support multiple modes: router transparent proxy, local proxy, etc.<br>
~Support online update<br>

## Equipment support:
--
~OpenWrt-based routers and devices with OpenWrt-customized firmware<br>
~Devices running standard Linux systems (Debian/CentOS/Armbian, etc.)<br>
~Compatible with Padavan firmware (conservative mode), Pandora firmware, ASUS/Merlin firmware<br>
~Compatible with various devices using customized Linux kernels<br>
——————————<br>
~For more device support, please submit an issue or visit the project page (provide the device model and the output of `uname -a`)<br>

## FAQ:
[ShellCrash FAQ | zhemed's Blog](https://github.com/zhemed/ShellCrash/chang-jian-wen-ti/)

## Usage:
-- Make sure SSH is enabled and root access is obtained (Linux devices with a GUI can use the built-in terminal)<br>
-- Connect to the SSH interface/terminal of your router or Linux device<br>
-- Run the installation command below for your device and follow the prompts<br>

### Online installation:<br>

~**Standard Linux devices (curl):**<br>
```shell
sudo -i #switch to root, enter password if required
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && bash -c "$(curl -kfsSl $url/install.sh)" && . /etc/profile &> /dev/null
```

~**Standard Linux devices (wget):**<br>
```shell
sudo -i #switch to root, enter password if required
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && bash /tmp/install.sh && . /etc/profile &> /dev/null
```

~**Router/embedded devices (curl):**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && sh -c "$(curl -kfsSl $url/install.sh)" && . /etc/profile &> /dev/null
```

~**Router/embedded devices (wget):**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**Legacy devices (old wget without certificate support):**<br>
```shell
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**Virtual machine (Alpine image recommended):**<br>
```shell
#install dependencies
apk add --no-cache wget openrc ca-certificates tzdata nftables iproute2 dcron
#run installation
export url='https://raw.githubusercontent.com/zhemed/ShellCrash/main' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh && sh /tmp/install.sh && . /etc/profile &> /dev/null
```

~**Docker:**<br>
Visit the [ShellCrash official Docker image](https://hub.docker.com/r/zhemed/shellcrash)

### Using the script:<br>
After installation, run:<br>
```Shell
crash     #enter the interactive menu
crash -h  #help list
```

#### **Runtime dependencies:**<br>
> Most devices already have most of these preinstalled; ignore if they do not affect you

```shell
curl/wget       required    both missing -> cannot install/update online or save nodes
iptables/nftables  important  missing -> only 'pure mode' available
crontab         low         missing -> scheduled tasks unavailable
net-tools       very low    missing -> port conflict detection unavailable
ubus/iproute-doc very low    missing -> host IP detection unavailable
```
