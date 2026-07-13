# Indie RPG (working title)

A 2D, menu-driven turn-based RPG with **action commands** — classic JRPG turn
structure, plus a real-time skill layer: timed presses that boost attacks
(Paper Mario) and parry / dodge / block windows on incoming hits (Clair Obscur:
Expedition 33). Built in **Godot 4 / GDScript**, desktop-first.

> Turns are discrete. The "action" is timing windows layered on each turn — not
> an ATB gauge.

## Status

Phase 0 — foundation. See `docs/Planning/Roadmap.md`.

## Getting started

1. Install [Godot 4.x](https://godotengine.org/download) (matching the version
   pinned in `.github/workflows/ci.yml`).
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
docs/          Obsidian vault: design, technical, art, world, planning
.claude/       Claude Code config + subagents
```

## Documentation

The `docs/` folder is an [Obsidian](https://obsidian.md) vault. Open the folder
as a vault, or just read the Markdown directly. Start at `docs/Home.md`.

- **Game Design Document** — pillars, core loop, scope
- **Combat Design** — timing windows, formulas, the action-command model
- **Technical Design** — architecture, data, save system
- **Art & Audio Direction** — visual target, sprite specs, pipeline
- **World Bible** — premise, characters, lore
- **Roadmap / Backlog** — phased plan and live work

## Working with Claude Code

`CLAUDE.md` holds project conventions and is read at the start of every session.
Specialist subagents live in `.claude/agents/` (combat, engine, content, QA).

## Contributing

`main` stays runnable. Branch → PR. Assets go through LFS. Never commit exported
builds. See `.github/pull_request_template.md`.

## License

TBD.
