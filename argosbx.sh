#!/bin/bash
export LANG=en_US.UTF-8
mkdir -p "$HOME/agsbx"
procunderhome(){
local pat p e
pat="${1:-s|x|c}"
for p in $(pgrep -f "agsbx/($pat)" 2>/dev/null); do
e=$(readlink -f "/proc/$p/exe" 2>/dev/null)
case "$e" in "$HOME/agsbx/"*) return 0 ;; esac
done
return 1
}
killhome(){
local pat p e
pat="${1:-s|x|c}"
for p in $(pgrep -f "agsbx/($pat)" 2>/dev/null); do
e=$(readlink -f "/proc/$p/exe" 2>/dev/null)
case "$e" in "$HOME/agsbx/"*) kill -15 "$p" 2>/dev/null ;; esac
done
return 0
}
url="${AGSBX_SELF_URL:-https://raw.githubusercontent.com/tonnyli20/argosbx/maint/argosbx.sh}"
selfurl="$url"
case "${*##* }" in list|del|upx|ups|upa|res|tune) ;; *)
cmd=""
for v in uuid vlpt vmpt vwpt hypt tupt xhpt vxpt anpt arpt sspt sopt nvpt xupt xcpt reym cdnym argo agn agk warp name oap hyup hydw hyobfs hyobfspw netopt; do
[ -n "${!v+x}" ] && cmd+="$v=\"${!v}\" "
done
main="bash <(curl -Ls $url)"
cmd+="$main${*:+ $*}"
[ "$cmd" != "$main" ] && echo "$cmd" > "$HOME/agsbx/sh.txt"
;; esac
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; }
[ -z "${vwpt+x}" ] || { vwp=yes; vmag=yes; }
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${tupt+x}" ] || tup=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${vxpt+x}" ] || vxp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${sspt+x}" ] || ssp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${sopt+x}" ] || sop=yes
[ -z "${warp+x}" ] || wap=yes
[ -z "${nvpt+x}" ] || nvp=yes
[ -z "${xupt+x}" ] || xup=yes
[ -z "${xcpt+x}" ] || xcp=yes
if procunderhome || [ -s "$HOME/agsbx/sb.json" ] || [ -s "$HOME/agsbx/xr.json" ]; then
if [ "$1" = "rep" ]; then
[ "$xcp" = yes ] || [ "$xup" = yes ] || [ "$nvp" = yes ] || [ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：rep重置协议时，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
else
[ "$1" = "del" ] || [ "$1" = "tune" ] || [ "$xcp" = yes ] || [ "$xup" = yes ] || [ "$nvp" = yes ] || [ "$vwp" = yes ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：未安装argosbx脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export hyup=${hyup:-''}
export hydw=${hydw:-''}
export hyobfs=${hyobfs:-''}
export hyobfspw=${hyobfspw:-''}
export netopt=${netopt:-'yes'}
export forceup=${forceup:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_vw=${vwpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export port_xh=${xhpt:-''}
export port_vx=${vxpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_ss=${sspt:-''}
export port_so=${sopt:-''}
export port_nv=${nvpt:-''}
export port_xu=${xupt:-''}
export port_xc=${xcpt:-''}
export ym_vl_re=${reym:-''}
export cdnym=${cdnym:-''}
export argo=${argo:-''}
export ARGO_DOMAIN=${agn:-''}
export ARGO_AUTH=${agk:-''}
export ippz=${ippz:-''}
export warp=${warp:-''}
export name=${name:-''}
export oap=${oap:-''}
# ---------- 参数校验 / 端口分配 ----------
validport(){ case "$1" in ''|*[!0-9]*) return 1;; esac; [ "$1" -ge 1 ] && [ "$1" -le 65535 ]; }
for _pv in port_vl_re port_vm_ws port_vw port_hy2 port_tu port_xh port_vx port_an port_ar port_ss port_so port_nv port_xu port_xc; do
eval "_pval=\${$_pv}"
if [ -n "$_pval" ] && ! validport "$_pval"; then
echo "提示：$_pv=\"$_pval\" 不是合法端口（1-65535），本次改用随机端口"
eval "$_pv=''"
fi
done
for _bw in hyup hydw; do
eval "_bval=\${$_bw}"
if [ -n "$_bval" ] && { case "$_bval" in *[!0-9]*) true;; *) false;; esac || [ "$_bval" -lt 1 ] || [ "$_bval" -gt 100000 ]; }; then
echo "提示：$_bw=\"$_bval\" 不是合法带宽（1-100000 Mbps），已忽略"
eval "$_bw=''"
fi
done
if [ -n "$uuid" ] && ! printf '%s' "$uuid" | grep -Eq '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'; then
echo "提示：uuid=\"$uuid\" 不是标准 UUID 格式（vless/vmess 必需），本次改用随机 UUID"
uuid=''
fi
if [ -n "$hyobfspw" ] && printf '%s' "$hyobfspw" | grep -q '[^0-9A-Za-z]'; then
echo "提示：hyobfspw 建议只用字母数字（避免分享链接需转义），已保留原值"
fi
portbusy(){
if command -v ss >/dev/null 2>&1; then
ss -lntu 2>/dev/null | awk 'NR>1{print $5}' | grep -qE "[:.]$1\$"
elif command -v netstat >/dev/null 2>&1; then
netstat -lntu 2>/dev/null | awk 'NR>2{print $4}' | grep -qE "[:.]$1\$"
else
return 1
fi
}
usedports=""
randport(){
local p n=0
while [ "$n" -lt 60 ]; do
# 10000-29999：避开 32768+ 的内核临时端口段，减少 bind 失败
p=$(( (RANDOM % 20000) + 10000 ))
n=$((n+1))
case " $usedports " in *" $p "*) continue ;; esac
portbusy "$p" && continue
usedports="$usedports $p"
echo "$p"; return 0
done
echo "$p"
}
v46url="https://icanhazip.com"
agsbxurl="$selfurl"
showmode(){
[ -s "$HOME/agsbx/sh.txt" ] && echo "上次输入的完整脚本：$(cat "$HOME/agsbx/sh.txt")"
echo "Argosbx脚本一键SSH命令生器在线网址：https://yonggekkk.github.io/argosbx/"
echo "主脚本：bash <(curl -Ls $selfurl) 或 bash <(wget -qO- $selfurl)"
echo "显示节点信息命令：agsbx list 【或者】 主脚本 list"
echo "重置变量组命令：自定义各种协议变量组 agsbx rep 【或者】 自定义各种协议变量组 主脚本 rep"
echo "更新脚本命令：原已安装的自定义各种协议变量组 主脚本 rep"
echo "更新Xray或Singbox内核命令：agsbx upx或ups 【或者】 主脚本 upx或ups"
echo "重启脚本命令：agsbx res 【或者】 主脚本 res"
echo "卸载脚本命令：agsbx del 【或者】 主脚本 del"
echo "双栈VPS显示IPv4/IPv6节点配置命令：ippz=4或6 agsbx list 【或者】 ippz=4或6 主脚本 list"
echo "申请本地IP域名证书脚本：bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/acme-yg/main/acme.sh)"
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "甬哥Github项目 ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx一键无交互小钢炮脚本💣"
echo "当前版本：V26.7.16"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
arm64|aarch64) cpu=arm64;;
amd64|x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
if [ "$1" != "del" ]; then
if [ ! -f sbx_update ]; then
echo "执行必要的脚本依赖中，请稍等10秒……"
if command -v apk >/dev/null 2>&1; then
apk update >/dev/null 2>&1 && apk add --no-cache bash busybox-extras gcompat libc6-compat iptables openssl >/dev/null 2>&1
elif command -v apt >/dev/null 2>&1; then
export DEBIAN_FRONTEND=noninteractive
printf 'iptables-persistent iptables-persistent/autosave_v4 boolean true\niptables-persistent iptables-persistent/autosave_v6 boolean true\n' | debconf-set-selections
apt update >/dev/null 2>&1 && apt install -y busybox coreutils util-linux iptables iptables-persistent cron openssl >/dev/null 2>&1
fi
touch sbx_update
fi
fi
v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- "$v46url" 2>/dev/null) )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- "$v46url" 2>/dev/null) )
#v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) )
v6dq=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
}
warpsx(){
warpurl=$( (command -v curl >/dev/null 2>&1 && curl -sm5 -k https://warp.xijp.eu.org 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget --tries=2 -qO- https://warp.xijp.eu.org 2>/dev/null) )
if [ -z "$warpurl" ] || printf '%s' "$warpurl" | grep -q html; then
wpv6='2606:4700:110:8d8d:1845:c39f:2dd5:a03a'
pvk='52cuYFgCJXp0LAq7+nWJIbCXXgU9eGggOc+Hlfz5u6A='
res='[215, 69, 233]'
else
pvk=$(echo "$warpurl" | awk -F'：' '/Private_key/{print $2}' | xargs)
wpv6=$(echo "$warpurl" | awk -F'：' '/IPV6/{print $2}' | xargs)
res=$(echo "$warpurl" | awk -F'：' '/reserved/{print $2}' | xargs)
fi
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsbx/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
if echo "$v6" | grep -q '^2a09' || echo "$v4" | grep -q '^104.28'; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
echo; echo "请注意：你已安装了warp"
else
if [ "$wap" != yes ]; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
else
case "$warp" in
""|sx|xs) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s ) s1outtag=warp-out; s2outtag=warp-out; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
x ) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x4) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x6) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4x4|x4s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s4x6|x6s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6x4|x4s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
s6x6|x6s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0"'; wap=warp ;;
sx4|x4s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
sx6|x6s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
xs4|s4x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
xs6|s6x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
* ) s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo ;;
esac
fi
fi
case "$warp" in *x4*) wxryx='ForceIPv4' ;; *x6*) wxryx='ForceIPv6' ;; *) wxryx='ForceIPv6v4' ;; esac
if command -v curl >/dev/null 2>&1; then
curl -s4m5 -k "$v46url" >/dev/null 2>&1 && v4_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -4 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v4_ok=true
fi
if command -v curl >/dev/null 2>&1; then
curl -s6m5 -k "$v46url" >/dev/null 2>&1 && v6_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -6 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v6_ok=true
fi
if [ "$v4_ok" = true ] && [ "$v6_ok" = true ]; then
case "$warp" in *s4*) sbyx='prefer_ipv4' ;; *) sbyx='prefer_ipv6' ;; esac
case "$warp" in *x4*) xryx='ForceIPv4v6' ;; *x*) xryx='ForceIPv6v4' ;; *) xryx='ForceIPv4v6' ;; esac
elif [ "$v4_ok" = true ] && [ "$v6_ok" != true ]; then
case "$warp" in *s4*|x) sbyx='ipv4_only' ;; *) sbyx='prefer_ipv6' ;; esac
case "$warp" in *x4*) xryx='ForceIPv4' ;; *x*) xryx='ForceIPv6v4' ;; *) xryx='ForceIPv4v6' ;; esac
elif [ "$v4_ok" != true ] && [ "$v6_ok" = true ]; then
case "$warp" in *s6*|x) sbyx='ipv6_only' ;; *) sbyx='prefer_ipv4' ;; esac
case "$warp" in *x6*) xryx='ForceIPv6' ;; *x*) xryx='ForceIPv4v6' ;; *) xryx='ForceIPv6v4' ;; esac
fi
}
a4(){
local h ip
h="$1"
[ -z "$h" ] && return 0
case "$h" in
  *:*) printf '%s' "$h"; return 0 ;;
  *[!0-9.]*) : ;;
  *) printf '%s' "$h"; return 0 ;;
esac
ip=$(getent ahostsv4 "$h" 2>/dev/null | awk 'NR==1{print $1}')
[ -z "$ip" ] && ip=$(dig +short A "$h" 2>/dev/null | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)
[ -z "$ip" ] && ip=$(nslookup -type=A "$h" 2>/dev/null | awk '/^Address: /{print $2}' | tail -1)
[ -z "$ip" ] && ip=$h
printf '%s' "$ip"
}
corever(){
# 读取内核版本号：corever <二进制路径> <x|s|c>，读取失败输出空
[ -x "$1" ] || return 0
case "$2" in
x) "$1" version 2>/dev/null | awk '/^Xray/{print $2; exit}' ;;
s) "$1" version 2>/dev/null | awk '$1=="sing-box"&&$2=="version"{print $3; exit}' ;;
c) "$1" --version 2>/dev/null | awk 'NR==1{print $3; exit}' ;;
esac
}
vercmp(){
# 版本号比较：$1 更新回 1，$2 更新回 2，相同回 0（按点分段数值比较，忽略前导 v 与 -/+ 后缀）
awk -v a="$1" -v b="$2" 'BEGIN{
gsub(/^[vV]/,"",a); gsub(/^[vV]/,"",b);
sub(/[-+].*$/,"",a); sub(/[-+].*$/,"",b);
na=split(a,X,"."); nb=split(b,Y,".");
n=(na>nb?na:nb);
for(i=1;i<=n;i++){
x=(i<=na?X[i]:0)+0; y=(i<=nb?Y[i]:0)+0;
if(x>y){print 1; exit}
if(x<y){print 2; exit}
}
print 0
}'
}
upcore(){
# 带新旧版本检查的内核升级：upcore <x|s|c> <下载地址> <显示名>
# 结果：全局变量 coreupd=yes（已替换）| no（无变化）；返回 0 正常，1 失败
local _t="$1" _u="$2" _n="$3" _bin _tmp _old _new _dn
coreupd=no
case "$_t" in
x) _bin="$HOME/agsbx/xray"; _dn="upx" ;;
s) _bin="$HOME/agsbx/sing-box"; _dn="ups" ;;
c) _bin="$HOME/agsbx/cloudflared"; _dn="upa" ;;
*) echo "未知内核类型：$_t"; return 1 ;;
esac
_tmp="${_bin}.new"
_old=$(corever "$_bin" "$_t")
if [ -n "$_old" ]; then
echo "当前${_n}内核版本：v$_old"
else
echo "当前${_n}内核版本：未安装（将全新安装）"
fi
rm -f "$_tmp"
echo "${_n}最新内核下载中，请稍候……"
if command -v curl >/dev/null 2>&1; then
curl -fLo "$_tmp" -# --retry 2 --connect-timeout 15 --max-time 900 "$_u" >/dev/null 2>&1
elif command -v wget >/dev/null 2>&1; then
timeout 900 wget -O "$_tmp" --tries=2 "$_u" >/dev/null 2>&1
fi
if [ ! -s "$_tmp" ]; then
rm -f "$_tmp"
echo "❌ ${_n}内核下载失败（域名不可达或下载地址失效），已保留现有内核，服务未受影响"
return 1
fi
chmod +x "$_tmp" 2>/dev/null
_new=$(corever "$_tmp" "$_t")
if [ -z "$_new" ]; then
rm -f "$_tmp"
echo "❌ 下载的文件无法执行或版本号解析失败（下载不完整 / 架构不匹配：当前平台 ${cpu}），已保留现有内核"
return 1
fi
echo "获取到最新${_n}内核版本：v$_new"
if [ -n "$_old" ]; then
case "$(vercmp "$_new" "$_old")" in
0)
echo "✅ 新旧版本一致（v${_old}），已是最新，跳过替换内核"
rm -f "$_tmp"
return 0
;;
1)
echo "🔼 版本检查通过：v$_old → v${_new}（升级）"
;;
2)
echo "🔽 版本检查未通过：v$_old → v${_new}（检测到版本回退）"
if [ "$forceup" != "yes" ]; then
echo "已按安全策略取消安装：新版本比当前版本更旧，可能是上游回滚或下载到异常文件，现有内核保持不变"
echo "如确认要强制回退，请执行：forceup=yes $(basename "$0") $_dn"
rm -f "$_tmp"
return 1
fi
echo "forceup=yes，继续按回退方式替换内核"
;;
esac
fi
if [ -x "$_bin" ]; then
cp -f "$_bin" "${_bin}.bak" 2>/dev/null
fi
mv -f "$_tmp" "$_bin" 2>/dev/null || cp -f "$_tmp" "$_bin"
rm -f "$_tmp"
chmod +x "$_bin" 2>/dev/null
_new=$(corever "$_bin" "$_t")
coreupd=yes
echo "已安装${_n}内核：v${_new}（旧内核已备份为 ${_bin}.bak）"
return 0
}
upxray(){
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-$cpu"
upcore x "$url" Xray
}
upsingbox(){
url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-$cpu"
upcore s "$url" Sing-box
}
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsbx/uuid" ]; then
if [ -e "$HOME/agsbx/sing-box" ]; then
uuid=$("$HOME/agsbx/sing-box" generate uuid)
else
uuid=$("$HOME/agsbx/xray" uuid)
fi
echo "$uuid" > "$HOME/agsbx/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsbx/uuid"
fi
uuid=$(cat "$HOME/agsbx/uuid")
echo "UUID密码：$uuid"
}
nettune(){
[ "$netopt" = "no" ] && return
[ "$EUID" -ne 0 ] && return
command -v sysctl >/dev/null 2>&1 || return
[ -d /etc/sysctl.d ] || return
sysctlfile=/etc/sysctl.d/99-agsbx-net.conf
echo
echo "=========网络内核参数调优========="
cat > "$sysctlfile" <<EOF
# Argosbx 网络调优（2026-10 实测：TCP 单流易被运营商限速，QUIC 大 BDP 受益最大）
# 跳过调优：安装时加 netopt=no；回滚：删除本文件后执行 sysctl --system
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
cat >> "$sysctlfile" <<EOF
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
fi
if sysctl -p "$sysctlfile" >/dev/null 2>&1; then
echo "已写入 $sysctlfile 并立即生效（rmem/wmem 32MB、BBR+fq、FastOpen 等）"
else
echo "已写入 ${sysctlfile}，部分参数受限（容器/LXC），将在重启后按内核支持生效"
fi
}
# ---------- 配置备份 / 启动前校验 ----------
cfgbak(){ [ -s "$1" ] && cp -f "$1" "$1.bak"; }
xrcheck(){
[ -s "$HOME/agsbx/xr.json" ] || return 1
[ -x "$HOME/agsbx/xray" ] || return 0
sed -i '${s/,[[:space:]]*$//}' "$HOME/agsbx/xr.json" 2>/dev/null
"$HOME/agsbx/xray" run -test -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 || "$HOME/agsbx/xray" -test -c "$HOME/agsbx/xr.json" >/dev/null 2>&1
}
sbcheck(){
[ -s "$HOME/agsbx/sb.json" ] || return 1
[ -x "$HOME/agsbx/sing-box" ] || return 0
sed -i '${s/,[[:space:]]*$//}' "$HOME/agsbx/sb.json" 2>/dev/null
"$HOME/agsbx/sing-box" check -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 || "$HOME/agsbx/sing-box" -c "$HOME/agsbx/sb.json" check >/dev/null 2>&1
}
cfgrollback(){
if [ -s "$1.bak" ]; then
cp -f "$1.bak" "$1"
echo "已回滚到上一次可用配置：$1（旧配置备份 $1.bak 保留）"
else
echo "无历史备份可回滚，请检查上方报错后重跑脚本（常见原因：端口被占用、证书路径不存在）"
fi
}
# 只清理本脚本自己添加的 hysteria2 跳跃端口规则，不动 ufw/docker/其他 DNAT
hy2natclean(){
for _fam in iptables ip6tables; do
command -v "$_fam" >/dev/null 2>&1 || continue
"$_fam" -t nat -S PREROUTING 2>/dev/null | grep 'agsbx-hy2-jump' | sed 's/^-A /-D /' | while read -r _rule; do
"$_fam" -t nat $_rule >/dev/null 2>&1
done
done
}
validhyjpt(){
for _hp in $1; do
printf '%s' "$_hp" | grep -Eq '^[0-9]{1,5}(:[0-9]{1,5})?$' || return 1
done
}
lockfiles(){
[ -d "$HOME/agsbx" ] || return 0
for _f in sb.json xr.json sbox.json uuid sh.txt sbargotoken.log obfs_pw argo.env SHA256.txt; do
[ -f "$HOME/agsbx/$_f" ] && chmod 600 "$HOME/agsbx/$_f" 2>/dev/null
done
[ -f "$HOME/agsbx/private.key" ] && chmod 600 "$HOME/agsbx/private.key" 2>/dev/null
return 0
}
installxray(){
echo
echo "=========启用xray内核========="
mkdir -p "$HOME/agsbx/xrk"
if [ ! -e "$HOME/agsbx/xray" ]; then
upxray || { echo "❌ Xray内核安装失败，已终止（请检查到 github.com 的网络后重试）"; exit 1; }
fi
cfgbak "$HOME/agsbx/xr.json"
cat > "$HOME/agsbx/xr.json" <<EOF
{
  "log": {
  "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
if [ ! -e "$HOME/agsbx/xrk/private_key" ]; then
key_pair=$("$HOME/agsbx/xray" x25519)
private_key=$(echo "$key_pair" | awk -F':' '/PrivateKey/ {print $2}' | xargs)
public_key=$(echo "$key_pair" | awk -F':' '/Password/ {print $2}' | xargs)
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/agsbx/xrk/private_key"
echo "$public_key" > "$HOME/agsbx/xrk/public_key"
echo "$short_id" > "$HOME/agsbx/xrk/short_id"
fi
private_key_x=$(cat "$HOME/agsbx/xrk/private_key")
public_key_x=$(cat "$HOME/agsbx/xrk/public_key")
short_id_x=$(cat "$HOME/agsbx/xrk/short_id")
fi
if [ -n "$xhp" ] || [ -n "$vxp" ] || [ -n "$vwp" ]; then
if [ ! -e "$HOME/agsbx/xrk/dekey" ]; then
vlkey=$("$HOME/agsbx/xray" vlessenc)
dekey=$(echo "$vlkey" | grep '"decryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
enkey=$(echo "$vlkey" | grep '"encryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
echo "$dekey" > "$HOME/agsbx/xrk/dekey"
echo "$enkey" > "$HOME/agsbx/xrk/enkey"
fi
dekey=$(cat "$HOME/agsbx/xrk/dekey")
enkey=$(cat "$HOME/agsbx/xrk/enkey")
fi

if [ -n "$xhp" ]; then
xhp=xhpt
if [ -z "$port_xh" ] && [ ! -e "$HOME/agsbx/port_xh" ]; then
port_xh=$(randport)
echo "$port_xh" > "$HOME/agsbx/port_xh"
elif [ -n "$port_xh" ]; then
echo "$port_xh" > "$HOME/agsbx/port_xh"
fi
port_xh=$(cat "$HOME/agsbx/port_xh")
echo "Vless-xhttp-reality-enc端口：$port_xh"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptargo
fi
if [ -n "$vxp" ]; then
vxp=vxpt
if [ -z "$port_vx" ] && [ ! -e "$HOME/agsbx/port_vx" ]; then
port_vx=$(randport)
echo "$port_vx" > "$HOME/agsbx/port_vx"
elif [ -n "$port_vx" ]; then
echo "$port_vx" > "$HOME/agsbx/port_vx"
fi
port_vx=$(cat "$HOME/agsbx/port_vx")
echo "Vless-xhttp-enc端口：$port_vx"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-xhttp",
      "listen": "::",
      "port": ${port_vx},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-vx",
          "mode": "auto"
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vxp=vxptargo
fi
if [ -n "$xup" ]; then
xup=xupt
if [ -z "$port_xu" ] && [ ! -e "$HOME/agsbx/port_xu" ]; then
port_xu=$(randport)
echo "$port_xu" > "$HOME/agsbx/port_xu"
elif [ -n "$port_xu" ]; then
echo "$port_xu" > "$HOME/agsbx/port_xu"
fi
port_xu=$(cat "$HOME/agsbx/port_xu")
echo "Vless-xhttp-tls-UDP端口：$port_xu"
cat >> "$HOME/agsbx/xr.json" <<EOF
{
  "tag": "xhttp-h3",
  "listen": "::",
  "port": ${port_xu},
  "protocol": "vless",
  "settings": {
    "clients": [
      {
        "id": "${uuid}",
        "flow": ""
      }
    ],
    "decryption": "none"
  },
  "streamSettings": {
    "network": "xhttp",
    "security": "tls",
    "xhttpSettings": {
    "mode": "auto",
    "path": "${uuid}-xu"
    },
    "tlsSettings": {
      "alpn": [
        "h3"
      ],
      "certificates": [
        {
          "certificateFile": "$certificateHTA",
          "keyFile": "$keyHTA"
        }
      ]
    }
  },
  "sniffing": {
    "enabled": true,
    "destOverride": ["http", "tls", "quic"],
   "metadataOnly": false
  }
},	
EOF
else
xup=xuptargo
fi

if [ -n "$xcp" ]; then
xcp=xcpt
if [ -z "$port_xc" ] && [ ! -e "$HOME/agsbx/port_xc" ]; then
port_xc=$(randport)
echo "$port_xc" > "$HOME/agsbx/port_xc"
elif [ -n "$port_xc" ]; then
echo "$port_xc" > "$HOME/agsbx/port_xc"
fi
port_xc=$(cat "$HOME/agsbx/port_xc")
echo "Vless-xhttp-tls-TCP/UDP端口：$port_xc"
cat >> "$HOME/agsbx/xr.json" <<EOF
{
  "tag": "xhttp-h23",
  "listen": "::",
  "port": ${port_xc},
  "protocol": "vless",
  "settings": {
    "clients": [
      {
        "id": "${uuid}",
        "flow": ""
      }
    ],
    "decryption": "none"
  },
  "streamSettings": {
    "network": "xhttp",
    "security": "tls",
    "xhttpSettings": {
    "mode": "auto",
    "path": "${uuid}-xc"
    },
    "tlsSettings": {
     "alpn": [
      "h2","http/1.1"
       ],
      "certificates": [
        {
          "certificateFile": "$certificateHTA",
          "keyFile": "$keyHTA"
        }
      ]
    }
  },
  "sniffing": {
    "enabled": true,
    "destOverride": ["http", "tls", "quic"],
   "metadataOnly": false
  }
},	
EOF
else
xcp=xcptargo
fi

if [ -n "$vwp" ]; then
vwp=vwpt
if [ -z "$port_vw" ] && [ ! -e "$HOME/agsbx/port_vw" ]; then
port_vw=$(randport)
echo "$port_vw" > "$HOME/agsbx/port_vw"
elif [ -n "$port_vw" ]; then
echo "$port_vw" > "$HOME/agsbx/port_vw"
fi
port_vw=$(cat "$HOME/agsbx/port_vw")
echo "Vless-ws-enc端口：$port_vw"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"vless-ws",
      "listen": "::",
      "port": ${port_vw},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": ""
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${uuid}-vw"
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vwp=vwptargo
fi
if [ -n "$vlp" ]; then
vlp=vlpt
if [ -z "$port_vl_re" ] && [ ! -e "$HOME/agsbx/port_vl_re" ]; then
port_vl_re=$(randport)
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
elif [ -n "$port_vl_re" ]; then
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
fi
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
echo "Vless-tcp-reality-v端口：$port_vl_re"
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptargo
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsbx/sing-box" ]; then
upsingbox || { echo "❌ Sing-box内核安装失败，已终止（请检查到 github.com 的网络后重试）"; exit 1; }
fi
cfgbak "$HOME/agsbx/sb.json"
cat > "$HOME/agsbx/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
if [ -s "/root/ygkkkca/private.key" ] && [ -n "$nvp" ]; then
nvp=nvpt
if [ -z "$port_nv" ] && [ ! -e "$HOME/agsbx/port_nv" ]; then
port_nv=$(randport)
echo "$port_nv" > "$HOME/agsbx/port_nv"
elif [ -n "$port_nv" ]; then
echo "$port_nv" > "$HOME/agsbx/port_nv"
fi
port_nv=$(cat "$HOME/agsbx/port_nv")
echo "Naiveproxy端口：$port_nv"
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
        "type": "naive",
        "tag": "naive-sb",
        "listen": "::",
        "listen_port": ${port_nv},
        "users": [
            {
                "username": "${uuid}",
                "password": "${uuid}"
            }
        ],
        "tls": {
            "enabled": true,
            "certificate_path": "/root/ygkkkca/cert.crt",
            "key_path": "/root/ygkkkca/private.key"
        }
    },
EOF
else
nvp=nvptargo
fi

if [ -n "$tup" ]; then
tup=tupt
if [ -z "$port_tu" ] && [ ! -e "$HOME/agsbx/port_tu" ]; then
port_tu=$(randport)
echo "$port_tu" > "$HOME/agsbx/port_tu"
elif [ -n "$port_tu" ]; then
echo "$port_tu" > "$HOME/agsbx/port_tu"
fi
port_tu=$(cat "$HOME/agsbx/port_tu")
echo "Tuic端口：$port_tu"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "$certificateHTA",
                "key_path": "$keyHTA"
            }
        },
EOF
else
tup=tuptargo
fi
if [ -n "$anp" ]; then
anp=anpt
if [ -z "$port_an" ] && [ ! -e "$HOME/agsbx/port_an" ]; then
port_an=$(randport)
echo "$port_an" > "$HOME/agsbx/port_an"
elif [ -n "$port_an" ]; then
echo "$port_an" > "$HOME/agsbx/port_an"
fi
port_an=$(cat "$HOME/agsbx/port_an")
echo "Anytls端口：$port_an"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls":{
                "enabled": true,
                "certificate_path": "$certificateHTA",
                "key_path": "$keyHTA"
            }
        },
EOF
else
anp=anptargo
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsbx/sbk"
if [ ! -e "$HOME/agsbx/sbk/private_key" ]; then
key_pair=$("$HOME/agsbx/sing-box" generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$("$HOME/agsbx/sing-box" generate rand --hex 4)
echo "$private_key" > "$HOME/agsbx/sbk/private_key"
echo "$public_key" > "$HOME/agsbx/sbk/public_key"
echo "$short_id" > "$HOME/agsbx/sbk/short_id"
fi
private_key_s=$(cat "$HOME/agsbx/sbk/private_key")
public_key_s=$(cat "$HOME/agsbx/sbk/public_key")
short_id_s=$(cat "$HOME/agsbx/sbk/short_id")
if [ -z "$port_ar" ] && [ ! -e "$HOME/agsbx/port_ar" ]; then
port_ar=$(randport)
echo "$port_ar" > "$HOME/agsbx/port_ar"
elif [ -n "$port_ar" ]; then
echo "$port_ar" > "$HOME/agsbx/port_ar"
fi
port_ar=$(cat "$HOME/agsbx/port_ar")
echo "Any-Reality端口：$port_ar"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptargo
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/agsbx/sskey" ]; then
sskey=$("$HOME/agsbx/sing-box" generate rand 16 --base64)
echo "$sskey" > "$HOME/agsbx/sskey"
fi
if [ -z "$port_ss" ] && [ ! -e "$HOME/agsbx/port_ss" ]; then
port_ss=$(randport)
echo "$port_ss" > "$HOME/agsbx/port_ss"
elif [ -n "$port_ss" ]; then
echo "$port_ss" > "$HOME/agsbx/port_ss"
fi
sskey=$(cat "$HOME/agsbx/sskey")
port_ss=$(cat "$HOME/agsbx/port_ss")
echo "Shadowsocks-2022端口：$port_ss"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type": "shadowsocks",
            "tag":"ss-2022",
            "listen": "::",
            "listen_port": $port_ss,
            "method": "2022-blake3-aes-128-gcm",
            "password": "$sskey"
    },  
EOF
else
ssp=ssptargo
fi
}

xrsbhy2(){
if [ -n "$hyp" ]; then
hyp=hypt
if [ -z "$port_hy2" ] && [ ! -e "$HOME/agsbx/port_hy2" ]; then
port_hy2=$(randport)
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
elif [ -n "$port_hy2" ]; then
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
fi
port_hy2=$(cat "$HOME/agsbx/port_hy2")
echo "Hysteria2端口：$port_hy2"
hybw=""
hybwy=""
hybwq=""
if [ -n "$hyup" ] && [ -n "$hydw" ]; then
hybw="        \"up_mbps\": ${hyup},
        \"down_mbps\": ${hydw},
"
hybwy="  up: \"${hyup} Mbps\"
  down: \"${hydw} Mbps\"
"
hybwq="&upmbps=${hyup}&downmbps=${hydw}"
fi
hyobfsb=""
hyobfsy=""
hyobfsq=""
if [ -n "$hyobfs" ]; then
if [ -z "$hyobfspw" ]; then
if [ -s "$HOME/agsbx/obfs_pw" ]; then
hyobfspw=$(cat "$HOME/agsbx/obfs_pw")
else
hyobfspw=$( (command -v openssl >/dev/null 2>&1 && openssl rand -base64 32) | tr -dc 'A-Za-z0-9' | cut -c1-24)
[ -n "$hyobfspw" ] || hyobfspw="obfs$(date +%s)$RANDOM"
echo "$hyobfspw" > "$HOME/agsbx/obfs_pw"
fi
else
echo "$hyobfspw" > "$HOME/agsbx/obfs_pw"
fi
hyobfsb="        \"obfs\": {
            \"type\": \"salamander\",
            \"password\": \"${hyobfspw}\"
        },
"
hyobfsy="  obfs: salamander
  obfs-password: ${hyobfspw}
"
hyobfsq="&obfs=salamander&obfs-password=${hyobfspw}"
fi
# Brutal 仅 sing-box 支持；需要 Brutal 时强制把 Hysteria2 交给 sing-box 承载
hyforce=""
if [ -n "$hybwq" ] && [ -x "$HOME/agsbx/sing-box" ] && [ -s "$HOME/agsbx/sb.json" ]; then
hyforce=yes
echo
echo "已启用 Brutal：Hysteria2 将由 sing-box 承载（Xray 不支持 Brutal）"
fi
if [ -n "$hybw" ]; then
echo "Hysteria2 Brutal 拥塞控制已启用：上行 ${hyup}Mbps / 下行 ${hydw}Mbps（客户端需填相同带宽才生效）"
fi
if [ -n "$hyobfs" ]; then
echo "Hysteria2 已启用 salamander 混淆：${hyobfspw}（客户端需填相同 obfs 密码）"
fi
if [ -e "$HOME/agsbx/xr.json" ] && [ "$hyforce" != yes ]; then
if [ -n "$hyobfsq" ] || [ -n "$hybwq" ]; then
echo "提示：当前 Hysteria2 由 Xray 承载，Xray 不支持 Brutal 与 salamander 混淆，已忽略 hyup/hydw/hyobfs"
hybw=""; hybwy=""; hybwq=""; hyobfsb=""; hyobfsy=""; hyobfsq=""
fi
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag": "hy2-xr",
      "protocol": "hysteria",
      "port": ${port_hy2},
      "settings": {
        "version": 2,
        "clients": [
          {
            "auth": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "tls",
        "tlsSettings": {
		  "alpn": [
             "h3"
            ],
          "certificates": [
            {
              "certificateFile": "$certificateHTA",
              "keyFile": "$keyHTA"
            }
          ]
        }
      },
	   "sniffing": {
       "enabled": true,
       "destOverride": ["http", "tls", "quic"],
       "metadataOnly": false
       }
    },
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
${hybw}${hyobfsb}        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "$certificateHTA",
            "key_path": "$keyHTA"
        }
    },
EOF
fi
else
hyp=hyptargo
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
if [ -z "$port_vm_ws" ] && [ ! -e "$HOME/agsbx/port_vm_ws" ]; then
port_vm_ws=$(randport)
echo "$port_vm_ws" > "$HOME/agsbx/port_vm_ws"
elif [ -n "$port_vm_ws" ]; then
echo "$port_vm_ws" > "$HOME/agsbx/port_vm_ws"
fi
port_vm_ws=$(cat "$HOME/agsbx/port_vm_ws")
echo "Vmess-ws端口：$port_vm_ws"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsbx/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": ${port_vm_ws},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${uuid}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"
        }
    },
EOF
fi
else
vmp=vmptargo
fi
}

xrsbso(){
if [ -n "$sop" ]; then
sop=sopt
if [ -z "$port_so" ] && [ ! -e "$HOME/agsbx/port_so" ]; then
port_so=$(randport)
echo "$port_so" > "$HOME/agsbx/port_so"
elif [ -n "$port_so" ]; then
echo "$port_so" > "$HOME/agsbx/port_so"
fi
port_so=$(cat "$HOME/agsbx/port_so")
echo "Socks5端口：$port_so"
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
         "tag": "socks5-xr",
         "port": ${port_so},
         "listen": "::",
         "protocol": "socks",
         "settings": {
            "auth": "password",
             "accounts": [
               {
               "user": "${uuid}",
               "pass": "${uuid}"
               }
            ],
            "udp": true
          },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
      "tag": "socks5-sb",
      "type": "socks",
      "listen": "::",
      "listen_port": ${port_so},
      "users": [
      {
      "username": "${uuid}",
      "password": "${uuid}"
      }
     ]
    },
EOF
fi
else
sop=soptargo
fi
}

xrsbout(){
if [ -e "$HOME/agsbx/xr.json" ]; then
sed -i '${s/,[[:space:]]*$//}' "$HOME/agsbx/xr.json"
cat >> "$HOME/agsbx/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xryx}"
     }
    },
    {
      "tag": "x-warp-out",
      "protocol": "wireguard",
      "settings": {
        "secretKey": "${pvk}",
        "address": [
          "172.16.0.2/32",
          "${wpv6}/128"
        ],
        "peers": [
          {
            "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
            "allowedIPs": [
              "0.0.0.0/0",
              "::/0"
            ],
            "endpoint": "${xendip}:2408"
          }
        ],
        "reserved": ${res}
        }
    },
    {
      "tag":"warp-out",
      "protocol":"freedom",
        "settings":{
        "domainStrategy":"${wxryx}"
       },
       "proxySettings":{
       "tag":"x-warp-out"
     }
}
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "ip": [ ${xip} ],
        "network": "tcp,udp",
        "outboundTag": "${x1outtag}"
      },
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "${x2outtag}"
      }
    ]
  }
}
EOF
if ! xrcheck; then
echo
echo "❌ xr.json 生成后校验失败：Xray 无法加载该配置（上面为内核报错）"
"$HOME/agsbx/xray" run -test -c "$HOME/agsbx/xr.json" 2>&1 | tail -5
cfgrollback "$HOME/agsbx/xr.json"
fi
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/xr.service <<EOF
[Unit]
Description=xr service
After=network-online.target nss-lookup.target
Wants=network-online.target
StartLimitIntervalSec=60
StartLimitBurst=5
[Service]
Type=simple
NoNewPrivileges=yes
LimitNOFILE=1048576
TimeoutStartSec=0
SyslogIdentifier=xr
ProtectSystem=full
ProtectControlGroups=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectClock=yes
RestrictSUIDSGID=yes
RestrictRealtime=yes
PrivateTmp=yes
ExecStart=$HOME/agsbx/xray run -c $HOME/agsbx/xr.json
Restart=always
RestartSec=3s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xr >/dev/null 2>&1
systemctl start xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/xray <<EOF
#!/sbin/openrc-run
description="xr service"
command="$HOME/agsbx/xray"
command_args="run -c $HOME/agsbx/xr.json"
command_background=yes
pidfile="/run/xray.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/xray >/dev/null 2>&1
rc-update add xray default >/dev/null 2>&1
rc-service xray start >/dev/null 2>&1
else
nohup "$HOME/agsbx/xray" run -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 &
fi
fi
if [ -e "$HOME/agsbx/sb.json" ]; then
sed -i '${s/,[[:space:]]*$//}' "$HOME/agsbx/sb.json"
cat >> "$HOME/agsbx/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "address": [
        "172.16.0.2/32",
        "${wpv6}/128"
      ],
      "private_key": "${pvk}",
      "peers": [
        {
          "address": "${sendip}",
          "port": 2408,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "reserved": $res
        }
      ]
    }
  ],
  "route": {
    "rules": [
       {
          "action": "sniff"
        },
       {
        "action": "resolve",
         "strategy": "${sbyx}"
       },
      {
        "ip_cidr": [ ${sip} ],         
        "outbound": "${s1outtag}"
      }
    ],
    "final": "${s2outtag}"
  }
}
EOF
if ! sbcheck; then
echo
echo "❌ sb.json 生成后校验失败：sing-box 无法加载该配置（上面为内核报错）"
"$HOME/agsbx/sing-box" check -c "$HOME/agsbx/sb.json" 2>&1 | tail -5
cfgrollback "$HOME/agsbx/sb.json"
fi
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/sb.service <<EOF
[Unit]
Description=sb service
After=network-online.target nss-lookup.target
Wants=network-online.target
StartLimitIntervalSec=60
StartLimitBurst=5
[Service]
Type=simple
NoNewPrivileges=yes
LimitNOFILE=1048576
TimeoutStartSec=0
SyslogIdentifier=sb
ProtectSystem=full
ProtectControlGroups=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectClock=yes
RestrictSUIDSGID=yes
RestrictRealtime=yes
PrivateTmp=yes
ExecStart=$HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json
Restart=always
RestartSec=3s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sb >/dev/null 2>&1
systemctl start sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/sing-box <<EOF
#!/sbin/openrc-run
description="sb service"
command="$HOME/agsbx/sing-box"
command_args="run -c $HOME/agsbx/sb.json"
command_background=yes
pidfile="/run/sing-box.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/sing-box >/dev/null 2>&1
rc-update add sing-box default >/dev/null 2>&1
rc-service sing-box start >/dev/null 2>&1
else
nohup "$HOME/agsbx/sing-box" run -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 &
fi
fi
}
ins(){
nettune
if [ "$nvp" != yes ] && [ "$tup" != yes ] && [ "$anp" != yes ] && [ "$arp" != yes ] && [ "$ssp" != yes ]; then
installxray
xrsbhy2
xrsbvm
xrsbso
warpsx
xrsbout
tup="tuptargo"; anp="anptargo"; arp="arptargo"; ssp="ssptargo"; nvp="nvptargo"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$vxp" != yes ] && [ "$vwp" != yes ] && [ "$xup" != yes ] && [ "$xcp" != yes ]; then
installsb
xrsbhy2
xrsbvm
xrsbso
warpsx
xrsbout
xhp="xhptargo"; vlp="vlptargo"; vxp="vxptargo"; vwp="vwptargo"; xup="xuptargo"; xcp="xcptargo"
else
installsb
installxray
xrsbhy2
xrsbvm
xrsbso
warpsx
xrsbout
fi
if [ -n "$argo" ] && [ -n "$vmag" ]; then
echo
echo "=========启用Cloudflared-argo内核========="
if [ ! -e "$HOME/agsbx/cloudflared" ]; then
upcore c "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu" Cloudflared || { echo "❌ Cloudflared内核安装失败，已终止（argo 相关协议需要它）"; exit 1; }
fi
if [ "$argo" = "vmpt" ]; then argoport=$(cat "$HOME/agsbx/port_vm_ws" 2>/dev/null); echo "Vmess" > "$HOME/agsbx/vlvm"; elif [ "$argo" = "vwpt" ]; then argoport=$(cat "$HOME/agsbx/port_vw" 2>/dev/null); echo "Vless" > "$HOME/agsbx/vlvm"; fi; echo "$argoport" > "$HOME/agsbx/argoport.log"
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argoname='固定'
# token 走环境变量文件（600），避免出现在 systemd 单元文件与 ps 命令行里
argoenvi="$HOME/agsbx/argo.env"
printf 'TUNNEL_TOKEN=%s\n' "${ARGO_AUTH}" > "$argoenvi"
chmod 600 "$argoenvi"
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/argo.service <<EOF
[Unit]
Description=argo service
After=network-online.target nss-lookup.target
Wants=network-online.target
StartLimitIntervalSec=60
StartLimitBurst=5
[Service]
Type=simple
NoNewPrivileges=yes
LimitNOFILE=1048576
TimeoutStartSec=0
SyslogIdentifier=argo
ProtectSystem=full
ProtectControlGroups=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
RestrictSUIDSGID=yes
PrivateTmp=yes
EnvironmentFile=-$argoenvi
ExecStart=$HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run
Restart=always
RestartSec=5s
[Install]
WantedBy=multi-user.target
EOF
chmod 600 /etc/systemd/system/argo.service
systemctl daemon-reload >/dev/null 2>&1
systemctl enable argo >/dev/null 2>&1
systemctl start argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/argo <<EOF
#!/sbin/openrc-run
description="argo service"
export TUNNEL_TOKEN="${ARGO_AUTH}"
command="$HOME/agsbx/cloudflared tunnel"
command_args="--no-autoupdate --edge-ip-version auto --protocol http2 run"
pidfile="/run/argo.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/argo >/dev/null 2>&1
rc-update add argo default >/dev/null 2>&1
rc-service argo start >/dev/null 2>&1
else
nohup "$HOME/agsbx/cloudflared" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}" >/dev/null 2>&1 &
fi
echo "${ARGO_DOMAIN}" > "$HOME/agsbx/sbargoym.log"
echo "${ARGO_AUTH}" > "$HOME/agsbx/sbargotoken.log"
else
argoname='临时'
nohup "$HOME/agsbx/cloudflared" tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
echo "申请Argo$argoname隧道中……请稍等"
sleep 15
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [ -n "${argodomain}" ]; then
echo "Argo$argoname隧道申请成功"
else
echo "Argo$argoname隧道申请失败，请稍后再试"
fi
fi
sleep 5
echo
if procunderhome ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/agsbx/d' ~/.bashrc
SCRIPT_PATH="$HOME/bin/agsbx"
mkdir -p "$HOME/bin"
(command -v curl >/dev/null 2>&1 && curl -sL "$agsbxurl" -o "$SCRIPT_PATH") || (command -v wget >/dev/null 2>&1 && wget -qO "$SCRIPT_PATH" "$agsbxurl")
chmod +x "$SCRIPT_PATH"
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行Argosbx脚本的节点恢复操作，请稍等……'; sleep 6; export alns=\"${alns}\" cfip=\"${cfip}\" hyjpt=\"${hyjpt}\" cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" argo=\"${argo}\" uuid=\"${uuid}\" $wap=\"${warp}\" $xhp=\"${port_xh}\" $xup=\"${port_xu}\" $vxp=\"${port_vx}\" $ssp=\"${port_ss}\" $sop=\"${port_so}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $vwp=\"${port_vw}\" $vmp=\"${port_vm_ws}\" $hyp=\"${port_hy2}\" $tup=\"${port_tu}\" $xcp=\"${port_xc}\" $nvp=\"${port_nv}\" reym=\"${ym_vl_re}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash "$HOME/bin/agsbx"; fi" >> ~/.bashrc
fi
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
if procunderhome s ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
if procunderhome x ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
if [ -n "$argo" ] && [ -n "$vmag" ]; then
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
else
if command -v apk >/dev/null 2>&1; then
cat > /etc/local.d/alpineargosbx.start <<EOF
#!/bin/bash
sleep 10
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:\$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
sleep 10
HOME="$HOME" $HOME/bin/agsbx list >/dev/null 2>&1
EOF
chmod +x /etc/local.d/alpineargosbx.start
rc-update add local default >/dev/null 2>&1
else
echo '@reboot sleep 10 && /bin/bash -c "nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 & sleep 10 && bash $HOME/bin/agsbx list >/dev/null 2>&1"' >> /tmp/crontab.tmp
fi
fi
fi
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
echo "Argosbx脚本进程启动成功，安装完毕" && sleep 2
else
echo "Argosbx脚本进程未启动，安装失败" && exit
fi
if [ -n "$cfip" ]; then
set -- $cfip
cdnip1="$1"
cdnip2="$2"
echo "$cdnip1" > "$HOME/agsbx/cdnip1"
echo "$cdnip2" > "$HOME/agsbx/cdnip2"
else
cdnip1="www.shopify.com"
cdnip2="www.wto.org"
echo "$cdnip1" > "$HOME/agsbx/cdnip1"
echo "$cdnip2" > "$HOME/agsbx/cdnip2"
fi
}
argosbxstatus(){
echo "=========当前三大内核运行状态========="
_sv=$(corever "$HOME/agsbx/sing-box" s)
_xv=$(corever "$HOME/agsbx/xray" x)
_cv=$(corever "$HOME/agsbx/cloudflared" c)
if procunderhome s; then
echo "Sing-box (版本V${_sv:-未知})：运行中"
else
echo "Sing-box${_sv:+ (版本V$_sv)}：未启用"
fi
if procunderhome x; then
echo "Xray (版本V${_xv:-未知})：运行中"
else
echo "Xray${_xv:+ (版本V$_xv)}：未启用"
fi
if procunderhome c; then
echo "Argo (版本V${_cv:-未知})：运行中"
else
echo "Argo${_cv:+ (版本V$_cv)}：未启用"
fi
}
cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 -k "$v46url" 2>/dev/null || curl -s6m5 -k "$v46url" 2>/dev/null) ) || (command -v wget >/dev/null 2>&1 && (timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null || timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
location="$v6dq"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
location="$v4dq"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
location="$v4dq"
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
argosbxstatus
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo "服务器地区：$location"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
else
ipbest
fi
}
ipchange
rm -rf "$HOME/agsbx/jhsub.txt"
uuid=$(cat "$HOME/agsbx/uuid")
server_ip=$(cat "$HOME/agsbx/server_ip.log")
sxname=$(cat "$HOME/agsbx/name" 2>/dev/null)
xvvmcdnym=$(cat "$HOME/agsbx/cdnym" 2>/dev/null)
cdnip1=$(cat "$HOME/agsbx/cdnip1" 2>/dev/null)
cdnip2=$(cat "$HOME/agsbx/cdnip2" 2>/dev/null)
if grep -q 'agsbx/private.key' "$HOME/agsbx/sb.json" >/dev/null 2>&1 || grep -q 'agsbx/private.key' "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
sni=www.bing.com
add=$server_ip
jhins=1
msins=true
else
sni=$(cat /root/ygkkkca/ca.log 2>/dev/null)
add=$(cat /root/ygkkkca/ca.log 2>/dev/null)
jhins=0
msins=false
fi
echo "*********************************************************"
echo "*********************************************************"
echo "Argosbx脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
ym_vl_re=$(cat "$HOME/agsbx/ym_vl_re" 2>/dev/null)
if [ -e "$HOME/agsbx/xray" ]; then
private_key_x=$(cat "$HOME/agsbx/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/agsbx/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/agsbx/xrk/short_id" 2>/dev/null)
enkey=$(cat "$HOME/agsbx/xrk/enkey" 2>/dev/null)
fi
if [ -e "$HOME/agsbx/sing-box" ]; then
private_key_s=$(cat "$HOME/agsbx/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/agsbx/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/agsbx/sbk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/agsbx/sskey" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/agsbx/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xh_link"
echo
fi
if grep vless-xhttp "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-enc 】支持ENC加密，节点信息如下："
port_vx=$(cat "$HOME/agsbx/port_vx")
vl_vx_link="vless://$uuid@$server_ip:$port_vx?encryption=$enkey&flow=xtls-rprx-vision&type=xhttp&path=$uuid-vx&mode=auto#${sxname}vl-xhttp-enc-$hostname"
echo "$vl_vx_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vx_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-xhttp-ecn-cdn 】支持ENC加密，节点信息如下："
echo "可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vl_vx_cdn_link="vless://$uuid@$cdnip1:$port_vx?encryption=$enkey&flow=xtls-rprx-vision&type=xhttp&host=$xvvmcdnym&path=$uuid-vx&mode=auto#${sxname}vl-xhttp-enc-cdn-$hostname"
echo "$vl_vx_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vx_cdn_link"
echo
fi
fi
if grep vless-ws "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-ws-enc 】支持ENC加密，节点信息如下："
port_vw=$(cat "$HOME/agsbx/port_vw")
vl_vw_link="vless://$uuid@$server_ip:$port_vw?encryption=none&flow=&type=ws&path=$uuid-vw#${sxname}vl-ws-enc-$hostname"
echo "$vl_vw_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vw_link"
echo
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vless-ws-enc-cdn 】支持ENC加密，节点信息如下："
echo "可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vl_vw_cdn_link="vless://$uuid@$cdnip1:$port_vw?encryption=none&flow=&type=ws&host=$xvvmcdnym&path=$uuid-vw#${sxname}vl-ws-enc-cdn-$hostname"
echo "$vl_vw_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_vw_cdn_link"
echo
fi
fi

if grep xhttp-h23 "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
port_xc=$(cat "$HOME/agsbx/port_xc")
xhttpclmh(){
clxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-TCP-$hostname
  type: vless
  server: $add
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto
EOF
}
clxcpt1(){
echo "- ${sxname}Xhttp-TCP-$hostname"
}
}
if ! grep -A 26 'xhttp-h23' "$HOME/agsbx/xr.json" | grep -q 'ygkkkca' >/dev/null 2>&1; then
sha=$(cat "$HOME/agsbx/SHA256.txt")
echo "💣【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc2_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&hpkp=$sha&pcs=$sha&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc2_link"
xhttpclmh
else
if [ "$sni" != "$(printf '%s' "$server_ip" | tr -d '[]')" ]; then
case "$port_xc" in
443|2053|2083|2087|2096|8443)
echo "💣【 Vless-xhttp-tls-CDN-TCP 】节点信息如下："
echo "可自行更换优选IP域名"
vl_xc2_link="vless://$uuid@$cdnip1:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-CDN-TCP-$hostname"
echo "$vl_xc2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc2_link"
echo
echo "💣【 Vless-xhttp-tls-CDN-UDP 】节点信息如下："
echo "可自行更换优选IP域名"
vl_xc3_link="vless://$uuid@$cdnip2:$port_xc?encryption=none&security=tls&sni=$sni&alpn=h3&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-CDN-UDP-$hostname"
echo "$vl_xc3_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc3_link"
echo
clxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-CDN-TCP-$hostname
  type: vless
  server: $cdnip1
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto

- name: ${sxname}Xhttp-CDN-UDP-$hostname
  type: vless
  server: $cdnip2
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  alpn:
    - h3
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto
EOF
}
clxcpt1(){
echo "- ${sxname}Xhttp-CDN-TCP-$hostname"
echo "- ${sxname}Xhttp-CDN-UDP-$hostname"
}
;;
*)
echo "💣【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc1_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc1_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc1_link"
xhttpclmh
;;
esac
else
echo "💣【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc1_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc1_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc1_link"
xhttpclmh
fi
fi
echo
fi

if grep xhttp-h3 "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-tls-UDP 】节点信息如下："
port_xu=$(cat "$HOME/agsbx/port_xu")
if ! grep -A 26 'xhttp-h3' "$HOME/agsbx/xr.json" | grep -q 'ygkkkca' >/dev/null 2>&1; then
sha=$(cat "$HOME/agsbx/SHA256.txt")
fi
vl_xu_link="vless://$uuid@$add:$port_xu?encryption=none&security=tls&sni=$sni&alpn=h3&insecure=0&allowInsecure=0&hpkp=$sha&pcs=$sha&type=xhttp&path=$uuid-xu&mode=auto#${sxname}Vless-xhttp-tls-UDP-$hostname"
echo "$vl_xu_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xu_link"
echo
cludpxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-UDP-$hostname
  type: vless
  server: $add
  port: $port_xu
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  alpn:
    - h3
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xu"
    mode: auto
EOF
}
cludpxcpt1(){
echo "- ${sxname}Xhttp-UDP-$hostname"
}
fi
if grep reality-vision "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-tcp-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_link"
echo
sbvlpt(){
cat <<EOF
    {
      "type": "vless",
      "tag": "${sxname}vless-$hostname",
      "server": "$server_ip",
      "server_port": $port_vl_re,
      "uuid": "$uuid",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_x",
          "short_id": "$short_id_x"
        }
      }
    },
EOF
}
sbvlpt1(){
echo "\"${sxname}vless-$hostname\","
}
clvlpt(){
cat <<EOF
- name: ${sxname}vless-reality-vision-$hostname               
  type: vless
  server: $server_ip                          
  port: $port_vl_re                                
  uuid: $uuid   
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $ym_vl_re                 
  reality-opts: 
    public-key: $public_key_x    
    short-id: $short_id_x                      
  client-fingerprint: chrome
EOF
}
clvlpt1(){
echo "- ${sxname}vless-reality-vision-$hostname"
}
fi
if grep ss-2022 "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Shadowsocks-2022 】节点信息如下："
port_ss=$(cat "$HOME/agsbx/port_ss")
ss_link="ss://$(echo -n "2022-blake3-aes-128-gcm:$sskey@$server_ip:$port_ss" | base64 -w0)#${sxname}Shadowsocks-2022-$hostname"
echo "$ss_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ss_link"
echo
sbsspt(){
cat <<EOF
{
       "type": "shadowsocks",
       "tag": "${sxname}Shadowsocks-2022-$hostname",
       "server": "$server_ip",
       "server_port": $port_ss,
       "method": "2022-blake3-aes-128-gcm",
       "password": "$sskey",
       "udp_over_tcp": {
        "enabled": true,
        "version": 2
      }
     },
EOF
}
sbsspt1(){
echo "\"${sxname}Shadowsocks-2022-$hostname\","
}
clsspt(){
cat <<EOF
- name: "${sxname}Shadowsocks-2022-$hostname"
  type: ss
  server: $server_ip
  port: $port_ss
  cipher: 2022-blake3-aes-128-gcm
  password: "$sskey"
  udp: true
  udp-over-tcp: true
  udp-over-tcp-version: 2
EOF
}
clsspt1(){
echo "- ${sxname}Shadowsocks-2022-$hostname"
}
fi
if grep vmess-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep vmess-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Vmess-ws 】节点信息如下："
port_vm_ws=$(cat "$HOME/agsbx/port_vm_ws")
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_link"
echo
sbvmpt(){
cat <<EOF
{
            "server": "$server_ip",
            "server_port": $port_vm_ws,
            "tag": "${sxname}vmess-$hostname",
            "tls": {
                "enabled": false,
                "server_name": "www.bing.com",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "transport": {
                "headers": {
                    "Host": [
                        "www.bing.com"
                    ]
                },
                "path": "$uuid-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$uuid"
        },
EOF
}
sbvmpt1(){
echo "\"${sxname}vmess-$hostname\","
}
clvmpt(){
cat <<EOF
- name: ${sxname}vmess-ws-$hostname                         
  type: vmess
  server: $server_ip                        
  port: $port_vm_ws                                     
  uuid: $uuid       
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: www.bing.com                    
  ws-opts:
    path: "$uuid-vm"                             
    headers:
      Host: www.bing.com
EOF
}
clvmpt1(){
echo "- ${sxname}vmess-ws-$hostname"
}
if [ -f "$HOME/agsbx/cdnym" ]; then
echo "💣【 Vmess-ws-cdn 】节点信息如下："
echo "注：默认地址 www.shopify.com 可自行更换优选IP域名，如是回源端口需手动修改443或者80系端口"
vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname\", \"add\": \"www.shopify.com\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$xvvmcdnym\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vm_cdn_link"
echo
fi
fi
if grep naive-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Naiveproxy 】节点信息如下："
port_nv=$(cat "$HOME/agsbx/port_nv")
nv1_link="naive+https://$uuid:$uuid@$(cat /root/ygkkkca/ca.log 2>/dev/null):$port_nv?security=tls&sni=$(cat /root/ygkkkca/ca.log 2>/dev/null)&insecure=0&allowInsecure=0#${sxname}naive-h2-$hostname"
nv2_link="naive+quic://$uuid:$uuid@$(cat /root/ygkkkca/ca.log 2>/dev/null):$port_nv?congestion_control=bbr&security=tls&sni=$(cat /root/ygkkkca/ca.log 2>/dev/null)&insecure=0&allowInsecure=0#${sxname}naive-h3-$hostname"
nv3_link="http2://$uuid:$uuid@$(cat /root/ygkkkca/ca.log 2>/dev/null):$port_nv?security=tls&sni=$(cat /root/ygkkkca/ca.log 2>/dev/null)&insecure=0&allowInsecure=0&padding=1&tfo=1#${sxname}naive-h2-$hostname"
nv4_link="http3://$uuid:$uuid@$(cat /root/ygkkkca/ca.log 2>/dev/null):$port_nv?security=tls&sni=$(cat /root/ygkkkca/ca.log 2>/dev/null)&insecure=0&allowInsecure=0&padding=1&tfo=1#${sxname}naive-h3-$hostname"
echo "$nv1_link" >> "$HOME/agsbx/jhsub.txt"
echo "$nv2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$nv3_link" >> "$HOME/agsbx/jhsub.txt"
echo "$nv4_link" >> "$HOME/agsbx/jhsub.txt"
echo "V2rayN/Karing/Nekobox单节点分享："
echo "$nv1_link" 
echo "$nv2_link"
echo
echo "Shadowrocket小火箭单节点分享："
echo "$nv3_link"
echo "$nv4_link"
echo
sbnvpt(){
cat <<EOF
         {
            "type": "naive",
            "tag": "${sxname}naive-h3-$hostname",
            "server": "$(cat /root/ygkkkca/ca.log 2>/dev/null)",
            "server_port": $port_nv,
            "username": "$uuid",
            "password": "$uuid",
            "udp_over_tcp": false,
            "quic": true,
            "quic_congestion_control": "bbr",
            "tls": {
                "enabled": true,
                "insecure": false,
                "server_name": "$(cat /root/ygkkkca/ca.log 2>/dev/null)"
            }
         },
		 {
            "type": "naive",
            "tag": "${sxname}naive-h2-$hostname",
            "server": "$(cat /root/ygkkkca/ca.log 2>/dev/null)",
            "server_port": $port_nv,
            "username": "$uuid",
            "password": "$uuid",
            "udp_over_tcp": true,
            "quic": false,
            "tls": {
                "enabled": true,
                "insecure": false,
                "server_name": "$(cat /root/ygkkkca/ca.log 2>/dev/null)"
            }
         },
EOF
}
sbnvpt1(){
echo "\"${sxname}naive-h3-$hostname\","
echo "\"${sxname}naive-h2-$hostname\","
}
fi
if grep anytls-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsbx/port_an")
an_link="anytls://$uuid@$add:$port_an?sni=$sni&insecure=$jhins&allowInsecure=$jhins#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsbx/jhsub.txt"
echo "$an_link"
echo
sbanpt(){
cat <<EOF
         {
            "type": "anytls",
            "tag": "${sxname}anytls-$hostname",
            "server": "$add",
            "server_port": $port_an,
            "password": "$uuid",
            "idle_session_check_interval": "30s",
            "idle_session_timeout": "30s",
            "min_idle_session": 5,
            "tls": {
                "enabled": true,
                "insecure": $msins,
                "server_name": "$sni"
            }
         },
EOF
}
sbanpt1(){
echo "\"${sxname}anytls-$hostname\","
}
clanpt(){
cat <<EOF
- name: ${sxname}anytls-$hostname
  type: anytls
  server: $add
  port: $port_an
  password: $uuid
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  sni: $sni
  skip-cert-verify: $msins
EOF
}
clanpt1(){
echo "- ${sxname}anytls-$hostname"
}
fi
if grep anyreality-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsbx/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ar_link"
echo
sbarpt(){
cat <<EOF
    {
        "type": "anytls",
        "tag": "${sxname}any-reality-$hostname",
        "server": "$server_ip",
        "server_port": $port_ar,
        "password": "$uuid",
        "idle_session_check_interval": "30s",
        "idle_session_timeout": "30s",
        "min_idle_session": 5,
        "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_s",
          "short_id": "$short_id_s"
        }
      }
         },
EOF
}
sbarpt1(){
echo "\"${sxname}any-reality-$hostname\","
}
fi
if grep -q 'hy2-sb' "$HOME/agsbx/sb.json" >/dev/null 2>&1 || grep -q 'hy2-xr' "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "💣【 Hysteria2 】节点信息如下："
sha=""
hypsha=""
if { [ -f "$HOME/agsbx/sb.json" ] && grep -q 'hy2-sb' "$HOME/agsbx/sb.json" && ! grep -A 14 'hy2-sb' "$HOME/agsbx/sb.json" | grep -q 'ygkkkca'; } || { [ -f "$HOME/agsbx/xr.json" ] && grep -q 'hy2-xr' "$HOME/agsbx/xr.json" && ! grep -A 20 'hy2-xr' "$HOME/agsbx/xr.json" | grep -q 'ygkkkca'; }; then
sha=$(cat "$HOME/agsbx/SHA256.txt" 2>/dev/null)
fi
if [ -n "$sha" ]; then
hypsha="&pinSHA256=$sha"
fi
port_hy2=$(cat "$HOME/agsbx/port_hy2")
# 从已生成配置回读 Brutal / obfs，保证 list 重生成的链接与订阅参数不丢
hybw=""
hybwy=""
hybwq=""
hyobfsb=""
hyobfsy=""
hyobfsq=""
hy2sbport=$(grep -A6 '"type": "hysteria2"' "$HOME/agsbx/sb.json" 2>/dev/null | grep -m1 -o '"listen_port": *[0-9]*' | tr -dc '0-9')
if [ -s "$HOME/agsbx/sb.json" ] && grep -q 'hy2-sb' "$HOME/agsbx/sb.json" 2>/dev/null && [ "$hy2sbport" = "$port_hy2" ]; then
hyup2=$(grep -o '"up_mbps": *[0-9]*' "$HOME/agsbx/sb.json" 2>/dev/null | head -1 | tr -dc '0-9')
hydw2=$(grep -o '"down_mbps": *[0-9]*' "$HOME/agsbx/sb.json" 2>/dev/null | head -1 | tr -dc '0-9')
if [ -n "$hyup2" ] && [ -n "$hydw2" ]; then
hybw="        \"up_mbps\": ${hyup2},
        \"down_mbps\": ${hydw2},
"
hybwy="  up: \"${hyup2} Mbps\"
  down: \"${hydw2} Mbps\"
"
hybwq="&upmbps=${hyup2}&downmbps=${hydw2}"
fi
hyobfspw=$(grep -A2 '"type": "salamander"' "$HOME/agsbx/sb.json" 2>/dev/null | grep -o '"password": *"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
if [ -n "$hyobfspw" ]; then
hyobfsb="        \"obfs\": {
            \"type\": \"salamander\",
            \"password\": \"${hyobfspw}\"
        },
"
hyobfsy="  obfs: salamander
  obfs-password: ${hyobfspw}
"
hyobfsq="&obfs=salamander&obfs-password=${hyobfspw}"
fi
fi
hy2_ports=$(iptables -t nat -nL --line 2>/dev/null | grep -w "$port_hy2" | awk '{print $8}' | sed 's/dpts://; s/dpt://' | tr '\n' ',' | sed 's/,$//')
if [ -n "$hy2_ports" ] || [ -n "$hyjpt" ]; then
echo "Hysteria2跳跃端口已开启：$hy2_ports"
cmhy2pt=$(echo $hy2_ports | tr ':' '-')
hyps="&mport=$cmhy2pt"
sbhy2pt=$(echo "$hy2_ports" | grep -o '[0-9]\+:[0-9]\+' | sed 's/.*/"&"/' | paste -sd,)
sbhy2ports(){
    cat <<EOF
  "server_ports": [ $sbhy2pt ],
EOF
}
else
hyps=
fi
#hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&allowInsecure=1$hyps&sni=www.bing.com#${sxname}hy2-$hostname"
hy2_link="hysteria2://$uuid@$add:$port_hy2?security=tls&alpn=h3&insecure=$jhins&allowInsecure=$jhins$hyps$hybwq$hyobfsq&sni=$sni$hypsha#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$hy2_link"
echo
sbhypt(){
cat <<EOF
    {
        "type": "hysteria2",
        "tag": "${sxname}hy2-$hostname",
        "server": "$add",
        "server_port": $port_hy2,
$(sbhy2ports 2>/dev/null)
${hybw}${hyobfsb}        "password": "$uuid",
        "tls": {
            "enabled": true,
            "server_name": "$sni",
            "insecure": $msins,
            "alpn": [
                "h3"
            ]
        }
    },
EOF
}
sbhypt1(){
echo "\"${sxname}hy2-$hostname\","
}
clhypt(){
cat <<EOF
- name: ${sxname}hysteria2-$hostname                            
  type: hysteria2                                      
  server: $add                              
  port: $port_hy2
  ports: $cmhy2pt
  password: $uuid                          
${hybwy}${hyobfsy}  alpn:
    - h3
  sni: $sni                               
  skip-cert-verify: $msins
  fast-open: true
EOF
}
clhypt1(){
echo "- ${sxname}hysteria2-$hostname"
}
fi
if grep tuic5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/agsbx/port_tu")
tuic5_link="tuic://$uuid:$uuid@$add:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=$sni&insecure=$jhins&allowInsecure=$jhins&allow_insecure=$jhins#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/agsbx/jhsub.txt"
echo "$tuic5_link"
echo
sbtupt(){
cat <<EOF
        {
            "type":"tuic",
            "tag": "${sxname}tuic5-$hostname",
            "server": "$add",
            "server_port": $port_tu,
            "uuid": "$uuid",
            "password": "$uuid",
            "congestion_control": "bbr",
            "udp_relay_mode": "native",
            "udp_over_stream": false,
            "zero_rtt_handshake": false,
            "heartbeat": "10s",
            "tls":{
                "enabled": true,
                "server_name": "$sni",
                "insecure": $msins,
                "alpn": [
                    "h3"
                ]
            }
        },
EOF
}
sbtupt1(){
echo "\"${sxname}tuic5-$hostname\","
}
cltupt(){
cat <<EOF
- name: ${sxname}tuic5-$hostname                            
  server: $add                      
  port: $port_tu                                    
  type: tuic
  uuid: $uuid       
  password: $uuid   
  alpn: [h3]
  disable-sni: true
  reduce-rtt: true
  udp-relay-mode: native
  congestion-controller: bbr
  sni: $sni                                
  skip-cert-verify: $msins
EOF
}
cltupt1(){
echo "- ${sxname}tuic5-$hostname"
}
fi
if grep socks5-xr "$HOME/agsbx/xr.json" >/dev/null 2>&1 || grep socks5-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "💣【 Socks5 】客户端信息如下："
port_so=$(cat "$HOME/agsbx/port_so")
echo "请配合其他应用内置代理使用，勿做节点直接使用"
echo "客户端地址：$server_ip"
echo "客户端端口：$port_so"
echo "客户端用户名：$uuid"
echo "客户端密码：$uuid"
echo
fi
argodomain=$(cat "$HOME/agsbx/sbargoym.log" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=$(cat "$HOME/agsbx/agnd" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=${agnd:-}
[ -z "$argodomain" ] && argodomain=$(grep -a trycloudflare.com "$HOME/agsbx/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -n "$argodomain" ]; then
vlvm=$(cat "$HOME/agsbx/vlvm" 2>/dev/null)
if [ -z "$vlvm" ]; then
if grep -qs '"tag": *"vmess-' "$HOME/agsbx/xr.json" "$HOME/agsbx/sb.json" 2>/dev/null; then vlvm=Vmess
elif grep -qs '"tag": *"vless-ws' "$HOME/agsbx/xr.json" "$HOME/agsbx/sb.json" 2>/dev/null; then vlvm=Vless
fi
fi
if [ -n "$vlvm" ]; then printf '%s\n' "$vlvm" > "$HOME/agsbx/vlvm"; chmod 600 "$HOME/agsbx/vlvm" 2>/dev/null; fi
_agl=()
if [ -s "$HOME/agsbx/agip" ]; then
while IFS= read -r _gl; do
_gl=$(printf '%s' "$_gl" | tr -d ' \t\r')
case "$_gl" in ''|\#*) continue ;; esac
_agl+=("$_gl")
done < "$HOME/agsbx/agip"
fi
[ ${#_agl[@]} -eq 0 ] && _agl=("$(a4 "$cdnip1")" "$(a4 "$argodomain")" "$(a4 "$cdnip2")")
agip1=${agip1:-${_agl[0]}}
agip2=${agip2:-${_agl[1]}}
agip3=${agip3:-${_agl[2]}}
[ -z "$agip1" ] && agip1=$(a4 "$cdnip1")
[ -z "$agip2" ] && agip2=$agip1
[ -z "$agip3" ] && agip3=$agip1
if [ "$vlvm" = "Vmess" ]; then
if [ "$aghttp" = "yes" ]; then
agports="443 8443 2053 2083 2087 2096 80 8080 8880 2052 2082 2086 2095"
else
agports="443 8443 2053 2083 2087 2096 443 8443 2053 2083 2087 2096 443"
fi
_agn=0; _seen=" "
for _ap in $agports; do
_agn=$((_agn+1))
_ai=$(( (_agn-1) % ${#_agl[@]} ))
_aip=${_agl[$_ai]}
case "$_ap" in
80|8080|8880|2052|2082|2086|2095) _atls=''; _asni='' ;;
*) _atls=tls; _asni=$argodomain ;;
esac
case "$_seen" in
*" $_ap "*) _aname="${sxname}vmess-ws-tls-argo-$hostname-$_ap-$_agn" ;;
*) _aname="${sxname}vmess-ws-tls-argo-$hostname-$_ap" ;;
esac
_seen="$_seen$_ap "
_alink="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"$_aname\", \"add\": \"$_aip\", \"port\": \"$_ap\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm\", \"tls\": \"$_atls\", \"sni\": \"$_asni\", \"alpn\": \"\", \"fp\": \"chrome\"}" | base64 -w0)"
echo "$_alink" >> "$HOME/agsbx/jhsub.txt"
[ "$_agn" = 1 ] && vmatls_link1="$_alink"
[ "$_agn" = 7 ] && vma_link7="$_alink"
done
sbvmargopt(){
cat <<EOF
{
            "server": "$agip1",
            "server_port": 443,
            "tag": "${sxname}vmess-ws-tls-argo-$hostname-443",
            "tls": {
                "enabled": true,
                "server_name": "$argodomain",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "transport": {
                "headers": {
                    "Host": [
                        "$argodomain"
                    ]
                },
                "path": "$uuid-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$uuid"
        },
{
            "server": "$agip2",
            "server_port": 8443,
            "tag": "${sxname}vmess-ws-tls-argo-$hostname-8443",
            "tls": {
                "enabled": true,
                "server_name": "$argodomain",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "transport": {
                "headers": {
                    "Host": [
                        "$argodomain"
                    ]
                },
                "path": "$uuid-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$uuid"
        },
EOF
}
sbvmargopt1(){
echo "\"${sxname}vmess-ws-tls-argo-$hostname-443\","
echo "\"${sxname}vmess-ws-tls-argo-$hostname-8443\","
}
clvmargopt(){
cat <<EOF
- name: ${sxname}vmess-ws-tls-argo-$hostname-443                         
  type: vmess
  server: "$agip1"                       
  port: 443                                     
  uuid: $uuid       
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  network: ws
  servername: $argodomain                    
  ws-opts:
    path: "$uuid-vm"                             
    headers:
      Host: $argodomain
- name: ${sxname}vmess-ws-tls-argo-$hostname-8443                         
  type: vmess
  server: "$agip2"                        
  port: 8443                                     
  uuid: $uuid       
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  network: ws
  servername: $argodomain                    
  ws-opts:
    path: "$uuid-vm"                             
    headers:
      Host: $argodomain
EOF
}
clvmargopt1(){
echo "- ${sxname}vmess-ws-tls-argo-$hostname-443"
echo "- ${sxname}vmess-ws-tls-argo-$hostname-8443"
}
elif [ "$vlvm" = "Vless" ]; then
vwatls_link1="vless://$uuid@$agip1:443?encryption=none&flow=&type=ws&host=$argodomain&path=$uuid-vw&security=tls&sni=$argodomain&fp=chrome&insecure=0&allowInsecure=0#${sxname}vless-ws-tls-argo-enc-vision-$hostname"
echo "$vwatls_link1" >> "$HOME/agsbx/jhsub.txt"
vwa_link2="vless://$uuid@$agip3:80?encryption=none&flow=&type=ws&host=$argodomain&path=$uuid-vw&security=none#${sxname}vless-ws-argo-enc-vision-$hostname"
echo "$vwa_link2" >> "$HOME/agsbx/jhsub.txt"
fi
sbtk=$(cat "$HOME/agsbx/sbargotoken.log" 2>/dev/null)
if [ -n "$sbtk" ]; then
nametn="Argo固定隧道token：$sbtk"
fi
argoshow=$(
echo "Argo隧道端口正在使用$vlvm-ws主协议端口：$(cat $HOME/agsbx/argoport.log 2>/dev/null)
Argo域名：$argodomain
$nametn

1、💣443端口的$vlvm-ws-tls-argo节点(优选IP与443系端口随便换)
${vmatls_link1}${vwatls_link1}

2、💣8443端口的$vlvm-ws-tls-argo节点(优选IP与TLS端口随便换；如需80系端口用 aghttp=yes 重新 list)
${vma_link7}${vwa_link2}
"
)
fi

get_func() {
local f=$1
if type "$f" >/dev/null 2>&1; then
local out
out=$($f)
[ -n "$out" ] && printf "%s\n" "$out"
fi
}
sbxy="$(get_func sbvlpt; get_func sbsspt; get_func sbanpt; get_func sbarpt; get_func sbvmpt; get_func sbhypt; get_func sbtupt; get_func sbnvpt; get_func sbvmargopt)"
clxy="$(get_func cludpxcpt; get_func clxcpt; get_func clvlpt; get_func clsspt; get_func clanpt; get_func clvmpt; get_func clhypt; get_func cltupt; get_func clvmargopt)"
sbgz="$(get_func sbvlpt1; get_func sbsspt1; get_func sbanpt1; get_func sbarpt1; get_func sbvmpt1; get_func sbhypt1; get_func sbtupt1; get_func sbnvpt1; get_func sbvmargopt1)"
clgz="$({ get_func cludpxcpt1; get_func clxcpt1; get_func clvlpt1; get_func clsspt1; get_func clanpt1; get_func clvmpt1; get_func clhypt1; get_func cltupt1; get_func clvmargopt1; } | sed '2,$s/^/    /')"
sbgz=$(printf "%s\n" "$sbgz" | sed '$ s/,$//')
cat > $HOME/agsbx/sbox.json <<EOF
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "http_clients": [
    {
      "tag": "rule-set-direct"
    }
  ],
  "dns": {
    "servers": [
      {
        "type": "fakeip",
        "tag": "fakeip",
        "inet4_range": "198.18.0.0/15",
        "inet6_range": "fc00::/18"
      },
      {
        "type": "udp",
        "tag": "dns-cn",
        "server": "223.5.5.5",
        "server_port": 53
      },
      {
        "type": "https",
        "tag": "dns-proxy",
        "server": "dns.google",
        "domain_resolver": "dns-cn",
        "detour": "proxy"
      }
    ],
    "rules": [
      {
        "rule_set": [
          "geosite-cn"
        ],
        "action": "route",
        "server": "dns-cn"
      },
      {
        "query_type": [
          "A",
          "AAAA"
        ],
        "action": "route",
        "server": "fakeip"
      }
    ],
    "final": "dns-proxy",
    "strategy": "prefer_ipv4",
    "cache_capacity": 8192,
    "optimistic": {
      "enabled": true,
      "timeout": "1h"
    },
    "timeout": "10s",
    "reverse_mapping": true
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "address": [
        "172.19.0.1/30",
        "fdfe:dcba:9876::1/126"
      ],
      "auto_route": true,
      "strict_route": true,
      "mtu": 1420
    }
  ],
  "outbounds": [
   $sbxy
    {
      "type": "selector",
      "tag": "proxy",
      "default": "auto",
      "outbounds": [
        "auto",
        $sbgz
      ]
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
      $sbgz
      ],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "10m",
      "tolerance": 30,
      "idle_timeout": "30m"
    },
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "default_http_client": "rule-set-direct",
    "default_domain_resolver": "dns-cn",
    "auto_detect_interface": true,
    "rule_set": [
      {
        "tag": "geosite-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/cn.srs"
      },
      {
        "tag": "geoip-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs"
      }
    ],
    "rules": [
      {
        "inbound": [
          "tun-in"
        ],
        "protocol": [
          "dns"
        ],
        "action": "hijack-dns"
      },
      {
        "clash_mode": "Global",
        "action": "route",
        "outbound": "proxy"
      },
      {
        "ip_is_private": true,
        "action": "route",
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geosite-cn"
        ],
        "action": "route",
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geoip-cn"
        ],
        "action": "route",
        "outbound": "direct"
      },
      {
        "clash_mode": "Direct",
        "action": "route",
        "outbound": "direct"
      },
      {
        "network": [
          "tcp",
          "udp"
        ],
        "port": 853,
        "action": "reject"
      }
    ],
    "final": "proxy"
  },
  "experimental": {
    "cache_file": {
      "enabled": true,
      "store_dns": true
    },
    "clash_api": {
      "external_controller": "127.0.0.1:9090",
      "external_ui": "ui",
      "default_mode": "Rule"
    }
  }
}
EOF

cat > $HOME/agsbx/clmi.yaml <<EOF
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
dns:
  enable: true 
  listen: "0.0.0.0:1053"
  ipv6: true
  prefer-h3: false
  respect-rules: true
  use-system-hosts: false
  cache-algorithm: "arc"
  enhanced-mode: "fake-ip"
  fake-ip-range: "198.18.0.1/16"
  fake-ip-filter:
    - "+.lan"
    - "+.local"
    - "+.msftconnecttest.com"
    - "+.msftncsi.com"
    - "localhost.ptlogin2.qq.com"
    - "localhost.sec.qq.com"
    - "+.in-addr.arpa"
    - "+.ip6.arpa"
    - "time.*.com"
    - "time.*.gov"
    - "pool.ntp.org"
    - "localhost.work.weixin.qq.com"
  default-nameserver: ["223.5.5.5", "119.29.29.29"]
  nameserver:
    - "https://1.1.1.1/dns-query"
    - "https://8.8.8.8/dns-query"
  proxy-server-nameserver:
    - "https://223.5.5.5/dns-query"
    - "https://doh.pub/dns-query"

proxies:
$clxy

proxy-groups:
- name: 负载均衡
  type: load-balance
  url: https://www.gstatic.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    $clgz
- name: 自动选择
  type: url-test
  url: https://www.gstatic.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    $clgz 
- name: 🌍选择代理节点
  type: select
  proxies:
    - 负载均衡                                         
    - 自动选择
    - DIRECT
    $clgz
rules:
  - GEOIP,LAN,DIRECT
  - GEOSITE,CN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,🌍选择代理节点
EOF
echo "---------------------------------------------------------"
echo "$argoshow"
echo
if [ -s $HOME/agsbx/subport.log ]; then
showsubport=$(cat $HOME/agsbx/subport.log)
if ps -ef 2>/dev/null | grep "$showsubport" | grep -v grep >/dev/null; then
showsubtoken=$(cat $HOME/agsbx/subtoken.log 2>/dev/null)
subip=$(cat $HOME/agsbx/server_ip.log 2>/dev/null)
suburl="$subip:$showsubport/$showsubtoken"
echo "**********************************************************"
echo "Clash/Mihomo本地IP订阅地址：http://$suburl/clmi.yaml"
echo "Sing-box本地IP订阅地址：http://$suburl/sbox.json"
echo "聚合协议本地IP订阅地址：http://$suburl/jhsub.txt"
echo "**********************************************************"
fi
fi
echo
echo "---------------------------------------------------------"
echo "聚合节点信息，请进入 $HOME/agsbx/jhsub.txt 文件目录查看或者运行 cat $HOME/agsbx/jhsub.txt 查看"
echo "========================================================="
echo "相关快捷方式如下：(首次安装成功后需重连SSH，agsbx快捷方式才可生效；如未生效，请使用主脚本)"
showmode
}
cleandel(){
killhome s; killhome x; killhome c
killhome s; killhome x; killhome c
sed -i '/agsbx/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
sed -i '/websbx/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
rm -rf  "$HOME/bin/agsbx"
if pidof systemd >/dev/null 2>&1; then
for svc in xr sb argo; do
systemctl stop "$svc" >/dev/null 2>&1
systemctl disable "$svc" >/dev/null 2>&1
done
rm -rf /etc/systemd/system/{xr.service,sb.service,argo.service}
elif command -v rc-service >/dev/null 2>&1; then
for svc in sing-box xray argo; do
rc-service "$svc" stop >/dev/null 2>&1
rc-update del "$svc" default >/dev/null 2>&1
done
rm -rf /etc/init.d/{sing-box,xray,argo} /etc/local.d/alpineargosbx.start /etc/local.d/alpinesubsbx.start
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
hy2natclean
netfilter-persistent save >/dev/null 2>&1
}
xrestart(){
killhome x
if pidof systemd >/dev/null 2>&1; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
killhome s
if pidof systemd >/dev/null 2>&1; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &
fi
}
if [ "$1" = "del" ]; then
cleandel
rm -rf sbx_update "$HOME/agsbx" "$HOME/websbx"
echo "卸载完成"
echo "欢迎继续使用甬哥侃侃侃ygkkk的Argosbx一键无交互小钢炮脚本💣" && sleep 2
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsbx"/{sb.json,xr.json,sbargoym.log,sbargotoken.log,argo.log,argoport.log,cdnym,name}
echo "Argosbx重置协议完成，开始更新相关协议变量……" && sleep 2
echo
elif [ "$1" = "tune" ]; then
nettune
echo "当前拥塞控制算法：$(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null)，队列算法：$(sysctl -n net.core.default_qdisc 2>/dev/null)"
exit
elif [ "$1" = "list" ]; then
cip
lockfiles
exit
elif [ "$1" = "upx" ]; then
upcore x "https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-$cpu" Xray || exit
if [ "$coreupd" != "yes" ]; then
echo "Xray内核未做替换，服务保持原样运行" && sleep 2 && cip
exit
fi
if [ ! -s "$HOME/agsbx/xr.json" ]; then
echo "Xray内核已就位，但本机没有 Xray 协议配置，跳过重启" && sleep 2 && cip
exit
fi
xrestart
sleep 3
if procunderhome x; then
echo "Xray内核更新完成，当前版本：v$(corever "$HOME/agsbx/xray" x)"
else
echo "❌ 新内核未能启动，自动回滚旧内核……"
[ -x "$HOME/agsbx/xray.bak" ] && mv -f "$HOME/agsbx/xray.bak" "$HOME/agsbx/xray" && chmod +x "$HOME/agsbx/xray"
xrestart
sleep 3
if procunderhome x; then
echo "已回滚到旧内核并恢复运行：v$(corever "$HOME/agsbx/xray" x)"
else
echo "⚠️ 回滚后仍未启动，请检查：journalctl -u xr -n 50"
echo "   手动排查：$HOME/agsbx/xray run -c $HOME/agsbx/xr.json"
fi
fi
sleep 2 && cip
exit
elif [ "$1" = "ups" ]; then
upcore s "https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-$cpu" Sing-box || exit
if [ "$coreupd" != "yes" ]; then
echo "Sing-box内核未做替换，服务保持原样运行" && sleep 2 && cip
exit
fi
if [ ! -s "$HOME/agsbx/sb.json" ]; then
echo "Sing-box内核已就位，但本机没有 Sing-box 协议配置，跳过重启" && sleep 2 && cip
exit
fi
sbroll=no
if [ -s "$HOME/agsbx/sb.json" ] && ! "$HOME/agsbx/sing-box" check -c "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "⚠️ 新内核与本机现有配置不兼容（sing-box check 未通过），先回滚旧内核"
[ -x "$HOME/agsbx/sing-box.bak" ] && mv -f "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box" && chmod +x "$HOME/agsbx/sing-box"
sbroll=yes
fi
sbrestart
sleep 3
if [ "$sbroll" = yes ] && procunderhome s; then
echo "已回滚到旧内核并恢复运行：v$(corever "$HOME/agsbx/sing-box" s)（新内核与现有配置不兼容，可先用 agsbx rep 重建配置再升级）"
elif procunderhome s; then
echo "Sing-box内核更新完成，当前版本：v$(corever "$HOME/agsbx/sing-box" s)"
else
echo "❌ 新内核未能启动，自动回滚旧内核……"
[ -x "$HOME/agsbx/sing-box.bak" ] && mv -f "$HOME/agsbx/sing-box.bak" "$HOME/agsbx/sing-box" && chmod +x "$HOME/agsbx/sing-box"
sbrestart
sleep 3
if procunderhome s; then
echo "已回滚到旧内核并恢复运行：v$(corever "$HOME/agsbx/sing-box" s)"
else
echo "⚠️ 回滚后仍未启动，请检查：journalctl -u sb -n 50"
echo "   手动排查：$HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json"
fi
fi
sleep 2 && cip
exit
elif [ "$1" = "upa" ]; then
upcore c "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu" Cloudflared || exit
if [ "$coreupd" != "yes" ]; then
echo "Cloudflared内核未做替换，服务保持原样运行" && sleep 2 && cip
exit
fi
if [ -e "$HOME/agsbx/sbargotoken.log" ]; then
if pidof systemd >/dev/null 2>&1; then
systemctl restart argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service argo restart >/dev/null 2>&1
else
nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
fi
else
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log 2>/dev/null) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
echo "Cloudflared-argo内核更新完成，当前版本：v$(corever "$HOME/agsbx/cloudflared" c)" && sleep 2 && cip
exit
elif [ "$1" = "res" ]; then
for P in /proc/[0-9]*; do
[ -L "$P/exe" ] || continue
TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue
case "$TARGET" in
*"/agsbx/s"*)
kill "$(basename "$P")" 2>/dev/null
sbrestart
;;
*"/agsbx/x"*)
kill "$(basename "$P")" 2>/dev/null
xrestart
;;
*"/agsbx/c"*)
kill "$(basename "$P")" 2>/dev/null
killhome c
if [ -e "$HOME/agsbx/sbargotoken.log" ]; then
if pidof systemd >/dev/null 2>&1; then
systemctl restart argo >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service argo restart >/dev/null 2>&1
else
nohup $HOME/agsbx/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsbx/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
fi
else
nohup $HOME/agsbx/cloudflared tunnel --url http://localhost:$(cat $HOME/agsbx/argoport.log 2>/dev/null) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsbx/argo.log 2>&1 &
fi
;;
esac
done
sleep 5 && echo "重启完成" && sleep 3 && cip
exit
fi
if ! procunderhome && [ ! -s "$HOME/agsbx/sb.json" ] && [ ! -s "$HOME/agsbx/xr.json" ]; then
killhome s; killhome x; killhome c
killhome s; killhome x; killhome c
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
if [ -n "$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
sendip="2606:4700:d0::a29f:c001"
xendip="[2606:4700:d0::a29f:c001]"
else
sendip="162.159.192.1"
xendip="162.159.192.1"
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "Argosbx脚本未安装，开始安装…………" && sleep 1
if [ -n "$oap" ]; then
setenforce 0 >/dev/null 2>&1
iptables-save > "$HOME/agsbx/iptables_before_oap.rules" 2>/dev/null
ip6tables-save > "$HOME/agsbx/ip6tables_before_oap.rules" 2>/dev/null
echo
echo "⚠️  oap=1 会清空服务器上所有 iptables/ip6tables 规则（含 ufw、fail2ban、Docker 的规则）"
echo "    原规则已备份到 $HOME/agsbx/iptables_before_oap.rules 与 ip6tables_before_oap.rules"
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
ip6tables -P INPUT ACCEPT >/dev/null 2>&1
ip6tables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
echo "iptables执行开放所有端口"
fi
if [ ! -s "$HOME/agsbx/cert.crt" ] || [ ! -s "$HOME/agsbx/private.key" ]; then
rm -f "$HOME/agsbx/SHA256.txt"
command -v openssl >/dev/null 2>&1 && openssl ecparam -genkey -name prime256v1 -out "$HOME/agsbx/private.key" >/dev/null 2>&1
command -v openssl >/dev/null 2>&1 && openssl req -new -x509 -days 36500 -key "$HOME/agsbx/private.key" -out "$HOME/agsbx/cert.crt" -subj "/CN=www.bing.com" >/dev/null 2>&1
fi
if [ -s "$HOME/agsbx/cert.crt" ] && [ -s "$HOME/agsbx/private.key" ]; then
chmod 600 "$HOME/agsbx/private.key" 2>/dev/null
SHA256=$(openssl x509 -in "$HOME/agsbx/cert.crt" -outform DER 2>/dev/null | sha256sum | awk '{print $1}')
[ -n "$SHA256" ] && echo "$SHA256" > "$HOME/agsbx/SHA256.txt"
else
echo "⚠️  自签证书生成失败（可能缺少 openssl），依赖 TLS 的协议会启动失败，请安装 openssl 后重跑脚本"
fi
if [ -n "$alns" ] && [ ! -s "/root/ygkkkca/private.key" ]; then
bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/acme-yg/main/acme.sh)
fi
echo
if [ -n "$alns" ] && [ -s "/root/ygkkkca/private.key" ]; then
certificateHTA="/root/ygkkkca/cert.crt"
keyHTA="/root/ygkkkca/private.key"
echo "HY2/TUIC/Naive/Anytls/Xhttp-tls将使用IP证书或域名证书的TLS"
else
certificateHTA="$HOME/agsbx/cert.crt"
keyHTA="$HOME/agsbx/private.key"
echo "HY2/TUIC/Anytls/Xhttp-tls将使用自签证书的TLS"
fi
ins
lockfiles
if [ -n "$sub" ]; then
subtokenipsub(){
if [ -z "$subid" ]; then
subtoken="$(cat "$HOME/agsbx/uuid")"
else
subtoken="$subid"
fi
rm -rf $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"
echo $subtoken > $HOME/agsbx/subtoken.log
}
subportipsub(){
if [ -z "$subpt" ]; then
if [ -n "$(cat "$HOME/agsbx/subport.log" 2>/dev/null)" ]; then
subport=$(cat $HOME/agsbx/subport.log)
else
subport=$(randport)
fi
else
subport="$subpt"
fi
echo $subport > $HOME/agsbx/subport.log
}
subtokenipsub && subportipsub
echo "请稍后…………"
kill -15 $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
mkdir -p $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"
ln -sf $HOME/agsbx/clmi.yaml $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/clmi.yaml
ln -sf $HOME/agsbx/sbox.json $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/sbox.json
ln -sf $HOME/agsbx/jhsub.txt $HOME/websbx/"$(cat $HOME/agsbx/subtoken.log 2>/dev/null)"/jhsub.txt
if command -v apk >/dev/null 2>&1; then
busybox-extras httpd -f -p "$(cat $HOME/agsbx/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
else
busybox httpd -f -p "$(cat $HOME/agsbx/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
fi
sleep 5
if command -v apk >/dev/null 2>&1; then
cat > /etc/local.d/alpinesubsbx.start <<EOF
#!/bin/bash
sleep 10
busybox-extras httpd -f -p \$(cat $HOME/agsbx/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &
EOF
chmod +x /etc/local.d/alpinesubsbx.start
rc-update add local default >/dev/null 2>&1
else
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i '/websbx/d' /tmp/crontab.tmp
echo '@reboot sleep 10 && /bin/bash -c "busybox httpd -f -p $(cat $HOME/agsbx/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &"' >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
fi
echo "本地IP订阅链接已更新完成"
fi
if [ -n "$hyjpt" ] && [ -n "$hyp" ]; then
echo
if validhyjpt "$hyjpt"; then
echo "设置Hysteria2协议的跳跃端口：$hyjpt"
hy2natclean
hyport=$(cat "$HOME/agsbx/port_hy2")
for port in $hyjpt; do
iptables -t nat -A PREROUTING -p udp --dport "$port" -m comment --comment agsbx-hy2-jump -j DNAT --to-destination :$hyport
ip6tables -t nat -A PREROUTING -p udp --dport "$port" -m comment --comment agsbx-hy2-jump -j DNAT --to-destination :$hyport
done
netfilter-persistent save >/dev/null 2>&1
if command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -q '^Status: active'; then
echo "提示：检测到 ufw 已启用，跳跃端口需要自行放行，例如：ufw allow $hyjpt/udp"
fi
if command -v rc-service >/dev/null 2>&1 && command -v rc-update >/dev/null 2>&1; then
rc-update show default 2>/dev/null | grep -q 'iptables' || rc-update add iptables >/dev/null 2>&1
rc-update show default 2>/dev/null | grep -q 'ip6tables' || rc-update add ip6tables >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
else
echo "提示：hyjpt=\"$hyjpt\" 格式不正确（应为 20000 或 20000:30000 这类写法），已跳过端口跳跃"
fi
fi
cip
echo
else
echo "Argosbx脚本已安装"
echo
argosbxstatus
echo
echo "相关快捷方式如下："
showmode
exit
fi
