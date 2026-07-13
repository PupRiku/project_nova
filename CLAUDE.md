# CLAUDE.md

Project guidance for Claude Code sessions. Read this first, every session.

## What this project is

An indie, **menu-driven turn-based RPG with action commands** — classic JRPG
turn structure, with a real-time skill layer layered on top:

- **Offensive timing** (Paper Mario style): timed button presses boost attacks.
- **Defensive timing** (Clair Obscur: Expedition 33 style): parry / dodge /
  block windows on incoming hits.

Turns are **discrete** (not ATB / not a filling gauge). The "action" is timing
windows attached to each turn. Presentation is **2D**, desktop-first.

## Stack

- **Engine:** Godot 4.x
- **Language:** GDScript (primary). C# only if a specific need justifies it.
- **Dimension:** 2D (sprites; light 2.5D only if a doc calls for it)
- **Targets:** Windows / macOS / Linux via Godot native export
- **Tests:** GUT (Godot Unit Test)

## Where things live

```
scenes/        .tscn scenes        (battle/, overworld/, ui/)
scripts/       .gd code            (combat/, core/, data/, ui/)
resources/     .tres data          (enemies/, moves/, items/, characters/)
assets/        art & audio         (LFS-tracked)
tests/         GUT tests
tools/         helper scripts
docs/          Obsidian vault — GDD, combat, technical, art, world, planning
```

**Design docs are the source of truth.** Before implementing a system, read the
relevant note in `docs/`. If code and a doc disagree, the doc wins — or the doc
is out of date and should be updated in the same change. Never silently diverge.

Key docs: `docs/Home.md` (index) → GDD, Combat Design, Technical Design,
Art & Audio, World Bible, Roadmap, Backlog.

## How we work

- **This repo is developed on the user's machine.** Claude proposes code,
  scene-file text, and resource text; the user runs Godot, tests in-editor, and
  confirms results. Prefer changes Claude can express as text (`.gd`, `.tscn`,
  `.tres`) and give precise editor steps for anything GUI-only.
- **Prove the fun before building content.** Early phases are deliberately ugly.
  Do not add polish, art, or content that a phase's exit criteria don't require.
- **One system at a time.** Land it, test it, commit it, then move on.

## Coding conventions (GDScript)

- `snake_case` for variables, functions, files, and node names.
- `PascalCase` for class names (`class_name`) and for scene root nodes.
- `SCREAMING_SNAKE_CASE` for constants and enum members.
- Prefer **typed GDScript**: `var hp: int = 0`, `func take_damage(amount: int) -> void:`.
- Prefer **signals** over polling for combat/UI events (e.g. `hit_landed`,
  `turn_ended`, `parry_success`). Turn flow is a **state machine**, not nested ifs.
- Game data (enemies, moves, items, party members) is authored as **custom
  `Resource` types** (`.tres`), never hard-coded in scripts. Balancing = editing
  data, not code.
- One class per file. Keep combat math in dedicated, unit-testable functions.
- Comment the *why*, not the *what*. Timing windows and formulas get a comment
  citing the design doc value they implement.

## Git workflow

- `main` is always runnable. Work on short-lived feature branches; merge via PR.
- Conventional-ish commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`,
  `chore:`. Reference issues (`#12`) where relevant.
- Assets are **Git LFS** (see `.gitattributes`). Never commit exported builds.
- Keep commits scoped to one logical change.

## Subagents

Defined in `.claude/agents/`. Delegate to the right specialist:

- **combat-systems** — turn manager, action-command timing, damage/status math.
- **godot-engineer** — scene/node architecture, `.tscn`/`.tres` authoring, saves.
- **content-narrative** — dialogue, quests, writing, World Bible consistency.
- **qa-test** — GUT tests, regressions, edge cases.

## Definition of done (any change)

1. Matches the relevant design doc (or updates it).
2. Follows the conventions above.
3. Has tests if it's logic (combat math, state transitions, save/load).
4. `main` still opens and runs. Docs updated if behavior changed.
