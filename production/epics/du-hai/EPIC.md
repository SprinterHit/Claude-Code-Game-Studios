# Epic: 读海

> **Slug**: du-hai
> **Status**: Ready
> **Source**: `design/game-brief.md`
> **Layer**: Core

## Goal

你驾着一艘船，读着海面上的风向和海流修正航向，在补给耗尽前登上那片因此才现身的新海岸。

## Scope

1. 一艘船，用触摸改变航向
2. 看得见、并且会推动船的风和海流
3. 一条能够抵达、也能够错过的海岸
4. 补给耗尽就结束这一趟
5. 登陆后揭示一片历史海岸
6. 登陆时给出一句地理原因，说明这片岸为何在这里
7. 从出发到登陆或失败的完整一局

## Ordering

1. 船能航行，手指能改变航向
2. 风和流看得见，并真正推动船
3. 海岸能抵达，也能错过
4. 补给计时，耗尽即失败
5. 登陆揭示这一片海岸，并给出一句地理原因
6. 收成从出发到登陆或失败的一局

## Stories

| # | Story | Type | Status | ADR |
|---|-------|------|--------|-----|
| 001 | 触摸改变航向 | Logic | Ready | N/A (minimal — no ADRs) |
| 002 | 风和海流推动船 | Logic | Ready | N/A (minimal — no ADRs) |
| 003 | 海岸可抵达也可错过 | Logic | Ready | N/A (minimal — no ADRs) |
| 004 | 补给耗尽结束这一趟 | Logic | Ready | N/A (minimal — no ADRs) |
| 005 | 登陆揭示历史海岸 | Visual/Feel | Ready | N/A (minimal — no ADRs) |
| 006 | 登陆时一句地理原因 | UI | Ready | N/A (minimal — no ADRs) |
| 007 | 从出发到结束的完整一局 | Integration | Ready | N/A (minimal — no ADRs) |
