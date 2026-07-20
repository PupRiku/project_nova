extends GutTest
## Behaviour, not stat numbers (per the qa-test brief). Builds combatants with
## arbitrary speeds and asserts the RULES: higher speed acts first, ties go to the
## party member, the dead are skipped, a side wipe ends the battle, targeting
## respects sides and life. Speeds here are fixtures — change them freely.

func _make(speed: int, is_player: bool, idx: int, hp: int = 10) -> Combatant:
	var data := CombatantData.new()
	data.max_hp = hp
	data.speed = speed
	return Combatant.new(data, is_player, idx)

func test_higher_speed_acts_first() -> void:
	var slow := _make(3, true, 0)
	var fast := _make(9, false, 1)
	var order := TurnOrder.sort_order([slow, fast])
	assert_eq(order[0], fast, "faster combatant is first regardless of side")
	assert_eq(order[1], slow)

func test_speed_tie_goes_to_the_party_member() -> void:
	var enemy := _make(5, false, 0)
	var player := _make(5, true, 1)
	var order := TurnOrder.sort_order([enemy, player])
	assert_eq(order[0], player, "on a speed tie the party member acts first (§1)")

func test_full_tie_orders_deterministically() -> void:
	var a := _make(5, true, 0)
	var b := _make(5, true, 1)
	# Same speed and side: init_index breaks the tie the same way regardless of input order.
	assert_eq(TurnOrder.sort_order([b, a])[0], a)
	assert_eq(TurnOrder.sort_order([a, b])[0], a)

func test_next_living_skips_the_dead() -> void:
	var a := _make(9, true, 0)
	var b := _make(6, true, 1)
	var c := _make(3, false, 2)
	b.take_damage(999)  # b is down
	var order := TurnOrder.sort_order([a, b, c])  # a, b, c by speed
	assert_false(b.is_alive())
	assert_eq(order[TurnOrder.next_living_index(order, 1)], c, "index 1 is dead → skip to next living")

func test_next_living_returns_minus_one_when_round_is_done() -> void:
	var a := _make(5, true, 0)
	a.take_damage(999)
	assert_eq(TurnOrder.next_living_index([a], 0), -1)

func test_battle_ends_in_victory_when_enemies_all_down() -> void:
	var p := _make(5, true, 0)
	var e := _make(5, false, 1)
	e.take_damage(999)
	var res := TurnOrder.battle_result([p, e])
	assert_true(res.over)
	assert_true(res.player_won)

func test_battle_ends_in_defeat_when_party_all_down() -> void:
	var p := _make(5, true, 0)
	var e := _make(5, false, 1)
	p.take_damage(999)
	var res := TurnOrder.battle_result([p, e])
	assert_true(res.over)
	assert_false(res.player_won)

func test_battle_not_over_while_both_sides_stand() -> void:
	var res := TurnOrder.battle_result([_make(5, true, 0), _make(5, false, 1)])
	assert_false(res.over)

func test_targeting_returns_requested_side_and_excludes_dead() -> void:
	var p1 := _make(5, true, 0)
	var p2 := _make(5, true, 1)
	var e1 := _make(5, false, 2)
	p2.take_damage(999)  # dead ally
	var enemies := TurnOrder.living_targets([p1, p2, e1], false)
	assert_eq(enemies.size(), 1, "only living enemies are attackable")
	assert_eq(enemies[0], e1)
	var allies := TurnOrder.living_targets([p1, p2, e1], true)
	assert_eq(allies.size(), 1, "a support move sees living allies only (dead excluded)")
	assert_eq(allies[0], p1)
