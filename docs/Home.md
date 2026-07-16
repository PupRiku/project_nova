# 🏠 Project Nova — Design Vault

The single source of truth for the game. Code follows these docs; when they
disagree, the doc wins (or gets updated in the same change).

> [!info] How to use this vault
> Open the `docs/` folder as an [Obsidian](https://obsidian.md) vault, or read
> the Markdown directly. Notes link to each other with `[[wikilinks]]`.

## 📐 Design
- [[01 - Game Design Document]] — pillars, core loop, systems, scope
- [[02 - Combat Design]] — the action-command model, timing windows, formulas
- [[03 - Technical Design]] — architecture, data, save system
- [[04 - Art & Audio Direction]] — visual target, sprite specs, pipeline

## 🌍 World
- [[05 - World Bible]] — **Novum**: cosmology, the Ban, Temporal Sickness, the Gift, the ending
- [[06 - Characters]] — the nine-character roster, with combat identities
- [[07 - Tarot Ledger]] — 🔒 every card appearance, and the one that's reserved

## 🗺️ Planning
- [[Roadmap]] — phased delivery plan with exit criteria + demo milestone
- [[Backlog]] — live task list (mirror into GitHub Issues once the repo is up)

## 🧩 Templates
Reusable note structures for content authoring:
- [[Character]] · [[Enemy]] · [[Move]] · [[Area]]

---

## Status

**Phase 0 — Foundation.** Repo scaffolded (Godot **4.7**). **Premise, world, story
spine, roster, and both endings are drafted.**

> [!success] **[[02 - Combat Design]] v0.2 — no structural questions remain.**
> Everything is decided, or is a **number Phase 1 will find by feel.**
> **The docs no longer gate development.**

> [!todo] Next — **Phase 1**
> One hero, one enemy, one timed press, one parry window. Ugly placeholder art.
> **Exit criterion: the timing windows feel good.**
>
> Two things Phase 1 must include that aren't obvious:
> - **The turn-order queue** — Haste/Slow/Stop are edits to a sequence the player has
>   to *see*. Not polish; a dependency.
> - **Audio cues on the windows** — players parry by sound as much as sight (P5).
