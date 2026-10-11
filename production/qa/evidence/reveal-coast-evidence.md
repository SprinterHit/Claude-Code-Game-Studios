# Test Evidence: 登陆揭示历史海岸

> **Story**: `production/epics/du-hai/story-005-reveal-coast.md`
> **Story Type**: Visual/Feel
> **Date**: 2026-10-11
> **Tester**: Solo developer
> **Build / Commit**: Godot 4.7.2

---

## What Was Tested

The one shore of this voyage stays an ink outline until the ship lands. Landing fills that same shore, names it 向风群岛, and does not reveal a second coast. A miss and a supply failure leave the shore unrevealed.

**Acceptance criteria covered**: AC-1, AC-2, AC-3, AC-4, AC-5, AC-6, AC-7

---

## Acceptance Criteria Results

| # | Criterion (from story) | Result | Notes |
|---|----------------------|--------|-------|
| AC-1 | 登陆之前，这一片历史海岸未揭示 | PASS | Approach frame shows the ink outline only |
| AC-2 | 船抵达海岸并登陆后，揭示一片历史海岸 | PASS | Landed frame shows the filled shore |
| AC-3 | 揭示的是这一趟的那一片海岸 | PASS | The fill uses the same outline |
| AC-4 | 被风流带过海岸时，不揭示历史海岸 | PASS | Miss frame keeps the ink outline |
| AC-5 | 补给归零仍看不见陆地而失败时，不揭示历史海岸 | PASS | Supply frame has no revealed shore |
| AC-6 | 揭示发生在登陆时，不发生在出发时 | PASS | Opening frame has no shore fill |
| AC-7 | 这一趟只揭示这一片海岸 | PASS | One coast node, one filled shore |

---

## Screenshots / Video

| # | Filename | What It Shows | Acceptance Criterion |
|---|----------|--------------|----------------------|
| 1 | `reveal-coast/01-revealed-coast.png` | Filled shore, hills, and the name 向风群岛 after landing | AC-2, AC-3, AC-7 |
| 2 | `coast/01-ink-coast.png` | Ink outline before landing | AC-1, AC-6 |
| 3 | `complete-voyage/02-missed.png` | Passed the shore with no fill | AC-4 |
| 4 | `supply/01-supply-failed.png` | Supply failure with no revealed shore | AC-5 |

---

## Test Conditions

- **Game state at start**: one new voyage, ship east of the shore
- **Platform / hardware**: Linux, Godot 4.7.2, 1280×720 window
- **Framerate during test**: movie recorded at 60 FPS
- **Any special setup required**: launch poses `approach`, `landed`, `missed`, and `supply` place the ship for the stills. A separate headless run also sailed onto the shore without a pose.

---

## Observations

- The hills on the revealed shore are flat triangles, in keeping with the chart.
- The moment of landing is a still. How the fill feels in motion was not timed.

---

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Lead (art-director / designer) | Solo developer | 2026-10-11 | [x] Approved |

---

*Template: `.claude/docs/templates/test-evidence.md`*
*Used for: Visual/Feel and UI story type evidence records*
*Location: `production/qa/evidence/[story-slug]-evidence.md`*
