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
> Structure was already decided; Phase 1 confirmed the timing _feel_. Economy numbers
> (Spring / Overdrive / MP) remain tuning targets for later phases.

> [!success] **Phase 2A ✅ done** _(2026-07-20, PR #4)_
> Phase 1's 1v1 scaled into a readable multi-hero / multi-enemy fight: fielded party,
> visible turn-order queue, N-combatant targeting, full battle menu incl. Defend — no
> new systems. Turn-advance & Defend-clear logic extracted to pure, tested functions.
> **Active party size: provisional 4** (pencil — re-feel in 2B; see [[Roadmap]]).

> [!todo] Next — **Phase 2B: the systems layer**
> The mechanics that make combat _Nova's_, on 2A's skeleton: **MP** + the Magic menu;
> **Cam's Temporal Spring** (pips 1→6) with **Haste / Slow / Stop / Rewind** as edits
> to 2A's visible queue; **Overdrive** + its first Charger and the inverse-correlation
> with the Spring; **status effects**; and more **§3.0 action-command variants** spread
> so no input type is mandatory. See [[Roadmap]] and [[02 - Combat Design]] §4–6.
> **Exit:** a fight with time magic + Overdrive + statuses is playable and readable,
> and the Spring/Overdrive economy _feels_ right (a tuning gate, like Phase 1).
