# Project Nova

A 2D, menu-driven turn-based RPG with **action commands** — classic JRPG turn
structure, plus a real-time skill layer: timed presses that boost attacks
(Paper Mario) and parry / dodge / block windows on incoming hits (Clair Obscur:
Expedition 33). Built in **Godot 4.7 / GDScript**, desktop-first.

> Every attack and every defense is a **timed act of reading time itself** — on a
> planet coming apart, where the hero's power to bend time is a gift from the
> goddesses, mistaken by the world for a plague, and killing him either way.

> Turns are discrete. The "action" is timing windows layered on each turn — not an
> ATB gauge.

## Status

**Phase 0 — Foundation.** Scaffolding complete. Premise, world, story spine, roster,
and both endings are drafted. **`02 - Combat Design` is the gate on Phase 1.**

See `docs/Planning/Roadmap.md`.

## Getting started

1. Install [Godot **4.7**](https://godotengine.org/download) — match the version
   pinned in `.github/workflows/ci.yml`.
2. Install [Git LFS](https://git-lfs.com/) once per machine, then `git lfs install`.
3. Clone, then open `project.godot` in Godot.

## Repository layout

```
scenes/        .tscn scenes (battle/, overworld/, ui/)
scripts/       .gd code (combat/, core/, data/, ui/)
resources/     .tres data (enemies/, moves/, items/, characters/)
assets/        art & audio — Git LFS tracked
tests/         GUT tests
tools/         helper scripts
docs/          Obsidian vault — design, technical, art, world, planning
.claude/       Claude Code config + subagents
```

## Documentation

`docs/` is an [Obsidian](https://obsidian.md) vault. Open the folder as a vault, or
read the Markdown directly. **Start at `docs/Home.md`.**

| Doc | Status |
|---|---|
| **01 — Game Design Document** — pillars, core loop, scope guardrails | v0.2 |
| **02 — Combat Design** — timing windows, formulas, the action-command model | ⚠️ outline — *next up* |
| **03 — Technical Design** — architecture, data, save system | outline |
| **04 — Art & Audio Direction** — visual target, sprite specs, card art | outline + constraints |
| **05 — World Bible** — Novum: cosmology, the Ban, the Gift, Vaik, both endings | v0.2 |
| **06 — Characters** — the nine-character roster + combat identities | v0.1 |
| **07 — Tarot Ledger** — 🔒 every card appearance; one is reserved | v0.1 |
| **Roadmap / Backlog** — phased plan and live work | live |

## The demo

**Chapter 1** ships as a public demo during late Alpha / early Beta — the vertical
slice hardened, ending on the reveal of what the game actually is. It's a wishlist
driver, not throwaway content. See GDD §8.

## Working with Claude Code

`CLAUDE.md` holds project conventions and the **canon rules that are easy to break
by accident** — read at the start of every session. Specialist subagents live in
`.claude/agents/` (combat, engine, content, QA).

## Contributing

`main` stays runnable. Branch → PR. Assets go through LFS. Never commit exported
builds. See `.github/pull_request_template.md`.

## License

TBD.
