# TANK DOM定制版RR管理器

TANK DOM定制版RR管理器 是一个为 RR 引导的 DSM 系统重新实现的 DSM WebApp，用来在 DSM 内直接管理 bootloader 配置、addons、modules，并执行 RR 在线或本地升级。


## 注意事项
- RR v25.2.0 及以上才支持 RRM v4.
- TANK DOM定制版RR管理器 会直接修改 bootloader 分区内容。
- 错误配置或错误升级可能导致 DSM 无法正常启动。
- 更新完成后通常需要重启 DSM，新的 bootloader 才会真正生效。

## 发布与自更新

本仓库 fork 自 [RROrg/RRManager](https://github.com/RROrg/RRManager)（GPL-3.0），包名 `tank-dom-rr-manager` 与显示名「TANK DOM定制版RR管理器」均已改为定制版，可与原版并存。

- 最新套件：[Releases](https://github.com/a8711531/TANK-DOM-RRManager/releases/latest)
- 资产名约定：`tank-dom-rr-manager_noarch-dsm7_<tag>.spk`，tag 为纯版本号（如 `4.0-8`）
- 套件的「检查更新」默认读取本仓库 `/releases/latest`，安装即用，无需额外配置
- 如需改到其它发布仓库，在 DSM 上创建 `/var/packages/tank-dom-rr-manager/var/update-source.conf` 并写入 `RRM_RELEASE_REPO_URL="https://github.com/<账号>/<仓库>"`。该文件在升级时保留且优先于默认值。**不要填回上游 `RROrg/RRManager`**，否则会把原版 RR Manager 装上来覆盖定制版
- `.github/workflows/sync-upstream.yml` 每周抓取上游 main 并开草稿 PR，仅用于人工挑选同步，**请勿直接合并**
