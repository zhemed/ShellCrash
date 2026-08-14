
singbox_check() { #singbox启动前检查
    check_core
    #预下载cn.srs数据库
    [ "$dns_mod" = "mix" ] || [ "$dns_mod" = "route" ] && ! grep -Eq '"tag" *:[[:space:]]*"cn"' "$CRASHDIR"/jsons/*.json && check_geo ruleset/cn.srs srs_geosite_cn.srs
    return 0
}