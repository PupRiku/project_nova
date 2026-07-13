# 02 — Combat Design

> [!abstract] Status: **outline — to be authored together**
> The core hook lives here. This doc holds the exact values the
> [[combat-systems]] agent implements and the [[qa-test]] agent asserts against.
> Precision matters: timing feel is the whole game.

## 1. Turn structure
Discrete turns. Order determined by `TODO` (speed stat? fixed? initiative?).
State machine: TurnStart → PlayerInput → ActionResolve → EnemyTurn → CheckEnd.
See [[03 - Technical Design]] for the implementation shape.

## 2. Action commands — offensive (Paper Mario style)
Timed input that boosts an action.
- Input type(s): `TODO` (single press / hold-release / sequence / mash)
- **Timing window**: `TODO` ms, opening at `TODO` relative to the animation cue
- Success effect: `TODO` (e.g. +X% damage, extra hit)
- Feedback: visual + audio cue on the window and on success `TODO`

## 3. Action commands — defensive (Expedition 33 style)
Timed reaction to incoming attacks.
- **Parry window**: `TODO` ms — effect: `TODO` (negate + counter?)
- **Dodge window**: `TODO` ms — effect: `TODO`
- **Block**: `TODO` (hold? partial mitigation %?)
- Telegraph: how the incoming attack is signaled, and lead time `TODO`

## 4. Damage & healing formulas
Pure, testable functions. Fill exact math. `TODO`
- Base damage =
- Crit rule =
- Action-command modifier application order =
- Healing =

## 5. Resources
HP, and `TODO` (MP? a build-and-spend meter? per-battle charges?).

## 6. Status effects
Table: name · effect · duration · stacking rule · application chance. `TODO`

## 7. Enemy design & AI
How enemies choose actions; readability of telegraphs. `TODO`

## 8. Victory / defeat
Rewards on win; consequences on loss (game over? retry? soft penalty?). `TODO`

## 9. Feel & juice
Hitstop, screen shake, flash, sound layering — what sells the timing. `TODO`
