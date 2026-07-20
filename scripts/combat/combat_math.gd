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
