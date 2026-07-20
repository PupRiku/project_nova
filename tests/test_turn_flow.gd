extends GutTest
## Covers the two FSM sequencing behaviours (Defend clear-timing, mid-round death
## routing) via the SAME pure functions the FSM calls at those points —
## TurnOrder.begin_turn (invoked at TURN_START), CombatMath.resolve_incoming
## (invoked in the enemy RESOLVE), and TurnOrder.resolve_turn_advance (invoked in
## _check_end). Testing these tests the FSM's real decisions, not a parallel model.
## Behaviour only — no tuned numbers.

func _make(is_player: bool, idx: int, hp: int = 30) -> Combatant:
	var data := CombatantData.new()
	data.max_hp = hp
	return Combatant.new(data, is_player, idx)

# ---------------------------------------------------------- (1) Defend clear-timing
func test_defend_mitigates_until_next_turn_then_clears() -> void:
	var defender := _make(true, 0, 40)
	var base := 12
	defender.begin_defending(0.5)  # FSM applies this in the RESOLVE of a Defend action
	assert_true(defender.is_defending)

	# An enemy hit that lands before the defender's next turn is mitigated:
	var while_defending := CombatMath.resolve_incoming(base, false, defender.is_defending, defender.mitigation)
	assert_lt(while_defending, base, "mitigation is active across the enemy turn")
	assert_gt(while_defending, 0, "Defend mitigates — it is not a full block")

	# The defender's next TURN_START runs begin_turn, which must clear Defend:
	TurnOrder.begin_turn(defender)
	assert_false(defender.is_defending, "Defend is cleared at the defender's next TURN_START")

	# A hit after that lands full:
	var after_clear := CombatMath.resolve_incoming(base, false, defender.is_defending, defender.mitigation)
	assert_eq(after_clear, base, "full damage once Defend has cleared")

func test_incoming_is_full_when_not_defending() -> void:
	assert_eq(CombatMath.resolve_incoming(10, false, false, 0.5), 10)

func test_parry_is_a_full_block_even_while_defending() -> void:
	assert_eq(CombatMath.resolve_incoming(10, true, true, 0.5), 0, "a parry blocks fully regardless of Defend")

# ------------------------------------------------ (2) Mid-round death index integrity
func test_advance_skips_a_combatant_that_died_mid_round() -> void:
	var a := _make(true, 0)   # acts this turn
	var e1 := _make(false, 1) # killed by A
	var b := _make(true, 2)
	var e2 := _make(false, 3) # keeps the battle going
	var order := [a, e1, b, e2]
	e1.take_damage(999)
	var step := TurnOrder.resolve_turn_advance(order, 0, order)
	assert_eq(step.advance, TurnOrder.Advance.NEXT_TURN)
	assert_eq(step.next_index, 2, "the dead e1 at index 1 is skipped")
	assert_eq(order[step.next_index], b, "routing lands on the correct next actor")
	assert_true(order[step.next_index].is_alive(), "the FSM never routes to a dead combatant")

func test_battle_end_is_checked_before_routing_to_the_next_actor() -> void:
	# A kills the last enemy. Even though a living party member follows in the order,
	# the verdict must be VICTORY — not a turn handed to that ally.
	var a := _make(true, 0)
	var e1 := _make(false, 1)
	var b := _make(true, 2)
	var order := [a, e1, b]
	e1.take_damage(999)
	var step := TurnOrder.resolve_turn_advance(order, 0, order)
	assert_eq(step.advance, TurnOrder.Advance.VICTORY, "a side-wipe ends the battle before the next turn is routed")

func test_advance_starts_a_new_round_after_the_last_living_actor() -> void:
	var a := _make(true, 0)
	var e := _make(false, 1)  # both alive; e acts last
	var order := [a, e]
	var step := TurnOrder.resolve_turn_advance(order, 1, order)
	assert_eq(step.advance, TurnOrder.Advance.NEW_ROUND)

func test_advance_reports_defeat_when_party_is_wiped() -> void:
	var a := _make(true, 0)
	var e := _make(false, 1)
	a.take_damage(999)
	var step := TurnOrder.resolve_turn_advance([a, e], 1, [a, e])
	assert_eq(step.advance, TurnOrder.Advance.DEFEAT)
