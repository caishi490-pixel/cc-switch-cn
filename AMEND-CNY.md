# cc-switch 人民币成本显示改造（个人 fork）

本仓库是 farion1231/cc-switch v4.0.8 的个人改造版：**用量统计里的成本显示改为人民币（CNY）**。
数据库仍以 USD 存储，只在界面层按汇率折算。默认汇率 **7.2**。

## 改了什么

- `src/components/usage/format.ts`
  - 新增 `COST_RATE_FROM_USD`（默认 7.2，可用构建变量 `VITE_CC_RMB_RATE` 覆盖）与 `COST_SYMBOL = "¥"`。
  - `fmtUsd()` 内部改为 USD→CNY 折算并输出 `¥`（函数名保留，所有调用点自动生效：总成本卡、
    请求日志成本列、供应商/模型统计、热力图、趋势图、侧栏"今日"花费、会话阅读器头部等）。
- `src/components/usage/RequestDetailPanel.tsx`：请求详情两处手写 `$` 改为折算后的 `¥`。
- `src/components/usage/UsageTrendChart.tsx`：成本模式 Y 轴刻度改为 `¥`。
- `src/components/sessions/reader/toolSummary.ts`：`formatCost()` 改为 `¥`（会话时间线、导出 Markdown 同步生效）。

## 重新编译 / 换汇率

```powershell
cd C:\Users\GxCaishi\dev\cc-switch-rmb
# 可选：换汇率（默认 7.2）
# $env:VITE_CC_RMB_RATE = '7.15'
.\rebuild-rmb.ps1
```

手动流程：`pnpm tauri build --no-bundle`，产物在 `src-tauri\target\release\cc-switch.exe`，
替换 `%LOCALAPPDATA%\Programs\CC Switch\cc-switch.exe` 后重启应用。

## 注意

- 官方原版 exe 备份：`.buildlogs\cc-switch-official-4.0.8-backup.exe`。
- 应用内自动更新会把本改造覆盖回官方版；升级后重跑 `rebuild-rmb.ps1` 即可。
- 「定价」页里输入的单价仍是 USD/百万 token（那是定价输入，不是花费显示）；改动只影响"成本/花费"的显示。
- 供应商余额查询没动（余额本来就按供应商自身币种显示，支持 CNY）。
