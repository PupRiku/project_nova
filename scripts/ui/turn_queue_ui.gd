class_name TurnQueueUI
extends Control
## Renders the FSM's turn order as a left-to-right strip of chips (Combat Design §1
## "the turn order must be visible"). A DUMB VIEW — it holds no ordering logic; it
## draws whatever order the FSM emits, reading the same list the FSM uses. When
## Phase 2B's Haste/Slow/Stop reorder that list, this redraws with zero changes here.

const CHIP := Vector2(76, 22)
const GAP := 6.0

## order: Array[Combatant] in turn order; current_index points at the active one.
func render(order: Array, current_index: int) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var x := 0.0
	for i in order.size():
		var c: Combatant = order[i]
		if not c.is_alive():
			continue  # dead combatants drop out of the visible queue
		var chip := ColorRect.new()
		chip.color = c.data.color
		chip.position = Vector2(x, 0)
		chip.size = CHIP
		chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(chip)
		var lbl := Label.new()
		lbl.text = c.display_name()
		lbl.position = Vector2(x + 3, 2)
		lbl.size = CHIP - Vector2(6, 4)
		add_child(lbl)
		if i == current_index:
			var mark := ColorRect.new()  # underline the combatant acting now
			mark.color = Color(1, 1, 0.3)
			mark.position = Vector2(x, CHIP.y + 1)
			mark.size = Vector2(CHIP.x, 4)
			mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
			add_child(mark)
		x += CHIP.x + GAP
