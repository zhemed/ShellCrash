############################
# Stage 1: builder
############################
FROM alpine:latest AS builder

ARG TARGETPLATFORM
ARG TZ=Asia/Shanghai
ARG S6_OVERLAY_V=v3.2.1.0
#本项目托管的 sing-box 内核及数据库统一固定到已发布提交地址（更新内核或版本时同步修改此提交号）
ARG CORE_ASSETS_COMMIT=d7c0fe46d663a8a0b07d0240f5876725dd03dd56

RUN apk add --no-cache curl tzdata

# 时区
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

WORKDIR /build

#安装脚本相关文件
COPY ShellCrash.tar.gz /tmp/ShellCrash.tar.gz
RUN set -eux; \
    mkdir -p /tmp/SC_tmp; \
    tar -zxf /tmp/ShellCrash.tar.gz -C /tmp/SC_tmp; \
    export systype=container; \
    export CRASHDIR=/etc/ShellCrash; \
    /bin/sh /tmp/SC_tmp/init.sh

#获取内核及s6文件
RUN set -eux; \
	case "$TARGETPLATFORM" in \
      linux/amd64)  K=amd64 S=x86_64;; \
      linux/arm64)  K=arm64 S=aarch64;; \
      *) echo "unsupported $TARGETPLATFORM" && exit 1 ;; \
    esac; \
    curl -fsSL "https://raw.githubusercontent.com/zhemed/ShellCrash/${CORE_ASSETS_COMMIT}/bin/singbox/singbox-linux-${K}.tar.gz" -o /tmp/CrashCore.tar.gz; \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_V}/s6-overlay-${S}.tar.xz" -o /tmp/s6_arch.tar.xz; \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_V}/s6-overlay-noarch.tar.xz" -o /tmp/s6_noarch.tar.xz && ls -l /tmp

#预置规则集数据库
RUN set -eux; \
    mkdir -p /etc/ShellCrash/ruleset; \
    curl -fsSL "https://raw.githubusercontent.com/zhemed/ShellCrash/${CORE_ASSETS_COMMIT}/bin/geodata/srs_geosite_cn.srs" -o /etc/ShellCrash/ruleset/cn.srs; \
    curl -fsSL "https://raw.githubusercontent.com/zhemed/ShellCrash/${CORE_ASSETS_COMMIT}/bin/geodata/srs_geoip_cn.srs" -o /etc/ShellCrash/ruleset/cnip.srs

############################
# Stage 2: runtime
############################
FROM alpine:latest

ARG TZ=Asia/Shanghai

LABEL org.opencontainers.image.source="https://github.com/zhemed/ShellCrash"
#安装依赖
RUN apk add --no-cache \
    wget \
    ca-certificates \
    tzdata \
    nftables \
    iproute2

RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

#复制文件
COPY --from=builder /etc/ShellCrash /etc/ShellCrash
COPY --from=builder /tmp/CrashCore.tar.gz /etc/ShellCrash/CrashCore.tar.gz
COPY --from=builder /etc/profile /etc/profile
COPY --from=builder /usr/bin/crash /usr/bin/crash

#安装s6
COPY --from=builder /tmp/s6_arch.tar.xz /tmp/s6_arch.tar.xz
COPY --from=builder /tmp/s6_noarch.tar.xz /tmp/s6_noarch.tar.xz
RUN tar -xJf /tmp/s6_noarch.tar.xz -C / && rm -rf /tmp/s6_noarch.tar.xz
RUN tar -xJf /tmp/s6_arch.tar.xz -C / && rm -rf /tmp/s6_arch.tar.xz
COPY docker/s6-rc.d /etc/s6-overlay/s6-rc.d
ENV S6_CMD_WAIT_FOR_SERVICES=1

ENTRYPOINT ["/init"]

