# Story 005: 登陆揭示历史海岸

> **Epic**: 读海
> **Status**: Complete
> **Last Updated**: 2026-10-11
> **Layer**: Feature
> **Type**: Visual/Feel
> **Estimate**: L
> **Manifest Version**: N/A (minimal — no control manifest)

## Context

**GDD**: `design/game-brief.md`
**Requirement**: `Brief MVP feature 5`

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

- [ ] 登陆之前，这一片历史海岸未揭示
- [ ] 船抵达海岸并登陆后，揭示一片历史海岸
- [ ] 揭示的是这一趟的那一片海岸
- [ ] 被风流带过海岸时，不揭示历史海岸
- [ ] 补给归零仍看不见陆地而失败时，不揭示历史海岸
- [ ] 揭示发生在登陆时，不发生在出发时
- [ ] 这一趟只揭示这一片海岸

---

## Implementation Notes

- 揭示的是登陆后才现身的那片历史海岸，对应简介里的「这片陆地按地理显形」。
- 抵达与两种失败的判定来自 Story 003 和 Story 004。本故事只做揭示。
- 地理原因那一句由 Story 006 显示。
- 引擎风险为 HIGH。写 Godot API 前先查 `docs/engine-reference/godot/`。

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:*

- Story 003: 如何判定抵达或被带过
- Story 004: 如何判定补给失败
- Story 006: 一句地理原因
- Story 007: 把出发到结束收成一局
- 第二片大陆；长文阅读和书摘列表

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above*

---

## Test Evidence

*Governed by `qa.level`: at `qa.level: minimal` tests are **waived** (advisory, never "must exist and pass"), but a Visual/Feel or UI story's retained screenshot is not.*

**Story Type**: Visual/Feel
**Required evidence**:
- Visual/Feel: a retained screenshot in `production/qa/evidence/` + sign-off in `production/qa/evidence/reveal-coast-evidence.md` — the screenshot is not waived at `qa.level: minimal`

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 004 must be DONE
- Unlocks: Story 006

---

## Completion Notes
**Completed**: 2026-10-11
**Criteria**: 7/7 passing. The still shows the revealed shore. The timing of the fill itself was not separately played.
**Deviations**: None
**Test Evidence**: `production/qa/evidence/reveal-coast/01-revealed-coast.png` and sign-off in `production/qa/evidence/reveal-coast-evidence.md`.
**Code Review**: Skipped (solo)
