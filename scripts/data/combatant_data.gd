class_name CombatantData
extends Resource
## A combatant's authored identity + stats (Phase 2A). Static data — mutable
## per-fight state lives on the runtime `Combatant`. Balancing = editing this .tres.

@export var display_name: String = "Combatant"
@export var max_hp: int = 30

## Turn order is sorted by Speed, high → low (Combat Design §1); ties go to the
## party member. Tuning target.
@export var speed: int = 5

## Placeholder-art colour for this combatant's rectangle — zero art, just enough
## to tell combatants apart on screen.
@export var color: Color = Color(0.5, 0.5, 0.5, 1.0)

## Player-side menu actions — MoveData entries (Attack / Magic / Skills / Item /
## Defend). The menu is built from these. Leave empty for enemies. (Untyped Array
## so the .tres authors cleanly; every element is a MoveData.)
@export var moves: Array = []

## Enemy AI attacks — EnemyAttackData entries; one is chosen at random on the
## combatant's turn, each carrying its own telegraph + parry (the Phase 1 defensive
## flow). Empty for players. (Untyped Array; every element is an EnemyAttackData.)
@export var enemy_attacks: Array = []
