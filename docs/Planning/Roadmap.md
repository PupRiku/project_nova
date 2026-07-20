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

## Phase 2 — Combat prototype
Split into two sub-phases so the **structure** (party, queue, targeting, menu) is
proven and stable *before* the **systems** (Spring, Overdrive, statuses) build on
top of it. Land 2A completely, then 2B — don't interleave.

### Phase 2A — Party, queue, targeting & menu 🎯 *current* — **no new systems**
The battle *skeleton* scaled up from Phase 1's 1v1, with **zero** new mechanics:
- **Real party** — multiple heroes fielded together (3 or 4 active — decide by feel).
- **Visible turn-order queue** — the FFX-style portrait queue (Combat Design §1). A
  hard dependency, not polish: Cam's Haste/Slow/Stop in 2B are *edits to a sequence
  the player must see*, so the queue ships here first.
- **N-combatant targeting** — pick a target among many; parry load scales with active
  party size (§3.3 "who parries?"). The offensive press and defensive parry from
  Phase 1 carry over unchanged.
- **Full battle menu** — Attack / Magic / Skills / Item / Defend wired up (§2), even
  where sub-lists are near-empty. **Defend** lands here (guaranteed mitigation, §2.1).
- Combat authored as `.tres` data, not hard-code.

**Explicitly NOT in 2A:** the Temporal Spring, time magic, Overdrive, MP, status
effects. Those are 2B. 2A only proves multi-combatant flow reads clearly.
**Exit:** a full multi-enemy, multi-hero battle is playable and readable start to
finish — turn order visible, targeting clear, every menu entry reachable.

### Phase 2B — The systems layer
The mechanics that make combat *Nova's*, built on 2A's stable skeleton:
- **MP** and the **Magic** menu populated (§8).
- **Cam's Temporal Spring** — levels 1→6 as pips, and the time spells **Haste / Slow
  / Stop / Rewind** as *edits to the visible queue* from 2A (§4). Rewind as a
  meta-action (§4.2).
- **Overdrive** — universal gauge, three fill sources, the first Charger (§5), and
  its inverse-correlation with the Spring (§6).
- **Status effects** — the §9 table: name · effect · duration · stacking · chance.
- Several more **action-command variants** from the §3.0 vocabulary, spread across
  the roster so no input type is mandatory (P5).

**Exit:** a fight exercising time magic + Overdrive + statuses is playable and
readable, and the Spring/Overdrive economy *feels* right (a tuning gate, like Phase 1).

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
