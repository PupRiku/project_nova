# Roadmap

Phased delivery plan. **Exit criteria, not dates** — an indie schedule pinned to
dates mostly generates guilt. You don't advance a phase until its exit criterion
is met. The early phases deliberately throw away polish to answer one question
first: *does the combat feel good?*

> [!note] Discipline level
> Full alpha → beta discipline, with a **public Demo** cut during late Alpha /
> early Beta (see milestone below).

---

## Phase 0 — Foundation ✅ done
Repo, Godot project skeleton, `.gitignore` + Git LFS, `CLAUDE.md`, subagents,
CI smoke test, and this documentation vault.
**Exit:** project opens, runs an empty scene, and pushes clean to GitHub. ✅

## Phase 1 — Combat PoC / vertical slice ✅ done *(make-or-break — gate passed 2026-07-20)*
One hero, one enemy, one attack with an offensive timed press, one incoming
attack with a defensive parry window. Placeholder art. Nothing else.
**Exit:** you can win or lose one fight, **and the timing windows feel good.** ✅
> Gate passed: the timing felt good in play. Validated PoC values folded into
> [[02 - Combat Design]] §3.1–3.2, §7. Pure timing/damage logic + turn FSM + GUT
> behaviour tests landed (PR #1). Everything downstream can now assume the core
> loop is fun.

## Phase 2 — Combat prototype 🎯 *current*
Real party, turn order, multiple move types, status effects, a resource system,
several action-command variants, victory/defeat flow. Combat authored as `.tres`
data, not hard-code.
**Exit:** a full multi-enemy battle is playable and readable start to finish.

## Phase 3 — Exploration & shell prototype
Overworld movement, encounter triggers, the menu system (party, inventory,
equipment), and **save/load** (load-bearing — done early).
**Exit:** walk around → trigger a fight → win → save → quit → reload cleanly.

## Phase 4 — Playable vertical slice
One *complete* small area, start to finish, with real (if minimal) story, art,
and audio. First "show someone" build; first real premise test.
**Exit:** a stranger plays 15–30 min unaided and understands the game.

## Phase 5 — Alpha
All systems final. Content roughed in end-to-end. Placeholder→final art swap
underway. A [[Backlog]]-driven content grind.
**Exit:** game is completable start to finish, however rough.

> [!star] 🎬 Demo milestone — late Alpha / early Beta
> **Cut the public demo here.** The demo is *not* separate throwaway content —
> it's the Phase 4 vertical slice (or the game's opening), hardened and polished
> for public play. Its job is **wishlists** (e.g. Steam Next Fest).
> - Build it once systems are locked (else you polish on shifting ground).
> - Build it before content is complete (else you miss the wishlist-accrual window).
> - **Exit:** a self-contained, bug-free 20–40 min slice with a clear "wishlist /
>   full game coming" call to action, plus its own store page groundwork.

## Phase 6 — Beta
Content complete. Balancing, polish, juice, bug-fixing, structured playtesting.
The [[balance-data]] concerns dominate here.
**Exit:** no blocking bugs; balance feels intentional; playtesters finish it.

## Phase 7 — Ship
Export builds per platform, store setup, launch, day-one patch plan.
**Exit:** it's out.

---

## Documentation sequencing
- **Now:** [[01 - Game Design Document]] → [[02 - Combat Design]] →
  [[03 - Technical Design]] (these three unblock development).
- **Parallel with Phase 1–2:** [[04 - Art & Audio Direction]], [[05 - World Bible]].
- **Living throughout:** [[Backlog]].

## Optional: time estimates
Exit criteria are the honest unit of progress. If you want rough per-phase time
estimates too, we can add them once Phase 1 is concretely scoped — estimating
before the core-loop spike is mostly fiction.
