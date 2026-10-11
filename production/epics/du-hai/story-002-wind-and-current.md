# Story 002: 风和海流推动船

> **Epic**: 读海
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 2`

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

- [ ] 风在海上看得见，并且用箭头表示
- [ ] 海流在海上看得见，并且用色带表示
- [ ] 风推动船，船的运动偏离仅按航向直线行驶的结果
- [ ] 海流推动船，船的运动偏离仅按航向直线行驶的结果
- [ ] 玩家不改航向时，风和流仍然推动船
- [ ] 玩家改航向之后，风和流仍然推动船
- [ ] 风和流可以彼此区分，不是同一个标记

---

## Implementation Notes

- 箭头表示风，色带表示海流，来自简介的美术方向。
- 风和流必须改变船的运动，不能只是装饰。
- 改航向仍由 Story 001 负责。引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: 船如何航行、触摸如何改变航向
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
- Logic: `tests/unit/du-hai/wind-and-current_test.gd` — waived at `qa.level: minimal` (advisory)

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001 must be DONE
- Unlocks: Story 003
