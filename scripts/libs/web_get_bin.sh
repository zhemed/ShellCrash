. "$CRASHDIR"/libs/web_get.sh

get_bin() { #专用于项目内部文件的下载
    [ -z "$update_url" ] && update_url=https://testingcf.jsdelivr.net/gh/zhemed/ShellCrash@main
    #raw.githubusercontent.com存在无法刷新的CDN缓存，自动切换至jsDelivr避免拉取到旧文件
    [ -n "$update_url" ] && update_url=$(echo "$update_url" | sed 's#https://raw.githubusercontent.com/zhemed/ShellCrash/main#https://testingcf.jsdelivr.net/gh/zhemed/ShellCrash@main#')
    if [ -n "$url_id" ]; then
		[ -n "$release_type" ] && rt="$release_type" || rt=master
        echo "$2" | grep -q '^bin/' && rt=update #/bin文件改为在update分支下载
        echo "$2" | grep -qE '^public/|^rules/' && rt=dev #/public和/rules文件改为在dev分支下载    
        if [ "$url_id" = 101 -o "$url_id" = 104 ]; then
            bin_url="$(grep "$url_id" "$CRASHDIR"/configs/servers.list | awk '{print $3}')@$rt/$2" #jsdelivr特殊处理
        else
            bin_url="$(grep "$url_id" "$CRASHDIR"/configs/servers.list | awk '{print $3}')/$rt/$2"
        fi
    else
        bin_url="$update_url/$2"
    fi
    webget "$1" "$bin_url" "$3" "$4" "$5" "$6"
}