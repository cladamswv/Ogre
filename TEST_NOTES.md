# Ogre War release-candidate test notes

## Preparation audit

The final GitHub release candidate was assembled from the 0.7.1 Codespaces fresh install, the Android-build update, and the Castlehold-derived Phase 1–7 rebuild. The preparation environment ran the following successfully:

- current release source contract;
- Phase 1–7 shell contracts;
- Phase 1–7 Python validators;
- release asset integrity audit across the complete repository;
- GLTF/BIN external-buffer validation;
- OBJ face/index validation;
- PNG/SVG/WAV/OGG container checks;
- zero-byte and case-collision scan;
- duplicate `class_name` scan;
- mixed-indentation scan;
- shell syntax validation;
- Python compilation validation.

The release audit also replaced obsolete smoke tests from the old procedural-art build. Those tests incorrectly required `MarchUnitArt` as the active renderer, disabled directional shadows, WAV-only age music and removed fields such as `body_material`/`weapon_joint`. The release candidate tests now target the current Castlehold-derived architecture.

## Audio checks

The startup audio audit expects:

- 3 music roles;
- 23 registered battle/stinger effects;
- 3 human defeat clips;
- 3 orc defeat clips;
- 3 ogre defeat clips;
- Music, Combat and Voice buses.

The manual pause-menu AUDIO CHECK cycles all of them with category-aware timing so longer stingers do not overlap the next check.

## Phase 10 verification

The preparation workspace installed the official Godot 4.7.2 Linux editor and passed the complete `verify_codespaces.sh` gate: source contracts, all Phase 1–10 validators, the release asset audit, Godot import/parse, and home/records, intro first-launch/skip/replay, age, art, audio, visual-stability and complete scene-flow smoke tests. The 24-second supplied cinematic was transcoded to Theora/Vorbis and inspected with `ffprobe`.

For the Android debug export in Codespaces, run:

```bash
bash tools/codespaces_setup.sh
bash tools/codespaces_android_setup.sh
bash tools/verify_codespaces.sh
bash tools/build_android_debug.sh
```

`verify_codespaces.sh` performs the same headless tests before APK export.

## Phase 10.1 debugging and fresh-install audit

The clean Phase 10 source was imported again with Godot 4.7.2. The complete
`verify_codespaces.sh` gate passed source and asset checks, Godot import/parse,
and all eight runtime smoke tests. The verifier isolates `user://` test data,
so its first-launch test does not change the developer's story or records.
A new regression test reproduces touch
emulation sending mouse and touch motion in the same swipe. The game now moves
the camera once per swipe and ignores camera input after a match finishes or
while paused. Audio nodes stop and release their streams and owned mixer
configuration when a battle ends; smoke tests wait for decoder shutdown.
Two development-only capture probes with a hard-coded local path were removed.
The export script verifies its prerequisites, clears a stale APK before
building, and reuses one local debug keystore across builds in a Codespace.

The preparation environment has JDK 17 and Godot 4.7.2, but it does not have
Android SDK build tools. No APK was exported here. Run the Android export gate
in Codespaces or GitHub Actions to produce `build/Ogre-War-debug.apk`.

## Phase 9 hero-art pass

The preparation environment passed the complete source/static/asset suite through Phase 9, including 12 hero-fortress overlays, 8 battlefield-depth props, 10 hero-equipment meshes and 9 recruit portrait SVGs. Phase 10 also passes Godot 4.7.2 import and runtime smoke checks locally; Android export remains enforced by `tools/build_android_debug.sh` and GitHub Actions.
