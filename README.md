## Argosbx一键无交互小钢炮脚本💣：极简 + 轻量 + 快速

---------------------------------------

<img width="757" height="255" alt="d89e2542c513e705106371acc7fa1d33" src="https://github.com/user-attachments/assets/7d7a4678-4223-478c-afe2-d303ba0f85a4" />

---------------------------------------

#### 1、基于Sing-box + Xray + Cloudflared-Argo 三内核自动分配

#### 2、支持主流VPS系统（推荐Ubuntu系统），SSH脚本支持非root环境运行，无脑一次回车搞定

#### 3、支持各种容器系统，Docker镜像部署，公开镜像库：```ygkkk/argosbx```

#### 4、根据Sing-box与Xray不同内核，可选15种WARP出站组合，更换落地IP为WARP的IP，解锁流媒体

#### 5、客户端支持方面，各类单协议分享、clash/mihomo/singbox聚合订阅分享都可支持

#### 6、所有代理协议都无需域名（除了argo固定隧道、IP端口CDN），支持单个或多个代理协议任意组合并快速重置更换
【 已支持：Naiveproxy、Vless-xhttp-tls、AnyTLS、Any-reality、Vless-xhttp-reality-vison-enc、Vless-tcp-reality-vision、Vless-xhttp-vison-enc、Vless-ws-vision-enc、Shadowsocks-2022、Vmess-ws、Socks5、Hysteria2、Tuic、Argo临时/固定隧道支持Vless-ws-vision-enc或Vmess-ws 】

#### 7、建议配合SSH一键脚本命令生成器网页使用：https://yonggekkk.github.io/argosbx/

#### 8、如需要多样的功能，推荐使用VPS专用五合一脚本[Sing-box-yg](https://github.com/yonggekkk/sing-box-yg)

#### 9、Argosbx客户端推荐：

安卓手机客户端：[Nekobox-starifly版(全协议支持)](https://github.com/starifly/NekoBoxForAndroid/releases)、[V2rayNG官方版](https://github.com/2dust/v2rayNG/releases)、[Singbox官方版](https://github.com/SagerNet/sing-box/releases)、Clash/Mihomo客户端随意

电脑win客户端：[V2rayN官方版(全协议支持)](https://github.com/2dust/v2rayN/releases)、[Singbox官方版](https://github.com/SagerNet/sing-box/releases)、Clash/Mihomo客户端随意

苹果IOS客户端：小火箭Shadowrocket、Onexray、Sing-bos MT、Clash mi

注：个别协议仅支持某些客户端

#### 10、网络调优与 Brutal 加速（2026-10 实测数据）

- 安装时自动写入 `/etc/sysctl.d/99-agsbx-net.conf`（rmem/wmem 32MB、BBR+fq、FastOpen、udp 缓冲等），适配 88ms RTT 这类大 BDP 线路；不想改动系统加 `netopt=no`。已装机器可单独跑 `bash argosbx.sh tune` 或 `bash net-tune.sh`，回滚 `bash net-tune.sh undo`。
- Hysteria2 支持 Brutal 拥塞控制：`hypt=端口 hyup=上行Mbps hydw=下行Mbps`，生成的链接与订阅会自带带宽参数（客户端需填相同值才生效）。实测比 BBR 快 **40–80 倍**。
- systemd 单元改为 `network-online.target` + `Restart=always` + `StartLimitBurst=5` + `LimitNOFILE=1048576`，修掉重启后节点偶尔起不来、配置错误时刷爆日志两个老问题。
- 详细对比数据、单流天花板分析与"什么场景选什么协议"见 [docs/PERF-2026-10.md](docs/PERF-2026-10.md)。

#### 11、Hysteria2 salamander 混淆（抗 QUIC 特征识别）

- 裸 QUIC 特征明显，长期使用建议开混淆：`hypt=端口 hyobfs=1`，脚本会随机生成 24 位密码并存在 `~/agsbx/obfs_pw`（也可用 `hyobfspw=自定义密码`）。
- 分享链接、sing-box 出站、mihomo 配置都会自动带上 `obfs=salamander` 与 `obfs-password`；客户端要填同样的密码，否则连不上（实测不带混淆握手 100% 失败）。
- 混淆与 Brutal 可同时使用；同时开时 Hysteria2 会强制由 sing-box 承载（Xray 的 hysteria2 不支持 Brutal 与 obfs，脚本会提示并忽略对应参数）。

#### 12、可靠性 / 安全上的改动（本维护分支）

- 随机端口改用内置 `randport()`：优先取 10000-29999（避开 32768+ 内核临时端口段），并跳过已被占用的端口；不再依赖 `shuf`（Alpine 默认没有，之前会导致端口为空、配置非法）。
- 生成配置后先跑 `xray run -test` / `sing-box check`，不通过自动回滚到上一次可用配置（`*.json.bak`），避免"提示安装成功、实际服务起不来"。
- 跳跃端口 DNAT 规则带 `agsbx-hy2-jump` 注释，只增删自己加的规则，不再 `iptables -t nat -F PREROUTING` 清空整张表（会连 ufw / Docker 的规则一起清掉）；`del` 在 systemd 系统上也会清理。
- `oap=1`（开放所有端口）前会先把现有规则备份到 `~/agsbx/iptables_before_oap.rules`，并明确提示这会清空 ufw / fail2ban / Docker 的规则。
- argo token 从 systemd 单元与 `ps` 命令行移到 `~/agsbx/argo.env`（600）经 `TUNNEL_TOKEN` 传入；`sb.json`、`xr.json`、`private.key`、`uuid` 等含密钥文件统一 600。
- systemd 单元里写的是安装时的 `$HOME` 绝对路径（不再硬编码 `/root`），`sudo -E` 或非 root 家目录安装也能正常拉起服务。
- 进程识别按 `$HOME` 归属判断，多用户机器上不会误杀别的用户实例；`list` 重生成的链接会从配置回读 Brutal / obfs 参数，不再丢参数。
- 参数入口做了校验：非法端口回落随机端口、非 UUID 的 `uuid` 会被忽略、`hyjpt`/`hyup`/`hydw` 格式错误会提示跳过。
- CI 增加 `shell-lint`（`bash -n` + shellcheck 错误级阻断）。


------------------------------------------------------------------

* #### 如下图：一键SSH命令生成器：[点击视频教程](https://youtu.be/4u6W4c-t3oU)

<img width="726" height="741" alt="image" src="https://github.com/user-attachments/assets/622fbc56-1058-45c6-8cac-dc00bb6cf6d0" />

------------------------------------------------------------------

* #### 如下图：从此抛弃第三方独立的WARP脚本，xray+singbox双内核集成15种WARP出站组合：[点击视频教程](https://youtu.be/iywjT8fIka4)

<img width="1015" height="681" alt="e0b66a115b1cd6a5060c38cae6e45c55" src="https://github.com/user-attachments/assets/06e69e8e-f714-4ba5-a519-f09fdecb0bbf" />

----------------------------------------------------------

* #### 如下图：节点IP、端口被封依旧可用！套CDN优选5大方案三步视频教程：
  
[视频1：80系+回源cdn](https://youtu.be/RnUT1CNbCr8)

[视频2：Argo临时/固定隧道区别与设置](https://youtu.be/K35NhrNiLK8)

[视频3：黑科技80端口CDN](https://youtu.be/X8BFVyeiY9g)

<img width="1776" height="960" alt="f51af75fcc76bae7e76fe0ef5b9ecc86" src="https://github.com/user-attachments/assets/028b780d-bd48-4c79-8c60-940b3c3d1937" />

---------------------------------------------------------


#### 相关教程可参考[甬哥博客](https://ygkkk.blogspot.com/2025/08/argosb.html)，视频教程如下：

[Argosbx小钢炮脚本重大更新：加入NaiveProxy与XHTTP-TLS一键部署；XHTTP的UDP模式支持CDN优选IP](https://youtu.be/NMJIG_2N2a8)

[Argosbx一键生成SSH命令；解决IP限制、IP质量太差问题；Argo固定隧道设置要点](https://youtu.be/xHzZFP_ywLs)

[搭建代理9大问题排行榜：第4名全网99%的人被误导！第1名每个人都被折腾到爆！](https://youtu.be/pJwJBqBkcfw)

[2025年度代理协议"拉到夯"综合排名](https://youtu.be/IoFtykGXDao)

[ArgoSBX小钢炮脚本更新说明：新增VLESS ENC抗量子加密；80端口也能开启TLS加密？无需域名也能CDN优选？](https://youtu.be/X8BFVyeiY9g)

[Argo隧道代理节点终极教程：VPS+容器搭建最强CDN节点 | 无视端口IP被封 | Argo临时/固定隧道区别 | CDN优选IP加速](https://youtu.be/K35NhrNiLK8)

[ArgoSBX一键无交互小钢炮脚本💣（四）：一键SSH命令生成器发布，只要点几下，各大代理协议任你选](https://youtu.be/4u6W4c-t3oU)

[ArgoSB一键无交互小钢炮脚本💣（三）：内置15种WARP出站组合，轻松替代独立的WARP脚本](https://youtu.be/iywjT8fIka4)

[ArgoSB一键无交互小钢炮脚本💣（二）：代理节点的IP、端口被封依旧可用！ArgoSB脚本套CDN优选4大方案教程](https://youtu.be/RnUT1CNbCr8)

[ArgoSB一键无交互小钢炮脚本💣（一）：VPS/nat VPS在主协议下的应用；仅按一次回车，多协议自由搭配](https://youtu.be/CiXmttY7mhw)

----------------------------------------------------------

### 交流平台：[甬哥博客地址](https://ygkkk.blogspot.com)、[甬哥YouTube频道](https://www.youtube.com/@ygkkk)、[甬哥TG电报群组](https://t.me/+jZHc6-A-1QQ5ZGVl)、[甬哥TG电报频道](https://t.me/+DkC9ZZUgEFQzMTZl)

----------------------------------------------------------
### 感谢支持！微信打赏甬哥侃侃侃ygkkk
![41440820a366deeb8109db5610313a1](https://github.com/user-attachments/assets/e5b1f2c0-bd2c-4b8f-8cda-034d3c8ef73f)

----------------------------------------------------------
### 感谢你右上角的star🌟
[![Stargazers over time](https://starchart.cc/yonggekkk/ArgoSB.svg)](https://starchart.cc/yonggekkk/ArgoSB)

----------------------------------------------------------
### 声明：所有代码来源于Github社区与ChatGPT的整合
