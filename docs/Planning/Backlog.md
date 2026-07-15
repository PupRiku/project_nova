# Backlog

Live task list. Once the GitHub repo is up, mirror active items into **GitHub
Issues** (use the issue templates) and let this note track the big-picture
groupings.

> [!tip] Owner agents
> `combat-systems` · `godot-engineer` · `content-narrative` · `qa-test`

## Phase 0 — Foundation
- [x] Repo scaffolding, `.gitignore`, `.gitattributes` (LFS)
- [x] `CLAUDE.md` + four subagents
- [x] CI smoke test — pinned to **godot-ci:4.7**, `checkout@v5`
- [x] Documentation vault
- [x] **Premise + world + story spine** → [[05 - World Bible]]
- [x] **Roster (9)** → [[06 - Characters]]
- [x] **Tarot ledger** → [[07 - Tarot Ledger]]
- [x] **GDD v0.2** → [[01 - Game Design Document]]
- [ ] `git init`, first commit, push to GitHub — **you**
- [ ] Confirm `project.godot` opens + runs clean in Godot 4.7 — **you**

## 🚧 The gate on Phase 1
- [ ] **Author [[02 - Combat Design]]** — the last doc blocking development
  - [ ] **Time-pool economy** — pool size, recharge rule, per-spell costs
    (Rewind / Haste / Slow / Stop share one pool)
  - [ ] **Timing windows in milliseconds** — offensive press, parry, dodge, block
  - [ ] **Damage / healing / crit formulas**
  - [ ] **The 9 action commands as numbers** → [[06 - Characters]]
  - [ ] **Active party size: 3 or 4?** — decide by *feel* in Phase 1; it scales the
        player's parry load
  - [ ] **Overdrive** — fill rule, one per character

## Phase 1 — Combat PoC
- [ ] Turn state machine skeleton — `combat-systems`
- [ ] One offensive action command (timed press) — `combat-systems`
- [ ] One defensive parry window — `combat-systems`
- [ ] Placeholder hero + enemy scene — `godot-engineer`
- [ ] Win/lose resolution — `combat-systems`
- [ ] GUT tests for damage + window timing — `qa-test`
- [ ] **Feel check** — **you**. *This is the exit criterion.*

## Open decisions (not blocking)
- [ ] **Rename Darkrai (temp)** — Pokémon clash
- [ ] Name: **Amos's realm**, **Vale's institution**, **Klaus's professor**
- [ ] **Lyra (temp)** — idol's name; stage name vs. real name
- [ ] Approve/veto the 4 proposed party members → [[06 - Characters]]
- [ ] Pin **the Ban's date**; who does it ban, if the time-folk are gone?
- [ ] Is Vaik **hunting Esmerelda's bloodline** deliberately?
- [ ] Is *"magic, then decline Undo"* a **fifth ending**?
- [ ] **Recruitment order** across 10–14 chapters
- [ ] Cam's **eight reading cards** in Ch. 1 → log in [[07 - Tarot Ledger]]

## Later phases
Expand as each begins. See [[Roadmap]].
