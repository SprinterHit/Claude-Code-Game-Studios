# Story 001: 触摸改变航向

> **Epic**: 读海
> **Status**: Complete
> **Last Updated**: 2026-10-11
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 1`

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

- [ ] 这一趟开始时，场上有一艘玩家的船
- [ ] 船沿当前航向航行
- [ ] 一次触摸指定一个新航向
- [ ] 船的航向改为该次触摸所指定的航向
- [ ] 航行中可以再次触摸，并再次改变航向
- [ ] 没有新的触摸时，船保持上一次所定的航向
- [ ] 改变航向用触摸完成，不依赖悬停

---

## Implementation Notes

- 本故事只做一艘船的航行和触摸改航向。
- 风、流、海岸、补给、揭示和地理原因分别由后续故事实现。
- 引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 002: 看得见、并且会推动船的风和海流
- Story 003: 海岸的抵达与错过
- Story 004: 补给耗尽
- Story 005: 登陆后揭示历史海岸
- Story 006: 一句地理原因
- Story 007: 把出发到结束收成一局

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/du-hai/touch-heading_test.gd` — waived at `qa.level: minimal` (advisory)

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: None
- Unlocks: Story 002

---

## Completion Notes
**Completed**: 2026-10-11
**Criteria**: 7/7 passing
**Deviations**: Sail speed 120 is the export default in `src/voyage/ship.gd` and the value on `src/voyage/ship.tscn`.
**Test Evidence**: Waived at `qa.level: minimal`. A headless behavior run on Godot 4.7.2 printed `STORY001_PASS`. Retained frame: `production/qa/evidence/touch-heading/01-ship-sailing.png`.
**Code Review**: Skipped (solo)
