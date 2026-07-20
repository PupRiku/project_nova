class_name CombatMath
## Pure, unit-testable combat math (Combat Design §7). No formula lives in UI or
## scene code — it lives here so balancing is data + one place, and tests assert
## behaviour rather than any specific tuned number.

## Damage the hero deals. A landed Press applies the move's bonus multiplier
## (§3.1 "+X% damage"); a miss deals base.
static func attack_damage(base: int, press_success: bool, bonus_mult: float) -> int:
	var dmg: float = float(base)
	if press_success:
		dmg *= bonus_mult
	return int(round(dmg))

## Damage the hero takes. A successful parry is a full block (§3.2).
static func incoming_damage(base: int, parried: bool) -> int:
	if parried:
		return 0
	return base

## Damage after Defend mitigation (§2.1). Reduces by a fraction (0.0–1.0) but —
## unlike a parry — never to zero. `mitigation` of 0.0 returns base unchanged, so
## this is safe to route all unparried incoming damage through.
static func mitigated_damage(base: int, mitigation: float) -> int:
	var frac: float = clampf(mitigation, 0.0, 1.0)
	return int(round(float(base) * (1.0 - frac)))

## The full incoming-damage resolution the FSM applies to a defender: a parry is a
## full block; otherwise Defend mitigation (if active) applies, else full damage.
## Extracted so the "reduced while defending / full otherwise" behaviour is testable.
static func resolve_incoming(base: int, parried: bool, is_defending: bool, mitigation: float) -> int:
	if parried:
		return 0
	return mitigated_damage(base, mitigation if is_defending else 0.0)
