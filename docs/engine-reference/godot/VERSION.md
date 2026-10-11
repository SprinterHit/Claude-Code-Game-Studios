# Godot Engine — Version Reference

| Field | Value |
|-------|-------|
| **Engine Version** | Godot 4.6.3 |
| **Installed at pin time** | 4.6.3.stable.official.7d41c59c4 |
| **Release Date** | 20 May 2026 |
| **Project Pinned** | 2026-10-11 |
| **Last Docs Verified** | 2026-10-11 |
| **LLM Knowledge Cutoff** | May 2025 |

## Knowledge Gap Warning

The LLM's training data likely covers Godot up to ~4.3. Versions 4.4, 4.5,
and 4.6 introduced significant changes that the model does NOT know about.
4.6.1, 4.6.2, and 4.6.3 are maintenance releases of 4.6 and are also past
that cutoff. Always cross-reference this directory before suggesting Godot API calls.

## Installed-Version Gap Warning

The warning above is one-directional — it covers the **model** knowing less than
this pin. The reverse gap is real and `/setup-engine` §3 creates it deliberately
("pin the newer one and upgrade later"): this reference can sit **ahead of the
installed editor**, and an agent citing it correctly then emits APIs that do not
compile locally. **Check `Installed at pin time` above before trusting a
version-qualified claim** — `NOT DETERMINED` means the gap is unknown, not absent.

This pin was probed on 2026-10-11. `godot --version` printed
`4.6.3.stable.official.7d41c59c4`, the same release as **Engine Version**.
The 4.6.3 maintenance article says that release was built from commit
`35e80b3a8`. The article's commit id and the binary's version hash are
different identifiers; this file does not treat them as the same string.

## Post-Cutoff Version Timeline

| Version | Release | Risk Level | Key Theme |
|---------|---------|------------|-----------|
| 4.4 | ~Mid 2025 | MEDIUM | Jolt physics option, FileAccess return types, shader texture type changes |
| 4.5 | ~Late 2025 | HIGH | Accessibility (AccessKit), variadic args, @abstract, shader baker, SMAA |
| 4.6 | Jan 2026 | HIGH | Jolt default, glow rework, D3D12 default on Windows, IK restored |
| 4.6.1 | 16 February 2026 | HIGH | Maintenance. No known incompatibilities with 4.6. |
| 4.6.2 | 1 April 2026 | HIGH | Maintenance. No known incompatibilities with 4.6.1. Built from `001aa128b`. |
| 4.6.3 | 20 May 2026 | HIGH | Maintenance. No known incompatibilities with 4.6.2. Built from `35e80b3a8`. |

## Verified Sources

- Official docs: https://docs.godotengine.org/en/stable/
- 4.5→4.6 migration: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html
- 4.4→4.5 migration: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.5.html
- Changelog: https://github.com/godotengine/godot/blob/master/CHANGELOG.md
- Release notes: https://godotengine.org/releases/4.6/
- 4.6.1 maintenance (fetched 2026-10-11): https://godotengine.org/article/maintenance-release-godot-4-6-1/
- 4.6.2 maintenance (fetched 2026-10-11): https://godotengine.org/article/maintenance-release-godot-4-6-2/
- 4.6.3 maintenance (fetched 2026-10-11): https://godotengine.org/article/maintenance-release-godot-4-6-3/
- 4.6 → 4.6.3 migration page: NOT SOURCEABLE. `https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.3.html` returned 404 on 2026-10-11. The migration page that exists is 4.5 → 4.6.
