class_name Combatant
extends RefCounted
## Runtime state for one participant in a battle. Wraps the static `CombatantData`
## .tres with the mutable state a fight needs (current HP, side, defend status).
## Not a Node — pure and testable. This is the object the FSM, UI, and signals
## all pass around.

var data: CombatantData
var is_player: bool
var current_hp: int
## Stable tiebreak so turn order is deterministic when speeds tie (Combat Design §1).
var init_index: int

## Set by Defend; cleared at this combatant's next turn (§2.1).
var is_defending: bool = false
var mitigation: float = 0.0

func _init(p_data: CombatantData, p_is_player: bool, p_init_index: int) -> void:
	data = p_data
	is_player = p_is_player
	init_index = p_init_index
	current_hp = p_data.max_hp

func is_alive() -> bool:
	return current_hp > 0

func speed() -> int:
	return data.speed

func display_name() -> String:
	return data.display_name

func take_damage(amount: int) -> void:
	current_hp = maxi(0, current_hp - amount)

func heal(amount: int) -> void:
	current_hp = mini(data.max_hp, current_hp + amount)

func begin_defending(p_mitigation: float) -> void:
	is_defending = true
	mitigation = clampf(p_mitigation, 0.0, 1.0)

func clear_defending() -> void:
	is_defending = false
	mitigation = 0.0
