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

**Phase 1 — Combat PoC ✅ done (make-or-break gate passed, 2026-07-20).** The core
loop is proven: one hero vs one enemy, timed offensive press + defensive parry,
audio cues, debug overlay, win/lose. **The timing feels good.** Validated values
folded into [[02 - Combat Design]] §3.1–3.2, §7. Foundation (Phase 0) and premise,
world, roster, and both endings are all in place.

> [!success] **[[02 - Combat Design]] v0.2 — core press/parry timing validated.**
> Structure was already decided; Phase 1 confirmed the timing *feel*. Economy numbers
> (Spring / Overdrive / MP) remain tuning targets for later phases.

> [!todo] Next — **Phase 2A: party, queue, targeting & menu** *(no new systems)*
> Scale Phase 1's 1v1 into a real multi-hero / multi-enemy battle: a fielded party,
> the **visible turn-order queue**, N-combatant targeting, and the full battle menu
> (incl. Defend). **No** Spring / time magic / Overdrive / MP / statuses yet — those
> are **2B**, built on 2A's proven skeleton. See [[Roadmap]] for the full split.
> **Exit:** a multi-enemy, multi-hero battle is playable and readable start to finish.
>
> One thing it must include that isn't obvious:
> - **The turn-order queue** — Haste/Slow/Stop (2B) are edits to a sequence the player
>   has to *see*. It ships in 2A first, or the whole time-magic school is illegible.
