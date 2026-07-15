# CLAUDE.md

Project guidance for Claude Code sessions. **Read this first, every session.**

## What this project is

**Project Nova** — an indie, **menu-driven turn-based RPG with action commands**.
Classic JRPG turn structure with a real-time skill layer on top:

- **Offensive timing** (Paper Mario style): timed presses boost attacks.
- **Defensive timing** (Clair Obscur: Expedition 33 style): parry / dodge / block
  windows on incoming hits.

Turns are **discrete** (not ATB / not a filling gauge). Presentation is **2D**,
desktop-first. Setting: the planet **Novum**.

**Pitch:** every attack and every defense is a *timed act of reading time itself* —
on a planet coming apart, where the hero's power to bend time is a gift from the
goddesses, mistaken by the world for a plague, and killing him either way.

## Stack

- **Engine:** Godot **4.7**
- **Language:** GDScript (primary). C# only if a specific need justifies it.
- **Dimension:** 2D
- **Targets:** Windows / macOS / Linux via Godot native export
- **Tests:** GUT (Godot Unit Test)
- **CI:** `barichello/godot-ci:4.7` — keep pinned to the local Godot version.

## Where things live

```
scenes/        .tscn scenes        (battle/, overworld/, ui/)
scripts/       .gd code            (combat/, core/, data/, ui/)
resources/     .tres data          (enemies/, moves/, items/, characters/)
assets/        art & audio         (LFS-tracked)
tests/         GUT tests
tools/         helper scripts
docs/          Obsidian vault — design, technical, art, world, planning
```

**Design docs are the source of truth.** Before implementing a system, read the
relevant note in `docs/`. If code and a doc disagree, the doc wins — or the doc is
out of date and should be updated in the same change. Never silently diverge.

**Vault index → `docs/Home.md`**

| Doc | Status | What it's for |
|---|---|---|
| `01 - Game Design Document` | **v0.2** | pillars, core loop, systems, **scope guardrails** |
| `02 - Combat Design` | ⚠️ **outline only** | **the gate on Phase 1.** Timing values, time-pool economy, 9 action commands |
| `03 - Technical Design` | ⚠️ outline | architecture, data, save system |
| `04 - Art & Audio Direction` | outline + hard constraints | visual target, sprite specs, **card art** |
| `05 - World Bible` | **v0.2, extensive** | canon: cosmology, the Ban, the Gift, Vaik, both endings |
| `06 - Characters` | v0.1 | the 9-character roster + combat identities |
| `07 - Tarot Ledger` | v0.1 | 🔒 **every card appearance. Read before using any card.** |
| `Roadmap` / `Backlog` | live | phases with exit criteria; current work |

## 🔒 Canon rules that are easy to break by accident

Read these before writing content. Each protects a payoff that is *hours* away
from where you'd be working.

1. **Whisper's Star appears exactly once**, at the endgame. Never in Cam's
   readings, never in her Ch. 1 spread. → `07 - Tarot Ledger`
2. **Timeline A has no Kym in it.** No shrines, no name, no foreshadowing anywhere
   in the game. Kym exists only after the Undo. → `05 - World Bible`
3. **Cam's condition is NOT Temporal Sickness**, and Cam + Klaus know it almost
   immediately. The mystery is *"what is this?"*, never *"is he infected?"*
4. **The green thread:** green = time magic. Temporal Sickness irises, Vaik's
   cloak, Cam's flash. Keep it deliberate.
5. **The motif:** *comfort from someone you will never recognize.* Kate prays to
   Cam. Echo is healed by a friend he never met. Whisper is answered by her
   great-grandmother's face. Content that contradicts this should probably lose.
6. **No playable tome fusion.** It's dark magic and plot. (Locked in GDD §7.)

## How we work

- **This repo is developed on the user's machine.** Claude proposes code, scene
  text, and resource text; the user runs Godot, tests in-editor, and confirms.
  Prefer changes expressible as text (`.gd`, `.tscn`, `.tres`); give precise editor
  steps for anything GUI-only.
- **Prove the fun before building content.** Early phases are deliberately ugly. Do
  not add polish, art, or content a phase's exit criteria don't require.
- **One system at a time.** Land it, test it, commit it, move on.
- **Guard scope.** The GDD's §7 guardrail list is the most valuable thing in it.
  Two have already been removed deliberately (multiple endings, crafting). A third
  removal should trigger a hard look at §6's 20–30 hour target.

## Coding conventions (GDScript)

- `snake_case` for variables, functions, files, node names.
- `PascalCase` for `class_name` and scene root nodes.
- `SCREAMING_SNAKE_CASE` for constants and enum members.
- Prefer **typed GDScript**: `var hp: int = 0`, `func take_damage(amount: int) -> void:`
- Prefer **signals** over polling for combat/UI events. Turn flow is a **state
  machine**, not nested ifs.
- Game data (enemies, moves, items, party) is authored as custom **`Resource`
  types** (`.tres`) — never hard-coded. Balancing = editing data, not code.
- Timing logic must be **frame-rate independent** (seconds / `delta`, never raw
  frame counts) so feel is stable across machines.
- One class per file. Keep combat math in dedicated, unit-testable functions.
- Comment the *why*. Timing windows and formulas cite the design-doc value they
  implement.

## Git workflow

- `main` is always runnable. Short-lived feature branches; merge via PR.
- Conventional-ish commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`,
  `chore:`. Reference issues (`#12`) where relevant.
- Assets are **Git LFS** (see `.gitattributes`). Never commit exported builds.

## Subagents

Defined in `.claude/agents/`:

- **combat-systems** — turn manager, action-command timing, damage/status math.
- **godot-engineer** — scene/node architecture, `.tscn`/`.tres`, saves.
- **content-narrative** — dialogue, quests, writing, canon consistency.
- **qa-test** — GUT tests, regressions, edge cases.

## Definition of done (any change)

1. Matches the relevant design doc (or updates it).
2. Follows the conventions above.
3. Has tests if it's logic (combat math, state transitions, save/load).
4. `main` still opens and runs. Docs updated if behavior changed.
