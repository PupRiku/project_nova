# 04 — Art & Audio Direction

> [!abstract] Status: **outline — but with hard constraints already locked**
> The visual target is still open. **§2 is not** — those constraints emerged from
> the story and the payoffs depend on them. Read §2 before proposing any style.
> Canon → [[05 - World Bible]] · Cards → [[07 - Tarot Ledger]]

---

## 1. Visual target `TODO`
2D. Choose the register: **pixel art / hand-drawn / painterly / flat vector**.
Mood board refs: `TODO`

> [!warning] Whatever style is chosen must satisfy every constraint in §2.
> Several of them (a recognizable face across 20+ hours; a slow iris colour creep;
> three distinct card-art registers) **materially constrain the style.** Pick the
> style *against* this list, not before it.

---

## 2. Locked constraints — from canon

### 2.1 🟢 The green thread — the game's colour
**Green is the colour of time magic**, and it means three things at once:
- **Temporal Sickness** — fully green irises (Echo, and the afflicted)
- **Vaik** — his green-and-black cloak, his glowing staff
- **Cam's Gift** — the flash when the power triggers

> The world sees green and reads *plague*. It's wrong about the mechanism and right
> about the outcome. **Keep this deliberate across palette, VFX, and character
> design.** → [[05 - World Bible]] § The green thread

### 2.2 👁️ Cam's decline — must read, must not read as weakness
Cam is **dying of the Gift**, and **never gets mechanically weaker.** The decline is
**purely visual**, and it must never look like a power-down.

| Symptom | Where it shows |
|---|---|
| **Exhaustion** — dark circles, drawn features | portrait + sprite |
| **Delayed response, trouble focusing** | writing / cutscene timing |
| **Worn out after battle** | **the victory screen** — see below |
| **Iris creep** — green spreading **slowly**, partial | portrait, over acts |

> [!danger] **The victory pose.** One animation swap per act. Free, and devastating.
> The party does win poses. **Cam is slower.** Then Cam catches their breath. Then
> Cam sits down. The player watches Cam die **in the exact moment the game is
> congratulating them** — every single fight, at zero mechanical cost.

> [!danger] **The iris completes at the Undo.** The green finishes exactly as Cam
> stops being human. This is the visual thesis; it needs to be trackable across the
> campaign, which means the portrait style must support a **slow, subtle colour
> shift**.

**Contrast requirement:** Cam's presentation must be **visibly distinct** from
Echo's textbook Temporal Sickness (full green irises, temporal tics). The party can
tell them apart at a glance — *the plot depends on it.*

### 2.3 🃏 Card art — two decks, three states
→ [[07 - Tarot Ledger]] for the full spec and the reserved card.

| State | Style | Count | Notes |
|---|---|---|---|
| **Classic** (Esmerelda's) | classic / Rider-Waite lineage; **iconographic** | ~5 | flashback only |
| **Corrupted** (Vaik's — *the same deck, soured*) | Persona 5-adjacent, **less pop-art**; stylized menace | ~15–20 | bosses + thrown cards. **Same compositions as Classic** — shared design language, not a second deck |
| **Modern** (Whisper's) | **oil-painted**, dreamy — ref: [The Fountain Tarot](https://www.fountaintarot.com/) | ~13 | readings |

> [!important] **The medium is the mechanism.** Only the oil-painted Modern deck can
> carry a **recognizable human face** — classic tarot is symbolic, corrupted art
> yields a mask. That is the entire reason Esmerelda's likeness can appear on
> Whisper's Star and nowhere else. **Do not flatten the three registers.**

**~40 unique illustrations** total. A real line item — but cheaper than it looks,
since Classic and Corrupted are **one deck in two states**.

### 2.4 👵 Esmerelda must survive 20+ hours of player memory
The payoff requires a player to see her in a **flashback**, then recognize her on a
**card** many hours later — **unprompted, with no dialogue pointing at it.**

- She needs a **distinctive, memorable silhouette and face**. Not a generic old
  fortune teller.
- **The Star's art must be legible** at its display size.
- The flashback must give a **clear, lingering look.**
- **Ordering constraint:** the Vaik flashback **must** precede Whisper's return.

### 2.5 🕯️ The altar — a timeline diff
- **Prologue (Timeline A):** Kate's altar, in the apartment. **Two figures — Ai and
  Kai.** Set dressing; examining it gives a line of flavor.
- **Finale (Timeline B):** same apartment, same altar. **Three figures.** The player
  counts. Then the camera finds the name: **Kym**.

> **Build the altar into the prologue.** The finale is free if it exists; impossible
> if it doesn't.

### 2.6 🧬 Peoples
Humans and **beast-folk** — canonically **canine** (Klaus), **feline** (Whisper),
**avian** (Magpie, proposed). Style must accommodate all three without them reading
as costumes.

---

## 3. Resolution & scaling `TODO`
Base resolution: `TODO` (project currently **640×360**, integer-scaled).
Pixel-perfect? Camera rules? `TODO`

> [!warning] Interacts with §2.2 and §2.4: **640×360 may be too coarse** for a
> subtle iris creep and a recognizable face on a tarot card. Resolve together.

## 4. Palette & typography `TODO`
Core palette `TODO` — **must reserve green** for §2.1. UI font(s) `TODO`.

## 5. Sprite specs `TODO`
- Character sprite size / anchor / animation frame conventions
- Enemy conventions
- Required animation states: idle, attack, hurt, ko, **parry-react**, overdrive,
  **victory (×N acts for Cam — see §2.2)**

## 6. UI / HUD direction `TODO`
Battle menu, HP/resource display, **timing-window feedback**, Cam's **time-pool**
gauge, **Overdrive** gauge.

> The timing feedback is the most important UI in the game. See
> [[02 - Combat Design]].

## 7. Audio direction `TODO`
Music tone/instrumentation `TODO`.

> [!important] **SFX for action commands are critical, not polish.** The player
> parries **by sound as much as by sight** — audio cues are a Pillar P5 obligation
> (*readable, not reflexive*). Budget for them accordingly.

## 8. Pipeline `TODO`
Source tool → export settings → import into Godot → naming/foldering.
Assets are Git LFS tracked (see `.gitattributes`).
