# Story 004: 补给耗尽结束这一趟

> **Epic**: 读海
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 4`

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

- [ ] 这一趟有会减少的补给
- [ ] 航行期间补给减少
- [ ] 补给归零时，如果陆地还看不见，这一趟失败
- [ ] 补给归零导致失败时，这一趟结束
- [ ] 补给尚未归零时，不会因补给而结束这一趟
- [ ] 在补给耗尽前抵达海岸，不算补给失败
- [ ] 补给失败与被风流带过海岸是两种失败；本故事只判定补给失败

---

## Implementation Notes

- 失败用语来自简介：补给归零仍看不见陆地；目标是在补给耗尽前抵达。
- 海岸是否抵达由 Story 003 判定。本故事不实现第二种失败。
- 引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: 触摸改变航向
- Story 002: 风和流推动船
- Story 003: 被风流带过海岸
- Story 005: 登陆后揭示历史海岸
- Story 006: 一句地理原因
- Story 007: 把出发到结束收成一局
- 存档、养成，以及这一趟之外的进度

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/du-hai/supply_test.gd` — waived at `qa.level: minimal` (advisory)

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 003 must be DONE
- Unlocks: Story 005
