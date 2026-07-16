# 02 — Combat Design

> [!abstract] Status: **draft v0.1** — structure decided, **numbers pending**
> The core hook lives here. This doc holds the values `combat-systems` implements
> and `qa-test` asserts against.
> Roster & timing identities → [[06 - Characters]] · Pillars → [[01 - Game Design Document]]

> [!important] Numbers here are **tuning targets, not decisions**
> [[Roadmap]] Phase 1's exit criterion is *"the timing windows **feel** good."* No
> millisecond value in this doc is correct until it's been played. The job of the
> numbers below is to be **specific enough to build and tune**, not to be right.
> **Expect every one of them to change in Phase 1. That's the process working.**

---

## 1. Turn structure `DECIDED`

- **Discrete turns.** Not ATB, not a filling gauge.
- **Speed stat determines order.** **Ties go to the party member.**
- **Static, readable order** — the player can plan.
- **Bosses may act multiple times in a row** (1, 2, or more), per encounter design.

**State machine:** `TurnStart → PlayerInput → ActionResolve → EnemyTurn → CheckEnd`
Signals, not nested ifs. → [[03 - Technical Design]]

> [!danger] **The turn order must be visible.** Phase 1 dependency, not polish.
> Cam's kit is **Haste / Slow / Stop** — in a speed-ordered system these are not stat
> buffs, they are **edits to the queue** (move up / drop back / delete). **You cannot
> edit a sequence you can't see.**
>
> Model: **FFX's portrait queue** (already a §9 touchstone). Portraits visibly move
> when Cam casts. Build it in Phase 1 or the entire time-magic school is illegible.

---

## 2. The battle menu `DECIDED`

| Entry | What |
|---|---|
| **Attack** | main melee attack |
| **Magic** | all spells |
| **Skills** | all non-spell skills (steal, cheer, …) |
| **Item** | combat items, potions |
| **Defend** | defensive stance. **No parry, but reduced damage.** |

### Other buttons
| Input | What |
|---|---|
| **Flee** | **hold + confirm** to leave the battle |
| **Action / Parry** | press during attacks for extra damage; **timed parry for full damage block** |

**Summons** `DECIDED` — a **sub-menu under Magic**, appearing once available.

> [!question] Open — menu `TODO`
> **Cam's Magic menu will hold two currencies:** MP spells and **Temporal Spring**
> spells, side by side, with different costs. Either that's confusing, or it's
> great — *Cam's menu is visibly the protagonist's menu.* Decide whether **Time**
> gets its own top-level entry instead.
> *(Summons' cost is still open → [[01 - Game Design Document]] §5.4.)*

### 2.1 Defend — better than it looks
> [!success] Defend and multi-attack bosses are **one system**
> - Against a **1-attack** enemy, Defend is **strictly bad** — you burn a turn for
>   mitigation a free parry would have given you.
> - Against a boss swinging **five times in a row**, five parries is a lot to ask,
>   and guaranteed mitigation on all five is **smart**.
>
> **Boss attack-count is the dial that decides whether Defend is trash or correct.**
> Real depth, for free, out of two bullets that looked unrelated.

> [!important] Defend is also the **accessibility valve** (Pillar P5)
> The player who cannot parry always has a button that simply works. Do not balance
> it out of viability.

> [!success] 🛡️ **The reliability principle** — a design philosophy, not an exception
> Two independent decisions landed on the same rule:
> - **Defend** — no parry, **guaranteed** mitigation.
> - **Healing / self-use items** — no action command, **guaranteed** effect (§3.3).
>
> ### **Offense demands skill. Survival does not.**
>
> The game asks the player to *earn damage*; it never asks them to *earn staying
> alive.* Every player — the one who can't parry, the one having a bad night —
> always has a button that simply works.
>
> **This is Pillar P5 in practice, and it should guide a hundred small decisions
> later.** When in doubt about whether a defensive or recovery option needs an
> action command: **it doesn't.**

`TODO:` Defend's mitigation % — flat, or a stat? Does it persist for the round or
until Cam's next turn?

---

## 3. Action commands

### 3.0 The vocabulary `DECIDED` — **read this before adding any move**

**Every attack, spell, and ability has its own *type* of action command.** But they
are drawn from a **fixed vocabulary** — they are **not bespoke per move.**

> [!danger] This distinction decides whether the feature ships
> **Paper Mario** has dozens of moves and roughly **six input types**. Every move
> draws from that small vocabulary. It does **not** ship forty unique minigames.
>
> We have **~70 party moves** ([[01 - Game Design Document]] §6).
> - **8 types, reused** → tractable: 8 systems to build, tune, and teach.
> - **70 bespoke** → design, implementation, tuning, debugging, *and player
>   learning* all multiply by 70. **The project dies.**
>
> **Adding a new input type is a real cost. Assigning an existing one is free.**

| # | Type | Input | Used by |
|---|---|---|---|
| 1 | **Press** | one timed press at the cue | **Cam** (basic), **Lyra** (throw + catch = ×2) |
| 2 | **Sequence** | chained presses, in order | **Cam** (combo), **Kate** (recipe) |
| 3 | **Hold & release** | hold; release at the peak | **Klaus** (triage), **Vesper** (charge — overcharge backfires) |
| 4 | **Mash** | rapid repeated presses | **Magpie** (flurry) |
| 5 | **Rhythm** | multi-beat pattern — **DDR-like** | **Lyra** (dance) |
| 6 | **Sweet-spot** | stop a moving marker in a zone | **Vale** (active reload — perfect or jam) |
| 7 | **Hold steady** | resist drift; keep it centred | **Echo** (hold the loop) |
| 8 | **Aim** | **spatial** — the only one | **combat items** (§3.3) |

**Eight types. All nine characters covered.** This vocabulary was not invented — it
is [[06 - Characters]]' roster, named. *(Amos's **Intercept** sits on the defensive
axis, §3.2 — not here.)*

> [!warning] ⏱️ Time budget — all commands should cost **roughly the same seconds**
> Target: **~1–2 s.** A five-second dance combo feels amazing once and **murderous by
> the twentieth turn of a boss fight.** Turns must feel *even*, or the character with
> the longest command becomes the character nobody fields.
> **Keep Lyra's rhythm short — four arrows, not sixteen.** `TODO:` confirm the budget.

> [!success] 🎮 The input type is a **difficulty selector** — free accessibility
> **Nine characters. Three or four active slots.**
>
> A player good at rhythm fields **Lyra**. A player with precise timing fields
> **Vale**. A player who cannot do rhythm games *simply never fields Lyra* — and
> **loses nothing**, because there are eight other people.
>
> **The roster is a menu of input styles**, and the player builds a party partly
> around what their hands are good at. A real Pillar **P5** answer that costs
> nothing — and it is **only possible because the roster is 9, not 6.**
>
> **Design consequence:** spread the vocabulary across the roster so no input type is
> mandatory. If two characters are the only Sequence users and both are benched, the
> player should still have a full kit.

### 3.1 Offensive — the press
Timed input that boosts an action. **Reference: Paper Mario.**
- Input type: **assign from §3.0's vocabulary** → [[06 - Characters]]
- **Window:** `TODO` ms — *tuning target*
- Success effect: `TODO` (+X% damage / extra hit)
- Feedback: visual **and audio** cue on window and on success. **Audio is a P5
  obligation, not polish** — players parry by sound as much as sight.

### 3.2 Defensive — the parry
Timed reaction to incoming attacks. **Reference: Clair Obscur: Expedition 33.**
- **Parry window:** `TODO` ms → **full damage block**
- **Dodge:** `TODO` — is this distinct from parry, or is parry the only defensive
  timing? *(Creator's list names only parry. Decide.)*
- **Block:** covered by **Defend** (§2.1), which is a menu action, not a window.
- **Telegraph:** how an incoming attack is signalled, and its lead time. `TODO`

### 3.3 Items `DECIDED`
| Item type | Action command |
|---|---|
| **Healing / self-use** | **None.** Guaranteed. |
| **Combat items** (grenade, thrown potion, …) | **Aim the object.** |

> [!important] Why healing items correctly have no command
> **Healing items are the panic button.** A minigame on the panic button means a
> player already in trouble can **fail to heal at the exact moment they most need
> to.** That isn't depth — it's punishing someone for being in trouble.
> See § The reliability principle (§2.1).

> [!note] P2 was **overstated**, not violated — *pillar refinement*
> [[01 - Game Design Document]] P2 reads *"there is no such thing as a passive
> turn."* The pillar's actual teeth are the next sentence: ***"if a player can win by
> mashing confirm, we have failed."***
>
> A healing item doesn't threaten that — it costs a consumable, costs a turn, and
> doesn't advance the win. **The pillar refines; it doesn't take an exception.**

> [!question] What form does **aiming** take? `TODO`
> **Aiming is vocabulary type #8 — and the only *spatial* one** (§3.0). Everything
> else asks the player to read *time*; grenades ask them to read *space*. But which?
> - **Moving reticle you stop** — still timing, dressed differently. *(Would collapse
>   into type #6, Sweet-spot — one fewer system to build.)*
> - **Free aim / arc** — truly spatial. *(A genuine 8th type, and a real change of
>   pace — but a real cost.)*
>
> They feel completely different. Pick deliberately.

> [!question] Who parries? `TODO`
> With a **3–4 active party**, an enemy attacking Klaus — does the player parry *as
> Klaus*? Presumably yes. **Then active party size scales the player's parry load**
> (→ [[01 - Game Design Document]] §5.5), and **Amos's Intercept** (parry on an
> ally's behalf) becomes a *team* mechanic. Confirm.

---

## 4. Cam's time magic — **the Temporal Spring** `DECIDED (mechanism) / TODO (numbers)`

> [!success] The name is doing three jobs — keep it
> A **spring** is a source that refills, a **clock spring** that winds and releases,
> and the **season of renewal.** The middle one is literally the mechanism that
> drives a clock.

- **Levels 1 → 6.** Maximum level **rises as the game progresses.**
- **Each time spell/ability costs a specific number of levels.**
- Spells: **Rewind**, **Haste**, **Slow**, **Stop**, + `TODO` (~5–7 total).
- **Cam only.** It is Cam's Gift; no one else has it.

> [!success] The Spring is not a magic pool — it's an **editing budget for the
> battle's timeline**
> Speed sets a **static order** (§1). So **Haste** moves a portrait **up** the queue,
> **Slow** drops it **back**, **Stop** **deletes** a turn, and **Rewind** un-writes
> what already resolved.
>
> **Cam doesn't deal damage with the Spring. Cam rewrites *sequence*.** That is an
> identity no other JRPG resource has, and it falls straight out of the existing
> design. Protect it: **resist making time spells into damage or stat buffs.**

### 4.1 Opportunity cost — the reason this works
All time abilities draw from **one** Spring. **Every Rewind is a Haste you didn't
cast.** The safety net **is** the offense. That's what stops rewind from deleting the
stakes (→ [[01 - Game Design Document]] §5.2) — **opportunity cost, not an arbitrary
cap.**

### 4.2 Rewind is a **meta-action** `DECIDED`
**Rewind costs Spring levels — not a turn.** The Spring cost is the entire limiter.

> If Rewind cost your **turn**, it would be a bad spell: you undo something, and
> you've spent your turn undoing it. **Divine Pulse is not a turn action** — you
> press it and time moves. Same here.

`TODO:` What does a Rewind undo — the **last action**, the **last turn**, or the
**last round**? Does its cost scale with how far back it reaches?
`TODO:` Level costs per spell. Recharge rule (per battle? per rest? story-gated?).
`TODO:` Does the Spring **persist between battles** or reset?

---

## 5. Overdrive `DECIDED`

**Universal** — every party member has one. FFX lineage. Introduced at the Ch. 1 boss.

### 5.1 Base fill — three sources
Each at a **different rate**, scaled by the damage number:
1. **Dealing damage**
2. **Taking damage**
3. **Magical healing**

**This is the default, and it is automatic.** A player who never opens a menu still
charges Overdrive by playing.

### 5.2 The **Overdrive Charger** `DECIDED`
Each party member also gets a **bonus fill source of the player's choosing**, set in
the **party menu**. Unlocked via **level up, rewards, etc.**

**Two classes of charger:**

| Class | What | Examples |
|---|---|---|
| **Boost** — a *multiplier* | increase earnings from one of the three base sources | "damage taken ×2" |
| **New source** — a *new income stream* | add a **4th** fill source | **presses landed** · **parried hits** · **specific ability uses** · **MP spent** |

> [!warning] The two classes are **not equal** — balance accordingly
> **Boost** is a multiplier on income you already have. **New source** changes *how
> the character is played.* New-source chargers should be **rarer, later, and more
> expensive.**

> [!danger] Steal FFX's system — **and dodge its known failure**
> In FFX, some Overdrive modes are simply better: **Stoic** (damage taken) is
> famously farmable, **Warrior** is the boring default, and most players find the one
> good answer and stop thinking. **Depth on paper; one correct answer in practice.**
>
> **The fix: role synergy.** Each character's *natural* charger should fall out of
> their job —
> | Character | Natural charger |
> |---|---|
> | **Amos** (tank) | damage taken |
> | **Klaus** (healer) | healing |
> | **Vale** (DPS) | damage dealt |
> | **Vesper / Echo** (mages) | **MP spent** |
>
> Now there is **no universal best** — the best answer *differs per character*, and
> the real choice becomes **lean into your role, or against it.** The interesting
> builds are the counter-intuitive ones: **a healer who charges off parried hits** is
> a player expressing something.
>
> **Encounter-dependence helps too.** A boss that swings five times makes
> damage-taken chargers shine. Because chargers are swappable in the party menu, they
> become **per-fight prep**, not a one-time solve.

> [!important] Apply the **§3.0 lesson**: chargers are a **shared pool**
> Unlocked over the campaign, **equippable by anyone** — *not bespoke per character.*
> **Ten chargers × nine characters = ten things to build, not ninety.** Same
> reasoning that saved us from seventy minigames.
> *(Character-exclusive chargers can exist later as rewards — but the pool is the
> default.)*

> [!success] The floor is automatic; the ceiling is opt-in
> The **base fill (§5.1) is the difficulty valve** — see §6. It works for a player who
> never opens the party menu. **The Charger lets an engaged player override it** and
> double down on skill (*presses landed*, *parried hits*).
>
> **Safety net by default. Expression by choice.** This shape emerged by accident —
> **don't balance it away.**

> [!note] This may be a chunk of **progression** (→ [[01 - Game Design Document]] §5.6,
> still `TODO`)
> Chargers give the **eight non-Cam characters** a progression hook that isn't rising
> numbers. ***What my Overdrive feeds on*** is a more interesting thing to level into
> than *+3 STR*.

`TODO:` name (temp: "Overdrive"; "Overdrive Charger" follows it).
`TODO:` how many chargers in the pool? Unlock cadence?
`TODO:` **does Cam get a Charger** for their Overdrive, or is the Spring their
customization?
`TODO:` One Overdrive **attack** per character × 9 → real animation scope.

## 6. Overdrive vs. the Spring — **RESOLVED** ✅

> [!note] The problem (for the record)
> v0.1 had **both gauges filling from the same three sources**, simultaneously. The
> player never *chose* between them — both rose, both got spent. **Two bars of UI,
> one decision**, and the Spring was mechanically a second MP bar.
>
> **And a perverse incentive hid inside it:** Overdrive fills on *taking damage*, and
> a successful parry is a **full block**. So every time the player did the thing the
> whole game is built around, **they starved their own Overdrive.** Being good at
> Project Nova was punished.

### The resolution `DECIDED`

| | **Overdrive** | **Temporal Spring** |
|---|---|---|
| **Fills from** | damage dealt · damage taken · healing *(+ the Charger, §5.2)* | **successful action commands** — presses landed, parries hit |
| **Whose** | everyone | **Cam only** |
| **Means** | **what the fight did to you** — *reactive* | **what you did to the fight** — *earned* |

**The action-command fill is Cam-only.** Others reach it — if they want — through a
**new-source Charger** (§5.2). *Cam is the natural time-reader; the rest can train
toward it.*

> [!success] 🎚️ They are now **inversely correlated** — a difficulty valve with no
> difficulty menu
> - **Parry everything** → you take no damage → **Overdrive crawls** — but the
>   **Spring is full.**
> - **Whiff every window** → you eat every hit → **the Spring is dry** — but
>   **Overdrive is charged and ready.**
>
> The player who is struggling gets handed **limit breaks**. The player who is
> reading the fight gets handed **time magic**. **Both always have something; neither
> is ever locked out.** The game meets people where they are — **without a setting, a
> slider, or an apology.**
>
> It also **kills the perverse incentive**: parrying no longer starves you, it
> **pays you in a different currency.**

> [!success] And the Spring becomes the thesis instead of a bar — **Pillar P1**
> **read time well → earn time magic → spend it → read time better.**
>
> The player's own fluency generates Cam's power. The Spring's growth across the
> campaign stops being a stat and becomes **a scoreboard of the player's skill at the
> thing the game is about.**

> [!warning] Guardrail — Pillar **P5**
> Give the Spring a **small baseline tick** so a bad round never zeroes it out. Skill
> should **accelerate** the Spring, not **gate** it.

`TODO:` fill rates. Baseline tick size. Does a *partial* success (early/late press)
fill partially?

## 7. Damage & healing formulas `TODO`
Pure, unit-testable functions. No formula in UI code.
- Base damage = `TODO`
- Crit rule = `TODO`
- **Action-command modifier application order** = `TODO`
- Healing = `TODO`
- Defend mitigation = `TODO`

## 8. Resources `DECIDED`

| Resource | Who | Spent on | **Display** |
|---|---|---|---|
| **HP** | all | — | **number** |
| **MP** | all | **Magic** (non-time spells) | **number** |
| **Overdrive** | all | the limit attack | **bar** |
| **Temporal Spring** | **Cam only** | time abilities (levels 1→6) | **pips** |

> [!success] The "thirteen bars" worry was **wrong** — the shape already solves it
> FFX and Persona 5 don't *solve* a crowded HUD, they **sidestep** it: **HP and MP
> are numbers, not bars.** Bars are reserved for things that are genuinely
> gauge-like.
>
> And the **Spring is levels 1→6 — that's not a bar, it's *pips*.** Which is *better*
> than a bar: *"I have 4 of 6"* reads instantly, and **spell costs become legible at
> a glance** (*"Stop costs 3 — can't afford it yet"*).
>
> **Three visually distinct types — numbers / bar / pips — and nobody confuses
> them.** Not a problem to solve; already solved by the shape of the design.
> → [[04 - Art & Audio Direction]] §6

`TODO:` MP costs per spell. Does MP restore between battles? Do Summons cost MP, or
something else (→ [[01 - Game Design Document]] §5.4)?

## 9. Status effects `TODO`
Table: name · effect · duration · stacking rule · application chance.

## 10. Enemy design & AI `TODO`
How enemies choose actions. **Telegraph readability is a P5 obligation.**
**Boss attack-count** is a primary design dial (§2.1).

## 11. Victory / defeat `TODO`
Rewards on win; consequences on loss.
> **Cam's victory pose degrades once per act** — the Gift killing him, in the moment
> the game congratulates the player. → [[04 - Art & Audio Direction]] §2.2

## 12. Feel & juice `TODO`
Hitstop, screen shake, flash, sound layering — what sells the timing.

---

## Open questions
1. **§3.2 — is Dodge distinct from Parry?**
2. **§3.3 — aiming: moving reticle** *(collapses into Sweet-spot)* **or free aim**
   *(a true 8th type)*?
3. **§3.0 — confirm the ~1–2 s time budget** for action commands.
4. **§2 — does Time get its own menu entry**, or sit inside Magic beside MP spells?
5. **§5.2 — how many Chargers in the pool?** Unlock cadence? **Does Cam get one?**
6. **Summon economy** — MP? Its own cost? → [[01 - Game Design Document]] §5.4
7. **Active party: 3 or 4?** Decide by **feel** in Phase 1 — it scales parry load.
8. All **numbers**. Every one. They're tuning targets → Phase 1.

*Resolved: Summons → Magic sub-menu (§2) · Rewind → meta-action (§4.2) · MP → yes;
HUD is numbers/bar/pips (§8) · Items → healing none, combat aim (§3.3) · **the
reliability principle** (§2.1) · **the action-command vocabulary — 8 types, not 70
minigames** (§3.0) · **§6 — the Overdrive/Spring collision ✅ RESOLVED** · **the
Overdrive Charger** (§5.2).*

> [!success] **No structural questions remain in combat.** Everything above is either
> decided, or a **number Phase 1 will find by feel.** → this doc no longer gates
> development.
