#!/bin/bash
# Argosbx 网络调优（独立版）
# 用法：bash net-tune.sh            应用调优（幂等，可重复执行）
#       bash net-tune.sh show       只查看当前值
#       bash net-tune.sh undo       删除调优文件并回滚为内核默认
# 说明：参数与 argosbx.sh 里的 nettune() 保持一致，改动请同步两处。
# 实测背景见 docs/PERF-2026-10.md：QUIC（Hysteria2/TUIC）在 88ms RTT + 大 BDP 下
# 对 socket 缓冲区最敏感，默认 208KB 会把单流卡在 1MB/s 以下。
export LANG=en_US.UTF-8
sysctlfile=/etc/sysctl.d/99-agsbx-net.conf
bbr_line="net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr"

need_root(){
[ "$EUID" -eq 0 ] || { echo "请用 root 运行（或 sudo bash $0）"; exit 1; }
}

show_now(){
echo "当前关键值："
for k in net.ipv4.tcp_congestion_control net.core.default_qdisc net.core.rmem_max net.core.wmem_max \
         net.ipv4.tcp_rmem net.ipv4.tcp_wmem net.core.somaxconn net.ipv4.tcp_fastopen \
         net.ipv4.tcp_slow_start_after_idle net.ipv4.udp_rmem_min; do
printf "  %-42s %s\n" "$k" "$(sysctl -n "$k" 2>/dev/null)"
done
}

case "$1" in
show)
show_now
exit 0
;;
undo)
need_root
[ -f "$sysctlfile" ] && rm -f "$sysctlfile" && echo "已删除 $sysctlfile"
sysctl --system >/dev/null 2>&1
echo "已回滚（部分参数需重启完全生效）"
show_now
exit 0
;;
esac

need_root
if [ ! -d /etc/sysctl.d ]; then
echo "本机没有 /etc/sysctl.d（非 systemd 系统？），跳过"
exit 0
fi
echo "=========写入 $sysctlfile ========="
cat > "$sysctlfile" <<'EOF'
# Argosbx 网络调优（2026-10 实测：TCP 单流易被运营商限速，QUIC 大 BDP 受益最大）
# 回滚：bash net-tune.sh undo
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576
net.core.optmem_max = 65536
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 8192
net.ipv4.ip_local_port_range = 10240 65000
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
EOF
if sysctl -n net.ipv4.tcp_available_congestion_control 2>/dev/null | grep -qw bbr; then
printf '%s\n' "$bbr_line" >> "$sysctlfile"
else
echo "提示：内核不支持 BBR，跳过拥塞控制相关配置"
fi
if sysctl -p "$sysctlfile" >/dev/null 2>&1; then
echo "已生效"
else
echo "部分参数受限（容器/LXC 常见），重启后按内核支持生效"
fi
echo
show_now
echo
echo "注意：QUIC 程序（sing-box/xray）需重启才能沿用新的 socket 缓冲区。"
