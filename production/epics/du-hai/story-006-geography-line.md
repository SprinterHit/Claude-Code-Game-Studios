# Story 006: 登陆时一句地理原因

> **Epic**: 读海
> **Status**: Ready
> **Layer**: Presentation
> **Type**: UI
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 6`

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.7.2 | **Risk**: HIGH
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**:
- Required: N/A (minimal — no control manifest)
- Forbidden: N/A (minimal — no control manifest)
- Guardrail: N/A (minimal — no control manifest)

---

## Acceptance Criteria

*From `design/game-brief.md` (the **Player goal & fail state** field + the MVP feature this story implements), scoped to this story:*

- [ ] 登陆时显示一句文字
- [ ] 这句话说明这片岸为何在这里
- [ ] 显示的是一句，不是长文，也不是书摘列表
- [ ] 这句话对应该趟所揭示的那一片海岸
- [ ] 未登陆时不显示这句原因
- [ ] 被风流带过海岸时不显示这句原因
- [ ] 补给归零仍看不见陆地而失败时不显示这句原因

---

## Implementation Notes

- 一句地理原因来自简介的 MVP 第 6 项。长文和书摘列表在简介的范围外。
- 登陆与失败的判定来自前面的故事。海岸如何被揭示由 Story 005 负责。
- 文字用触摸可完成的界面显示，不依赖悬停。
- 引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 005: 历史海岸本身的揭示
- Story 007: 把出发到结束收成一局
- 长文阅读和书摘列表
- 贸易、港口、舰队、战斗、多人

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: UI
**Required evidence**:
- UI: a retained screenshot of the geography line, in `production/qa/evidence/` — the screenshot is not waived at `qa.level: minimal`

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 005 must be DONE
- Unlocks: Story 007
