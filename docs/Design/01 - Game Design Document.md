# 01 — Game Design Document

> [!abstract] Status: **draft v0.1** — for creator review
> The anchor doc. Defines *what* we're making and **guards scope**. Combat detail
> lives in [[02 - Combat Design]]; architecture in [[03 - Technical Design]];
> canon in [[05 - World Bible]].

---

## 1. One-line pitch

**Project Nova** is a 2D turn-based RPG where every attack and every defense is a
**timed act of reading time itself** — set on a planet slowly coming apart, where
the hero's power to bend time is a gift from the goddesses, mistaken by the world
for a plague, and quietly killing him either way.

## 2. Design pillars

Five load-bearing principles. **Every feature must serve a pillar. If it serves
none, it is cut.** These are the tiebreakers for every argument downstream.

### P1 — Time is the mechanic *and* the meaning
The parry is *reading time*. The rewind is *bending it*. The anomalies are *time
broken*. The disease is *time in the body*. No system is allowed to be
thematically inert — if a mechanic has nothing to say about time, question it.

### P2 — Every turn is played, not chosen
The menu is the **decision**; the timing window is the **execution**. Offense has a
press; defense has a window. **If a player can win by mashing confirm, we have
failed.** — *that sentence is the pillar's teeth; the rest is commentary.*

> [!note] Refined — **the reliability principle**
> v0.1 read *"there is no such thing as a passive turn."* **Overstated.** Healing and
> self-use items correctly have **no** action command: they cost a consumable, cost a
> turn, and don't advance the win, so they never threaten the mashing-confirm test.
> Healing is the **panic button** — a minigame on it punishes a player for being in
> trouble.
>
> Together with **Defend** (guaranteed mitigation, no parry), this forms a rule:
> **offense demands skill; survival does not.** → [[02 - Combat Design]] §2.1

### P3 — Power is liability
Cam's gift is illegal, feared, marked in the color of a plague — and **it is
killing him**. The liability is not disease; it is **lifespan**. **Using time
magic must always cost something**, at every scale: a shared resource pool
turn-to-turn, and Cam's life across the campaign. Any version of Cam's power that
feels free is wrong — mechanically and thematically. This pillar culminates in
the endgame choice (§5.10).

### P4 — Warmth worth losing
The stakes are people, not prophecy. Kate's kitchen, Klaus's clinic, Gammy's
fruit stall. The world must feel lived-in and domestic *before* it feels epic, or
its destruction is just spectacle.

### P5 — Readable, not reflexive
Telegraphs are fair and legible. Mastery comes from **knowledge** (learning a
tell) not **twitch** (frame-perfect reflex). This is a JRPG, not a fighting game
— generous windows, clear cues, and accessibility options are pillar-level, not
polish.

## 3. Core loop

**Moment-to-moment:** read the telegraph → choose from the menu → execute the
timing window → read the counter-telegraph → parry/dodge → repeat.

**Session:** explore an area → encounter → **action-command combat** → reward
(items, story, tome fragments) → progress → next area.

**Campaign:** chapter → new party member and/or new tome → new mechanical layer →
deeper into the temporal mystery → Dragon's Spine.

## 4. Player fantasy & tone

You are the person who sees the beat before it lands. The fantasy is **fluency in
time** — the escalation from flinching at the déjà vu (Ch. 1 market) to
commanding the rewind (Ch. 1 boss). Tone is **industrial/magitech fantasy** in
the FF6/FF7/FFXII lineage: crystal-comms and airships, warm and lived-in, with a
slow apocalypse underneath. See [[05 - World Bible]].

---

## 5. Systems overview

### 5.1 Combat — *the core*
Menu-driven, discrete turns, with **offensive timed presses** (Paper Mario
lineage) and **defensive parry/dodge/block windows** (Expedition 33 lineage).
Full spec → [[02 - Combat Design]].

### 5.2 Time Magic — *Cam's signature school* `DECIDED`
Cam's gift is a **school of time magic**, not a single trick. All of it draws from
**one shared resource: the Temporal Spring** (levels 1→6, growing across the
campaign). → [[02 - Combat Design]] §4

- **Rewind** — a **limited, rechargeable** in-battle rewind. Model reference:
  **Divine Pulse** (*Fire Emblem: Three Houses*) — a finite pool of charges that
  undoes recent events. *(Resonance worth keeping: Divine Pulse is granted by
  **Sothis**, a goddess of time. Cam's rewind sits in **Ai**'s domain.)*
- **Learned over the campaign:** **Haste**, **Slow**, **Stop**, and further
  spells — all drawing from the **same pool** as Rewind.

> [!success] Why the shared pool solves the central design risk
> The danger with a rewind mechanic is that **if the player can undo mistakes,
> mistakes stop mattering** — combat degrades into save-scumming and the timing
> windows (P2) lose their teeth.
>
> A shared pool fixes this with **opportunity cost** rather than an arbitrary cap:
> **every rewind is a Haste you didn't cast.** Your safety net *is* your offense.
> That's a live, recurring decision the player actually feels — not a limiter
> bolted on from outside.

`TODO:` → [[02 - Combat Design]]: pool size and recharge rule (per-battle?
per-rest? story-gated?), per-spell costs, whether Rewind's cost scales with how
far back it reaches, and what exactly a Rewind undoes (last action / last turn /
last round).

`TODO:` This makes Cam a **melee + time-mage** hybrid rather than a pure sword
user. Confirm when defining combat identities.

### 5.3 Overdrive (temp) — universal limit gauge `RESOLVED`
**Fills from damage dealt / taken / healing**, plus an **Overdrive Charger** — a
player-chosen bonus source, set in the party menu, unlocked via progression.
→ [[02 - Combat Design]] §5

> [!success] Overdrive and the **Temporal Spring** are **inversely correlated**
> Overdrive = *what the fight did to you* (damage). The Spring = *what you did to the
> fight* (action commands). Parry everything → Spring full, Overdrive crawls. Whiff
> everything → Overdrive charged, Spring dry.
>
> **A difficulty valve with no difficulty menu.** → [[02 - Combat Design]] §6

FFX-lineage special-attack gauge; introduced at the Ch. 1 boss.
**Universal** — every party member has one. Because Cam's rewind now lives in the
time-magic school with its own pool (§5.2), Overdrive is **freed** to be the
party-wide limit-break it wants to be. Cam's Overdrive is a *separate* signature
attack, not the rewind.
`TODO:` name (temp: "Overdrive"), fill rule, and one Overdrive per character.

### 5.4 The Eight Tomes — summons `DECIDED`
- **Eight guardian summons**, collected across the campaign. One per tome.
- **Cast from a sub-menu under Magic**, appearing once available.
  → [[02 - Combat Design]] §2
- **No player-facing fusion.** Fusion is **dark magic** — the act that summoned
  Gio and split the planet. It exists in the world as *forbidden knowledge and
  plot*, not as a player system.
- **Narrative leverage:** an antagonist who begins fusing tomes is walking the
  road back to Gio — the endgame threat needs no additional invention.
- `TODO:` summon cost/economy, whether they're per-character or party-wide.

### 5.5 Party & characters `UPDATED`
**8–9 playable characters**, each with a distinct combat identity and
action-command flavor. **Active party of 3–4**, freely swappable (FF6/FF7
lineage). Cam is **melee + time-mage** (§5.2) and presumably always active.

> [!warning] Active party size is a **combat feel** decision, not just a number
> In a defensive-timing game, **active party size directly scales the player's
> parry load** — with 4 characters, more incoming attacks must be read and
> answered per round than with 3. This affects pacing, screen layout, and
> cognitive load. **Decide in Phase 1 by feel**, not on paper. → [[02 - Combat Design]]

> [!success] Roster **filled: 9** — full profiles in [[06 - Characters]]
> | Character | Role | Timing identity |
> |---|---|---|
> | **Cam** | Balanced Fighter (sword + time magic) | combo sequence |
> | **Klaus** | Healer / Support | triage hold-release |
> | **Kate** | "Cook" — Control / Support | recipe sequence |
> | **Amos** | Paladin / Tank | **Intercept — parry *for* an ally** |
> | **Lyra (temp)** | Dancer — Ranged DPS / Support | throw + catch (two windows) |
> | **Vesper (temp)** | Elemental Mage | charge & release; overcharge backfires |
> | **Echo (temp)** | Non-elemental Mage | hold the loop |
> | **Magpie (temp)** | Rogue / Thief | flurry + steal window |
> | **Vale (temp)** | Gunslinger | **active reload** |
>
> **Whisper is NOT a party member** — confidant only (§ [[05 - World Bible]]).
> Four characters are `PROPOSAL` and open to veto → [[06 - Characters]].

> [!important] Amos solves tanking
> In a turn-based game with defensive windows and no aggro, "tank" is decorative
> unless he can **take the hit for someone else**. **Intercept** — parrying on an
> ally's behalf — makes the defensive layer a **team** mechanic and creates a live
> "who do I save" decision each round. This is a P2 payoff.

**Firearms/ammo `RESOLVED`:** **Vale (temp)** is the gunslinger. Ammo is a real
resource for her alone, and **active reload** (perfect-reload-or-jam) is her
signature window — the party's highest risk/reward.

### 5.6 Progression
> [!note] Partial answer available: the **Overdrive Charger** (→ [[02 - Combat Design]]
> §5.2) gives the **eight non-Cam characters** a progression hook that isn't rising
> numbers. *What my Overdrive feeds on* is more interesting to level into than *+3
> STR*. This may be a real chunk of this section.

`TODO:` Levels + stat growth, or milestone/story-gated growth? Decide against P1:
whatever we choose should let the player feel *time fluency* increasing, not just
numbers rising.

**Cam's time-pool is the spine of progression.** Pool size and spell list grow
across the campaign (Divine Pulse grows its charges the same way) — so the number
that measures Cam's power *is* the number that measures their fluency with time.
Pillar P1, expressed as a stat. Tomes and party members are the other campaign-level
progression beats.

### 5.7 Exploration
Chapter/area-based. **Not open world.** Towns, fields, dungeons; encounters
triggered in-world (Ch. 1 pattern). **Temporal anomaly zones** are the signature
environmental hazard/puzzle — a P1 obligation, not a nice-to-have.

### 5.8 Inventory, equipment, economy — **+ Crafting** `SCOPE CHANGE — see §7`
Standard JRPG. `TODO:` scope of equipment depth.

**Cook `RESOLVED` — and it is a real system.** Kate's archetype is confirmed as
Control/Support with buffs, debuffs, and light healing, **and she unlocks crafting
of consumables outside battle.** The v0.1 flag ("a whole system hiding in a
character description") was correct: **crafting is now in scope.**
`TODO:` minimal viable crafting — ingredient sources, recipe count, whether
ingredients come from encounters/gathering/shops. **Keep it small.** This exists to
serve Kate's identity, not to become a second game.

### 5.9 Save / load
See [[03 - Technical Design]]. Built early (Phase 3) — it's load-bearing.

### 5.10 The Undo & the ending matrix `SCOPE CHANGE — see §7`
> [!warning] Spoilers. Full canon in [[05 - World Bible]] § Cam's Gift.

The campaign's central mechanical-narrative fusion. Cam's gift is **killing
him**; at the climactic final battle the player chooses — **through play, not a
dialogue box**:

- **Path A — Restraint.** Win using **no time magic**. Significantly harder.
- **Path B — Undo.** Using time magic during the fight unlocks **Undo** — an
  ultimate skill that erases an event or person from history. **It costs Cam
  their life.**

Crossed with **whether all 8 tomes were collected**, this yields a **2×2 ending
matrix**, with the full-tome paths leading to a **"True" final boss**.

> [!success] Why this is the best design in the project
> The player spends 20–30 hours using time magic because it is powerful and fun.
> That habit **silently accrues toward Cam's death.** The sacrifice isn't chosen
> in a menu — it's chosen by how you played. And Path A makes *restraint*
> mechanically harder, so **difficulty becomes moral weight.** This is P1 and P3
> paying off simultaneously.

> [!danger] Design hole — must be solved
> If time magic makes the final fight *easier* and Undo is optional once
> unlocked, **"use magic, decline Undo" strictly dominates restraint** — easier
> fight *and* Cam lives. Nobody would choose Path A. Path B needs teeth
> (escalating in-fight cost, an unwinnable-without-Undo threshold, etc.).

`TODO:` define all four matrix cells; what Undo erases; whether both full-tome
paths reach the True boss.

---

## 6. Content scope

> [!danger] Honest scope warning — read this before agreeing to it
> Target is **~20–30 hours (classic JRPG)**. Be clear-eyed: this is a **large**
> target. For reference, *Chrono Trigger* (~20h) and *Sea of Stars* (~25–30h)
> were made by full studios over multi-year timelines. 20–30 hours of RPG content
> is the single biggest risk to this project ever shipping.
>
> This is not an argument against it — it's the number this doc exists to defend.
> Two mitigations are already in place: **Ch. 1 ships as a public demo** (real
> value early), and **tome fusion was cut to plot** (the largest scope save).
> If timelines strain, the honest lever is **fewer, denser chapters** — not a
> thinner core loop.
>
> **Scope moved *up* since v0.1:** party 6 → **8–9** (character count is the most
> expensive multiplier in an RPG — each needs a full sprite set, unique action
> commands, an arc, and banter), plus **4 endings and a True boss** (§5.10).
> Both are legitimate genre-normal choices — FF6 shipped 14 characters — but they
> are **additive**, and this doc's job is to say so out loud.

Draft counts — **react to these, they're proposals:**

| Content | Target | Notes |
|---|---|---|
| Playable characters | **8–9** | 5 known; **4–5 to invent**. Active party 3–4 |
| Chapters | **10–14** | Ch. 1 = the demo |
| Distinct areas | **15–20** | towns, fields, dungeons |
| Enemy base types | **~45** | + palette/stat variants; tarot-derived taxonomy |
| Bosses | **12–15** | major arcana lineage |
| Summons | **8** | one per tome |
| Party moves | **~64–72** | ~8 per character |
| Cam's time spells | **~5–7** | Rewind, Haste, Slow, Stop, + |
| Endings | **4** | 2×2 matrix + True boss |
| Playtime | **20–30 h** | main path |

## 7. Scope guardrails — explicitly **NOT** doing

The most valuable list in this document. Adding to it is *progress*.

- ❌ **No ATB / real-time combat.** Turns are discrete.
- ❌ **No 3D.** 2D only.
- ❌ **No playable tome fusion.** It is dark magic and plot. *(Locked.)*
- ❌ **No open world.** Chapter/area-based.
- ❌ **No multiplayer.** Single-player only.
- ❌ **No procedural/generated content.** Hand-authored.
- ❌ **No full voice acting.** Cost sink. Barks/stingers at most, late.
- ⚠️ ~~No crafting system~~ — **removed.** Kate's Cook archetype demands one
  (§5.8). Scoped **minimal**: consumables only.
- ❌ **No romance system.**
- ❌ **No frame-perfect execution requirements.** (Pillar P5.)

> [!note] Guardrails removed — deliberately. **Two so far.**
> 1. `❌ No branching narrative / multiple endings` → **overridden** by the endgame
>    matrix (§5.10).
> 2. `❌ No crafting system` → **overridden** by Kate's Cook archetype (§5.8).
>
> Recorded rather than deleted silently. This is the list working as intended:
> both scope increases were **noticed, costed, and chosen** — not absorbed by
> accident. **Two removals in one revision is worth watching.** A third should
> prompt a hard look at §6.

## 8. The Demo

**Chapter 1** ("The Day Before" + "The Festival"), hardened and polished. It ends
on the green flash and the rewind — the player learns what the game *is*, then
hits the wishlist. See [[Roadmap]] → Demo milestone (late Alpha / early Beta).

> [!question] Demo length — `TODO`
> Ch. 1 as written likely runs **45–75 min**; the Roadmap targets **20–40**.
> Either compress the market/forest stretch for the demo cut, or consciously ship
> a longer demo. Decide at the milestone, not now.

## 9. References & touchstones

Precisely what we take from each — not general vibes.

### The origin
> [!important] **Undertale / Deltarune** — *why this project exists*
> The creator's Undertale/Deltarune kick is what prompted this project. It belongs
> at the top of this list, not as a footnote.

**Undertale** — **the structural template.** Undertale is a menu-driven turn-based
RPG where the enemy's turn drops the player into a **real-time sequence survived by
timing and skill.** Choose from a menu → then defend, live. **That is this game's
entire shape.** Paper Mario supplies the offensive press and Expedition 33 the
parry, but Undertale already fused *discrete turns* with *real-time defensive
skill* and shipped it.

**Undertale** — **mechanic as story.** The game where *how you play* **is** the
story, and the game remembers. This is the direct ancestor of §5.10: thirty hours of
casually using time magic silently accrues toward Cam's death, and **the sacrifice
is chosen by habit, not by a dialogue box.** Not an Undertale-*like* move — the
Undertale move.

**Deltarune** — **the release model.** Chapter 1 free, complete, standalone, ending
on a hook; later chapters arrive as free updates to a single purchase. **This is the
demo strategy in §8**, which we arrived at from first principles before noticing the
precedent.

### The rest
- **Paper Mario** — offensive action commands (the timed press).
- **Clair Obscur: Expedition 33** — defensive parry/dodge feel; telegraph reading.
- **Final Fantasy X** — the Overdrive gauge model (§5.3).
- **FF6 / FF7 / FFXII** — magitech tone; crystal-tech and airships in a lived-in world.
- **Chrono Trigger** — chapter pacing; a warm, tight party; time as subject matter.
  **Also the festival opening** — the Millennial Fair is the ancestor of Ch. 1.
- **Fire Emblem: Three Houses** — **Divine Pulse** as the model for Rewind: a finite,
  rechargeable pool granted by a goddess of time (§5.2).

### ⚠️ Known overlap — Deltarune Chapter 5
> [!warning] Be aware of this before someone else points it out
> **Deltarune Chapter 5, "Festival Day," released 24 June 2026.** It opens at dawn
> with the protagonist **weak, their skin a sickly green**, and is set around a
> **festival**.
>
> Our Ch. 1 is **"The Festival"**, and our protagonist is **weak and turning green**.
> This is parallel evolution during a Deltarune kick, not derivation — but the
> surface overlap is real and worth knowing.
>
> **How we differ, and it's substantial:**
> - Our festival opening descends from **Chrono Trigger's Millennial Fair** — a
>   catastrophe-at-a-celebration structure older than either game.
> - **Our green is load-bearing, not a symptom.** It's the disease, the banned magic,
>   the villain's cloak, and the hero's gift — **one colour doing four jobs**, and the
>   entire dramatic irony of the plot rests on it. → [[05 - World Bible]] § The green
>   thread.
> - Ours is **misread** by the world. That misreading *is* the story.

## 10. Open questions (GDD-level)

1. Approve or revise the **five pillars** (§2) — everything downstream inherits them.
2. Approve or revise **content counts** (§6).
3. **Time-pool economy** (§5.2) — size, recharge, per-spell costs. → [[02 - Combat Design]]
4. **Active party size: 3 or 4?** (§5.5) — decide by *feel* in Phase 1.
5. **Approve/veto the 4 proposed party members** → [[06 - Characters]]. Especially
   **Echo's Temporal Sickness**, which is canon-level, not a character detail.
6. **The §5.10 design hole** — restraint must not be strictly dominated.
7. **Ending matrix** — define all four cells + the True boss.
8. **Progression model** (§5.6).
9. **Crafting scope** (§5.8) — keep it minimal.
10. **Recruitment order** across 10–14 chapters.
11. Inherited canon questions → [[05 - World Bible]] §Open canon questions.
