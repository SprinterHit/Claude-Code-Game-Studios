# Godot — Breaking Changes

Last verified: 2026-10-11 for the 4.6 → 4.6.3 span. Spans through 4.5 → 4.6 were last verified 2026-02-12 and were not re-fetched this run.

Changes between Godot versions, focused on post-LLM-cutoff changes (4.4+).

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
