class_name EnemyAttackData
extends Resource
## The enemy's single attack (Phase 1). Authored as data. Tuning targets.

## Damage dealt when the hit is NOT parried.
@export var damage_base: int = 8

## Seconds of readable telegraph before the parry window's clock begins
## (Combat Design §3.2 telegraph lead). A pure "enemy winds up" warning beat,
## kept separate from the window placement so both are tunable independently.
@export var telegraph_lead: float = 0.5

## The defensive Parry window (§3.2). A successful parry = full block.
@export var parry: ActionCommandTiming
