# Godot — Deprecated APIs

Last verified: 2026-10-11 for the 4.6 → 4.7.2 notes. Tables through the Patterns section were last verified 2026-02-12 and were not re-fetched this run.

If an agent suggests any API in the "Deprecated" column, it MUST be replaced
with the "Use Instead" column.

## Nodes & Classes

| Deprecated | Use Instead | Since | Notes |
|------------|-------------|-------|-------|
| `TileMap` | `TileMapLayer` | 4.3 | One node per layer instead of multi-layer node |
| `VisibilityNotifier2D` | `VisibleOnScreenNotifier2D` | 4.0 | Renamed for clarity |
| `VisibilityNotifier3D` | `VisibleOnScreenNotifier3D` | 4.0 | Renamed for clarity |
| `YSort` | `Node2D.y_sort_enabled` | 4.0 | Property on Node2D, not a separate node |
| `Navigation2D` / `Navigation3D` | `NavigationServer2D` / `NavigationServer3D` | 4.0 | Server-based API |
| `EditorSceneFormatImporterFBX` | `EditorSceneFormatImporterFBX2GLTF` | 4.3 | Renamed |

## Methods & Properties

| Deprecated | Use Instead | Since | Notes |
|------------|-------------|-------|-------|
| `yield()` | `await signal` | 4.0 | GDScript 2.0 coroutine syntax |
| `connect("signal", obj, "method")` | `signal.connect(callable)` | 4.0 | Callable-based connections |
| `instance()` | `instantiate()` | 4.0 | Renamed |
| `PackedScene.instance()` | `PackedScene.instantiate()` | 4.0 | Renamed |
| `get_world()` | `get_world_3d()` | 4.0 | Explicit 2D/3D split |
| `OS.get_ticks_msec()` | `Time.get_ticks_msec()` | 4.0 | Time singleton preferred |
| `duplicate()` for nested resources | `duplicate_deep()` | 4.5 | Explicit deep copy control |
| `Skeleton3D` signal `bone_pose_updated` | `skeleton_updated` | 4.3 | Renamed |
| `AnimationPlayer.method_call_mode` | `AnimationMixer.callback_mode_method` | 4.3 | Moved to base class |
| `AnimationPlayer.playback_active` | `AnimationMixer.active` | 4.3 | Moved to base class |

## Patterns (Not Just APIs)

| Deprecated Pattern | Use Instead | Why |
|--------------------|-------------|-----|
| String-based `connect()` | Typed signal connections | Type-safe, refactor-friendly |
| `$NodePath` in `_process()` | `@onready var` cached reference | Performance: path lookup every frame |
| Untyped `Array` / `Dictionary` | `Array[Type]`, typed variables | GDScript compiler optimizations |
| `Texture2D` in `Shader.set_default_texture_parameter()` / `get_default_texture_parameter()` | `Texture` base type | Changed in 4.4; the shading language's `sampler2D` / `texture()` did not change |
| Manual post-process viewport chains | `Compositor` + `CompositorEffect` | Structured post-processing (4.3+) |
| GodotPhysics3D for new projects | Jolt Physics 3D | Default since 4.6; better stability |

## 4.6 → 4.7

From https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html (fetched 2026-10-11).

| Deprecated | Use Instead | Since | Notes |
|------------|-------------|-------|-------|
| `RichTextLabel.ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` | `ImageUpdateMask.UPDATE_WIDTH_UNIT` | 4.7 | GDScript-incompatible rename. GH-112617 |
| `RichTextLabel.add_image` / `update_image` parameters `width_in_percent`, `height_in_percent` | `width_unit`, `height_unit` (`RichTextLabel.ImageUnit`) | 4.7 | Width and height also change from `int` to `float`. GH-112617 |
| `AudioEffectSpectrumAnalyzer.tap_back_pos` | NOT SOURCEABLE — removed, and the migration page states no replacement | 4.7 | GH-114355 |
| `ImageTexture.get_format` / `PortableCompressedTexture2D.get_format` | `Texture2D.get_format` | 4.7 | Moved to the base class. GH-109004 |
| `EditorSceneFormatImporter.IMPORT_*` constants | `EditorSceneFormatImporter.ImportFlags` | 4.7 | GH-115788 |

## 4.7 → 4.7.2

NOT SOURCEABLE — a deprecated-API list for 4.7.1 and 4.7.2, not stated at:

- https://godotengine.org/article/maintenance-release-godot-4-7-1/
- https://godotengine.org/article/maintenance-release-godot-4-7-2/

Each post says there are no known incompatibilities with the previous patch. That sentence is not a deprecation table.

## 4.6 → 4.6.3

NOT SOURCEABLE — a deprecated-API list for 4.6.1, 4.6.2, and 4.6.3, not stated at:

- https://godotengine.org/article/maintenance-release-godot-4-6-1/
- https://godotengine.org/article/maintenance-release-godot-4-6-2/
- https://godotengine.org/article/maintenance-release-godot-4-6-3/

Each post says there are no known incompatibilities with the previous patch. That sentence is not a deprecation table. The migration page that exists, https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.html, covers 4.5 → 4.6. `https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.3.html` returned 404 on 2026-10-11.
