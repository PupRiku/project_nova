class_name TurnOrder
## Pure, unit-testable turn-order logic (Combat Design §1). No scene tree, no state —
## static functions over lists of `Combatant`. The FSM is the single source of truth
## for order; this just computes it, and the queue UI renders whatever the FSM holds.

## What the FSM should do after a turn resolves (Combat Design §1). The FSM only
## acts on this verdict — the decision itself lives here so it's unit-testable.
enum Advance { NEXT_TURN, NEW_ROUND, VICTORY, DEFEAT }

## Turn-start lifecycle hook, called by the FSM at TURN_START for the acting
## combatant. Today it clears Defend (mitigation lasts until the defender's OWN next
## turn — §2.1); Phase 2B's status ticks will land here too. Extracted so "Defend is
## cleared at the defender's next turn" is testable without driving the live FSM.
static func begin_turn(combatant) -> void:
	combatant.clear_defending()

## The FSM's post-turn routing decision, made pure: given the round's `order`, the
## index that just acted, and the full roster, return {advance, next_index}. Battle
## end is checked first; otherwise the next LIVING combatant after `current_index`
## (skipping any that died mid-round) — or NEW_ROUND if the round is exhausted.
## `next_index` is meaningful only for NEXT_TURN, and always points at a live actor.
static func resolve_turn_advance(order: Array, current_index: int, combatants: Array) -> Dictionary:
	var res := battle_result(combatants)
	if res.over:
		return {"advance": Advance.VICTORY if res.player_won else Advance.DEFEAT, "next_index": -1}
	var nxt := next_living_index(order, current_index + 1)
	if nxt == -1:
		return {"advance": Advance.NEW_ROUND, "next_index": -1}
	return {"advance": Advance.NEXT_TURN, "next_index": nxt}

## Sort combatants into turn order: **higher Speed first; ties → the party member;**
## then a stable tiebreak by `init_index` so the order is deterministic and readable
## (§1 "static, readable order"). Returns a new array; does not mutate the input.
static func sort_order(combatants: Array) -> Array:
	var ordered := combatants.duplicate()
	var cmp := func(a, b):
		if a.speed() != b.speed():
			return a.speed() > b.speed()      # higher speed acts first
		if a.is_player != b.is_player:
			return a.is_player                # tie → party member
		return a.init_index < b.init_index    # deterministic final tiebreak
	ordered.sort_custom(cmp)
	return ordered

## Index of the next living combatant at or after `from`, or -1 if none remain
## (i.e. the round is over). Skips the dead.
static func next_living_index(order: Array, from: int) -> int:
	for i in range(from, order.size()):
		if order[i].is_alive():
			return i
	return -1

## Living combatants on the requested side — the valid targets for single-target
## moves (enemies for an attack, allies for a support move).
static func living_targets(combatants: Array, want_player_side: bool) -> Array:
	var out: Array = []
	for c in combatants:
		if c.is_alive() and c.is_player == want_player_side:
			out.append(c)
	return out

## {over, player_won}. The battle ends when one whole side is down. A simultaneous
## wipe counts as defeat (player_won only if the party still stands).
static func battle_result(combatants: Array) -> Dictionary:
	var players_alive := false
	var enemies_alive := false
	for c in combatants:
		if c.is_alive():
			if c.is_player:
				players_alive = true
			else:
				enemies_alive = true
	return {
		"over": not (players_alive and enemies_alive),
		"player_won": players_alive and not enemies_alive,
	}
