# Godot — Breaking Changes

Last verified: 2026-10-11 for the 4.6 → 4.7.2 spans. Spans through 4.5 → 4.6 were last verified 2026-02-12 and were not re-fetched this run.

Changes between Godot versions, focused on post-LLM-cutoff changes (4.4+).

## 4.7 → 4.7.2 (14 Jul 2026 – 18 Aug 2026 — POST-CUTOFF, HIGH RISK)

Maintenance releases. Each official post says there are no known incompatibilities with the previous patch, and that a project should be backed up or kept in version control before upgrading.

| Span | Official statement | Source |
|------|--------------------|--------|
| 4.7 → 4.7.1 | "As of now, there are no known incompatibilities with the previous Godot 4.7 release." Built from commit `a13da4feb`. | https://godotengine.org/article/maintenance-release-godot-4-7-1/ |
| 4.7.1 → 4.7.2 | "As of now, there are no known incompatibilities with the previous Godot 4.7.1 release." Built from commit `ed1daf0bf`. | https://godotengine.org/article/maintenance-release-godot-4-7-2/ |

Fixes in those posts that matter to a touch, mobile, or 2D project. The posts do not label them as incompatibilities.

| Release | Subsystem | Change | Details |
|---------|-----------|--------|---------|
| 4.7.1 | GUI | Popup menus no longer open the virtual keyboard automatically | GH-120768 |
| 4.7.1 | GUI | Scene tree drag-and-drop on touchscreens | GH-120456 |
| 4.7.1 | Input | Android soft keyboard backspace can delete existing text | GH-119798 |
| 4.7.2 | GUI | `BaseButton` input when `enable_long_press_as_right_click` is true | GH-120962 |

## 4.6 → 4.7 (18 Jun 2026 — POST-CUTOFF, HIGH RISK)

The migration page says migration from 4.6 is relatively safe for most games, and lists the breaks below. Source: https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html (fetched 2026-10-11). 4.7's release date is 18 June 2026: https://godotengine.org/download/archive/4.7-stable/

### Behavior changes

| Subsystem | Change | Details |
|-----------|--------|---------|
| Rendering | `LinearToSRGB` visual shader no longer clamps to `[0.0, 1.0]` | Mobile and Forward+ only (GH-113956). Compatibility is not named. |
| Rendering | `CanvasItem` line drawing skips the antialiasing feather | Lines look thinner. Projects that relied on the feather need a larger width (GH-105122). |
| Audio | `AudioStreamPlayer.area_mask` default changed from `1` to `0` | `Area2D` / `Area3D` `audio_bus_override` that used the default layer-1 mask must set the mask back to layer 1 (GH-107679). |
| Physics | Jolt `WorldBoundaryShape3D.plane.d` sign is reversed versus 4.6 | 3D Jolt only (GH-118948). This project uses Godot Physics 2D. |
| Physics | Jolt `SoftBody3D` default mass is 1 kg for the whole body | Was 0, which calculated 1 kg per point (GH-116041). 3D Jolt. |
| Physics | Jolt `SoftBody3D.linear_stiffness` matches Godot Physics more closely | Retune `linear_stiffness` and `damping_coefficient` (GH-116041). 3D Jolt. |
| Physics | Jolt `Area3D` reports overlaps with `SoftBody3D` | Filter them with collision layers and masks (GH-114198). 3D Jolt. |
| Input | Mouse and keyboard device IDs are no longer `0` | Use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD`. A joypad may use `0` (GH-116274). |
| GDScript | Writing one element of a packed array does not call the setter for the whole property | GH-113228 |
| GDScript | An override inherits the parent method's typed return | The override needs an explicit return. `return null` satisfies the error (GH-115763). |

### Signature changes that are not source-compatible

Optional parameters marked GDScript-compatible on the same page are not repeated here. The page is the full list.

| API | Change | Compatibility |
|-----|--------|----------------|
| `OptimizedTranslation.generate` | Return type `void` to `bool` | GDScript compatible. C# binary incompatible, source compatible. GH-119563 |
| `Control.accessibility_live` | Type moves from `DisplayServer.AccessibilityLiveMode` to `AccessibilityServer.AccessibilityLiveMode` | GDScript compatible. C# binary and source incompatible. GH-116839 |
| `RichTextLabel.ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` | Renamed to `UPDATE_WIDTH_UNIT` | GDScript incompatible. C# source incompatible. GH-112617 |
| `RichTextLabel.add_image` / `update_image` | `width` and `height` change from `int` to `float`. `width_in_percent` / `height_in_percent` rename to `width_unit` / `height_unit` and change from `bool` to `RichTextLabel.ImageUnit` | Width and height are GDScript compatible. The renamed unit parameters are C# source incompatible. GH-112617 |
| `RenderingServer.particles_request_process_time` | `time` renamed to `process_time`, plus optional `process_time_residual` | C# source incompatible. GH-109142 |
| `Animation.length` | Metadata `float` to `double` | GDScript compatible. C# binary and source incompatible. GH-116394 |
| `PhysicsServer2DExtension._body_set_shape_as_one_way_collision` | New `direction` parameter | GDScript, C# binary, and C# source incompatible. GH-104736 |
| `AudioEffectSpectrumAnalyzer.tap_back_pos` | Removed | GDScript, C# binary, and C# source incompatible. GH-114355. No replacement is stated. |
| `OpenXRExtensionWrapper._on_register_metadata` | New `interaction_profile_metadata` parameter | GDScript, C# binary, and C# source incompatible. GH-117399 |
| `EditorVCSInterface._commit` | New `amend` parameter | GDScript, C# binary, and C# source incompatible. GH-117968 |
| `EditorSceneFormatImporter.IMPORT_*` | Constants moved onto the `ImportFlags` enum | GDScript compatible. C# source incompatible. GH-115788 |
| `ImageTexture.get_format` / `PortableCompressedTexture2D.get_format` | Moved to `Texture2D` | GDScript and C# compatible. GH-109004 |

### Changed defaults

| Property | Old | New |
|----------|-----|-----|
| New project `display/window/stretch/mode` | `disabled` | `canvas_items` |
| New project `display/window/stretch/aspect` | `keep` | `expand` |
| `LookAtModifier3D.relative` | `true` | `false` |
| `rendering/reflections/sky_reflections/roughness_layers` | `7` | `8` |
| `ResourceImporterDynamicFont.hinting` | `1` | `3` |
| `RichTextLabel.add_image` / `update_image` percent parameters | `false` | `0` |

## 4.6 → 4.6.3 (16 Feb 2026 – 20 May 2026 — POST-CUTOFF, HIGH RISK)

Maintenance releases. Each official post says there are no known incompatibilities with the previous patch, and that a project should be backed up or kept in version control before upgrading.

| Span | Official statement | Source |
|------|--------------------|--------|
| 4.6 → 4.6.1 | "As of now, there are no known incompatibilities with the previous Godot 4.6 release." | https://godotengine.org/article/maintenance-release-godot-4-6-1/ |
| 4.6.1 → 4.6.2 | "As of now, there are no known incompatibilities with the previous Godot 4.6.1 release." Built from commit `001aa128b`. | https://godotengine.org/article/maintenance-release-godot-4-6-2/ |
| 4.6.2 → 4.6.3 | "As of now, there are no known incompatibilities with the previous Godot 4.6.2 release." Built from commit `35e80b3a8`. | https://godotengine.org/article/maintenance-release-godot-4-6-3/ |

NOT SOURCEABLE — a dedicated 4.6 → 4.6.3 migration guide. `https://docs.godotengine.org/en/4.6/tutorials/migrating/upgrading_to_godot_4.6.3.html` returned 404 on 2026-10-11.

The posts also list fixes that can change observed behavior. They do not label those fixes as incompatibilities. "No known incompatibilities" is the posts' claim; it is not an inventory of the interactive changelogs, which were not fetched.

| Release | Subsystem | Change | Details |
|---------|-----------|--------|---------|
| 4.6.1 | C# | Revert of `CSharpLanguage::reload_assemblies` performance change | GH-115759 |
| 4.6.1 | Particles | Revert of the curve range for particle multipliers | GH-116140 |
| 4.6.1 | Physics | `SoftBody3D` may have `total_mass` of 0 again | GH-116111 |
| 4.6.1 | Physics | Jolt transform updates were sometimes discarded | GH-115364. 3D Jolt. This project uses Godot Physics 2D. |
| 4.6.1 | Rendering | Volumetric fog early-out uses transmittance instead of opacity | GH-116107 |
| 4.6.1 | Editor binaries | First macOS 4.6.1 binaries before 2026-02-16 22:30 UTC lacked entitlements and broke .NET and GDExtension; they were reuploaded | Editor download, not a project API change |
| 4.6.2 | Physics | Jolt `MoveKinematic`, gravity on dynamic bodies, inside-out triangles | GH-115327, GH-115305, GH-115089. 3D Jolt. |
| 4.6.3 | Rendering | Project setting added to disable new volumetric fog blending | GH-119414. Setting path NOT SOURCEABLE — the article does not name it. |
| 4.6.3 | Rendering | LightmapGI probe update speed applies in Compatibility | GH-117771 |
| 4.6.3 | Rendering | GLES3 batching no longer skips every item on specific buffer sizes | GH-117725 |
| 4.6.3 | C# | SourceGenerators no longer become a transitive dependency | GH-114868 |
| 4.6.3 | Input | Android back navigation when targeting API level 36 | GH-117653 |
| 4.6.3 | Buildsystem | Annual Android versions bump for 2026 | GH-113761. Target SDK integer NOT SOURCEABLE — the article does not state it. |

## 4.5 → 4.6 (Jan 2026 — POST-CUTOFF, HIGH RISK)

| Subsystem | Change | Details |
|-----------|--------|---------|
| Physics | Jolt is now the DEFAULT 3D physics engine | New projects use Jolt automatically. Existing projects keep their setting. Some HingeJoint3D properties (like `damp`) only work with GodotPhysics. |
| Rendering | Glow processes BEFORE tonemapping | Was after tonemapping. Scenes with glow will look different. Adjust intensity/blend in WorldEnvironment. |
| Rendering | D3D12 default on Windows | Was Vulkan. For better driver compatibility. |
| Rendering | AgX tonemapper new controls | White point and contrast parameters added. |
| Core | Quaternion initializes to identity | Was zero. Unlikely to affect most code but technically breaking. |
| UI | Dual-focus system | Mouse/touch focus now separate from keyboard/gamepad focus. Visual feedback differs by input method. |
| Animation | IK system fully restored | CCDIK, FABRIK, Jacobian IK, Spline IK, TwoBoneIK via SkeletonModifier3D nodes. |
| Editor | New "Modern" theme default | Grayscale replaces blue-tint. Restore: Editor Settings → Interface → Theme → Style: Classic |
| Editor | "Select Mode" keybind changed | New "Select Mode" (v key) prevents accidental transforms. Old mode renamed "Transform Mode" (q key). |
| 2D | TileMapLayer scene tile rotation | Scene tiles can now be rotated like atlas tiles. |
| Localization | CSV plural form support | No longer requires Gettext for plurals. Context columns added. |
| C# | Automatic string extraction | Translation strings auto-extracted from C# code. |
| Plugins | New EditorDock class | Specialized container for plugin docks with layout control. |

## 4.4 → 4.5 (Late 2025 — POST-CUTOFF, HIGH RISK)

| Subsystem | Change | Details |
|-----------|--------|---------|
| GDScript | Variadic arguments added | Functions can accept `...` arbitrary params — new language feature |
| GDScript | `@abstract` decorator | Abstract classes and methods now enforceable |
| GDScript | Script backtracing | Detailed call stacks available even in Release builds |
| Rendering | Stencil buffer support | New capability for advanced visual effects |
| Rendering | SMAA 1x antialiasing | New post-processing AA option |
| Rendering | Shader Baker | Pre-compiles shaders — reportedly 20x faster startup on some demos |
| Rendering | Bent normal maps, specular occlusion | New material features |
| Accessibility | Screen reader support | Control nodes work with accessibility tools via AccessKit |
| Editor | Live translation preview | Test GUI layouts in different languages in-editor |
| Physics | 3D interpolation rearchitected | Moved from RenderingServer to SceneTree. API unchanged but internals differ. |
| Animation | BoneConstraint3D | New: AimModifier3D, CopyTransformModifier3D, ConvertTransformModifier3D |
| Resources | `duplicate_deep()` added | New explicit method for deep duplication of nested resources |
| Navigation | Dedicated 2D navigation server | No longer a proxy to 3D navigation; smaller export for 2D games |
| UI | FoldableContainer node | New accordion-style container for collapsible UI sections |
| UI | Recursive Control behavior | Disable mouse/focus interactions across entire node hierarchies |
| Platform | visionOS export support | New platform target |
| Platform | SDL3 gamepad driver | Delegated gamepad handling to SDL library |
| Platform | Android 16KB page support | Required for Google Play targeting Android 15+ |

## 4.3 → 4.4 (Mid 2025 — NEAR CUTOFF, VERIFY)

| Subsystem | Change | Details |
|-----------|--------|---------|
| Core | `FileAccess.store_*` return `bool` | Was `void`. Methods: `store_8`, `store_16`, `store_32`, `store_64`, `store_buffer`, `store_csv_line`, `store_double`, `store_float`, `store_half`, `store_line`, `store_pascal_string`, `store_real`, `store_string`, `store_var` |
| Core | `OS.execute_with_pipe` | Added optional `blocking` parameter |
| Core | `RegEx.compile/create_from_string` | Added optional `show_error` parameter |
| Rendering | `RenderingDevice.draw_list_begin` | Many parameters removed; `breadcrumb` parameter added |
| Rendering | `Shader.set_default_texture_parameter()` / `get_default_texture_parameter()` | Parameter/return type changed from `Texture2D` to `Texture`; the shading language did not change |
| Particles | `.restart()` method | Added optional `keep_seed` parameter (CPU/GPU 2D/3D) |
| GUI | `RichTextLabel.push_meta` | Added optional `tooltip` parameter |
| GUI | `GraphEdit.connect_node` | Added optional `keep_alive` parameter |

## 4.2 → 4.3 (In Training Data — LOW RISK)

| Subsystem | Change | Details |
|-----------|--------|---------|
| Animation | `Skeleton3D.add_bone` returns `int32` | Was `void` |
| Animation | `bone_pose_updated` signal | Replaced by `skeleton_updated` |
| TileMap | `TileMapLayer` replaces `TileMap` | One node per layer instead of multi-layer single node |
| Navigation | `NavigationRegion2D` | Removed `avoidance_layers`, `constrain_avoidance` properties |
| Editor | `EditorSceneFormatImporterFBX` | Renamed to `EditorSceneFormatImporterFBX2GLTF` |
| Animation | AnimationMixer base class | AnimationPlayer and AnimationTree now extend AnimationMixer |
