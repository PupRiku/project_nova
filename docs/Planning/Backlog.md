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
- [x] **[[02 - Combat Design]] v0.1** — menu, turn order, Temporal Spring, Overdrive
- [ ] **Resolve §6 — the Overdrive/Spring fill collision** ⚠️ *biggest open item*
- [ ] **Resolve §8 — does Magic cost MP?** (13 bars is not a HUD)
- [ ] **Rewind: turn action or meta-action?** (§4.2 — recommend meta)
- [ ] **Where do Summons live in the menu?** (§2)
- [ ] **Is Dodge distinct from Parry?** (§3.2)
- [ ] **Numbers** — windows in ms, damage formulas, Spring costs, fill rates.
      *Tuning targets; found by feel in Phase 1.*
- [ ] **Turn-order queue UI** — Phase 1 dependency, not polish (§1)

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
