# 03 — Technical Design

> [!abstract] Status: **outline — to be authored together**
> Architecture and conventions. Owned mostly by [[godot-engineer]].

## 1. Project structure
Mirrors the repo: `scenes/ scripts/ resources/ assets/ tests/`. See `CLAUDE.md`.

## 2. Scene architecture
- Battle scene composition — `TODO`
- Overworld scene composition — `TODO`
- UI as composed sub-scenes — `TODO`

## 3. Turn manager
State machine design, signals emitted, who listens. `TODO`
Implements the structure in [[02 - Combat Design]] §1.

## 4. Data as resources
Custom `Resource` types authored as `.tres`. Define fields for each: `TODO`
- `MoveData` — name, power, timing-window, effects, cost …
- `EnemyData` — stats, moves, AI profile, sprite …
- `ItemData` — …
- `CharacterData` — …

## 5. Autoloads / singletons
- GameState — `TODO`
- Party — `TODO`
- SaveManager — `TODO`
- AudioManager — `TODO`

## 6. Save / load
Format, location (`user://`), versioning strategy, what's serialized. `TODO`
Implemented early — it's load-bearing.

## 7. Input
Input map actions, action-command input capture, remapping plan. `TODO`

## 8. Testing
GUT layout under `tests/`, what must be covered, CI hookup. See `.github/workflows/ci.yml`.

## 9. Build & export
Export presets per platform, versioning, release process. `TODO`
