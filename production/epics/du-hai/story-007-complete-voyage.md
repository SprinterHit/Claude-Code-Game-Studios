# Story 007: 从出发到结束的完整一局

> **Epic**: 读海
> **Status**: Ready
> **Layer**: Feature
> **Type**: Integration
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 7`

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

- [ ] 一局从出发开始
- [ ] 一局在登陆时结束，或在失败时结束
- [ ] 登陆结束与失败结束可以区分
- [ ] 被风流带过海岸时，这一局以失败结束
- [ ] 补给归零仍看不见陆地时，这一局以失败结束
- [ ] 这一局里有船、触摸改航向、看得见的风和流、一条海岸，以及会耗尽的补给
- [ ] 登陆结束时，这一片历史海岸已经揭示，并显示了一句地理原因
- [ ] 这一局结束后不进入第二片大陆，也不开始下一条航线

---

## Implementation Notes

- 本故事把前面六项收成从出发到登陆或失败的一局，不重写各项自己的规则。
- 范围外保持为简介所写：没有第二片大陆、贸易、港口、舰队、战斗、多人、存档和养成。
- 引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 001 至 Story 006: 航向、风流、海岸、补给、揭示、地理原因各自的规则
- 第二片大陆和更多历史航线
- 存档、养成，以及这一趟之外的进度

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: Integration
**Required evidence**:
- Integration: `tests/integration/du-hai/complete-voyage_test.gd` OR a playtest doc — waived at `qa.level: minimal` (advisory)

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 006 must be DONE
- Unlocks: None
