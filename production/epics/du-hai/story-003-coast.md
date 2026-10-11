# Story 003: 海岸可抵达也可错过

> **Epic**: 读海
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 3`

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

- [ ] 这一趟有一条海岸
- [ ] 船可以抵达这条海岸
- [ ] 船可以被风和流带过这条海岸而不抵达
- [ ] 被风和流带过海岸时，这一趟失败
- [ ] 尚未抵达、也尚未被带过时，这一趟不算成功，也不算因错过海岸而失败
- [ ] 抵达与被带过是两种不同结果
- [ ] 这一趟只有这一条海岸

---

## Implementation Notes

- 错过来自简介的失败条件：被风流带过海岸。
- 带过海岸所用的风和流来自 Story 002。
- 登陆后的揭示和地理原因不在本故事。引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001: 触摸改变航向
- Story 002: 风和流如何被看见、如何推动船
- Story 004: 补给归零
- Story 005: 登陆后揭示历史海岸
- Story 006: 一句地理原因
- Story 007: 把出发到结束收成一局
- 第二片大陆和更多历史航线

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: Logic
**Required evidence**:
- Logic: `tests/unit/du-hai/coast_test.gd` — waived at `qa.level: minimal` (advisory)

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 002 must be DONE
- Unlocks: Story 004
