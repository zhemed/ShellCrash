. "$CRASHDIR"/libs/web_get.sh

#本项目托管的sing-box核心及版本文件统一固定到已发布提交地址，分支缓存不生效，确保始终拉取到当前版本（更新内核或版本时同步修改此提交号）
core_assets_commit=d7c0fe46d663a8a0b07d0240f5876725dd03dd56

get_bin() { #专用于项目内部文件的下载
    [ -z "$update_url" ] && update_url=https://raw.githubusercontent.com/zhemed/ShellCrash/main
    case "$2" in
        bin/singbox/*|bin/geodata/*|bin/version)
            bin_url="https://raw.githubusercontent.com/zhemed/ShellCrash/$core_assets_commit/$2"
            webget "$1" "$bin_url" "$3" "$4" "$5" "$6" && return 0
            ;;
    esac
    bin_url="$update_url/$2"
    webget "$1" "$bin_url" "$3" "$4" "$5" "$6"
}