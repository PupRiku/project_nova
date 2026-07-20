extends GutTest
## Behaviour, not tuned numbers. We assert that a parry blocks, a landed press
## beats a missed one, etc. — never that damage equals a specific value.

func test_parry_blocks_all_damage() -> void:
	assert_eq(CombatMath.incoming_damage(8, true), 0, "a successful parry is a full block")

func test_unparried_hit_takes_full_damage() -> void:
	assert_eq(CombatMath.incoming_damage(8, false), 8)

func test_landed_press_beats_missed_press() -> void:
	var hit := CombatMath.attack_damage(10, true, 1.5)
	var miss := CombatMath.attack_damage(10, false, 1.5)
	assert_gt(hit, miss, "a landed press must out-damage a miss")

func test_missed_press_is_base_damage() -> void:
	assert_eq(CombatMath.attack_damage(10, false, 1.5), 10)

func test_bonus_multiplier_scales_up_not_down() -> void:
	# For any bonus >= 1.0, a landed press never deals less than base.
	assert_true(CombatMath.attack_damage(10, true, 2.0) >= 10)

func test_defend_reduces_but_never_to_zero() -> void:
	# Unlike a parry (full block), Defend only mitigates.
	var base := 10
	var mitigated := CombatMath.mitigated_damage(base, 0.5)
	assert_lt(mitigated, base, "Defend reduces incoming damage")
	assert_gt(mitigated, 0, "Defend is not a full block — that's what parry is for")

func test_zero_mitigation_leaves_damage_unchanged() -> void:
	# So all unparried incoming damage can safely route through mitigated_damage.
	assert_eq(CombatMath.mitigated_damage(10, 0.0), 10)
