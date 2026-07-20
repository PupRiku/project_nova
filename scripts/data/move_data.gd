class_name MoveData
extends Resource
## A player-side action (Phase 2A). Every offensive action reuses the validated
## Phase 1 Press; guaranteed actions (Defend, self-heal) have no command per the
## §2.1 reliability principle. Authored as data — never hard-coded.

## Which battle-menu entry this move lives under (Combat Design §2).
enum Category { ATTACK, MAGIC, SKILL, ITEM, DEFEND }
## Who the move can be aimed at.
enum Target { SINGLE_ENEMY, SINGLE_ALLY, SELF }
## What the move does on resolve.
enum Effect { DAMAGE, HEAL, DEFEND }

@export var display_name: String = "Attack"
@export var category: Category = Category.ATTACK
@export var target: Target = Target.SINGLE_ENEMY
@export var effect: Effect = Effect.DAMAGE

## Damage dealt (DAMAGE), HP restored (HEAL), or unused (DEFEND). Tuning target.
@export var damage_base: int = 10

## When true, this action runs the Phase 1 offensive Press window and a landed press
## multiplies the effect by `press_bonus_mult`. When false, the effect is guaranteed
## (§2.1 — Defend and self-heal earn no skill check).
@export var uses_press: bool = true
@export var press: ActionCommandTiming
@export var press_bonus_mult: float = 1.5

## DEFEND only: fraction of incoming damage blocked until this combatant's next turn
## (0.0–1.0). Distinct from a parry, which is a full block. Tuning target.
@export var mitigation: float = 0.5
