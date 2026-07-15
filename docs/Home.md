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

> [!todo] The gate on Phase 1
> **[[02 - Combat Design]]** is the last doc blocking development. It needs:
> the **time-pool economy** (Rewind/Haste/Slow/Stop share one pool), **timing
> windows in milliseconds**, damage formulas, and the **nine action commands**
> from [[06 - Characters]] turned into numbers.

> [!warning] The docs are ahead of the build
> The World Bible is ~1000 lines and Godot still opens an empty scene. That's fine —
> but [[02 - Combat Design]] is what turns any of this into GDScript.
