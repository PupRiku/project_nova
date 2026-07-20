class_name CombatantView
extends Control
## Placeholder-art view for one combatant: a coloured rectangle + name/HP labels,
## with an active-turn highlight. Zero art. Built in code so there's no scene file
## to hand-tune. The target cursor is drawn separately by Battle.

const BODY := Vector2(84, 62)
const FULL := Vector2(84, 96)

var _combatant: Combatant
var _outline: ColorRect
var _body: ColorRect
var _name_label: Label
var _hp_label: Label

func setup(c: Combatant) -> void:
	_combatant = c
	custom_minimum_size = FULL
	size = FULL
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	_outline = ColorRect.new()
	_outline.color = Color(1, 1, 0.3)  # yellow border = whose turn
	_outline.position = Vector2(-3, -3)
	_outline.size = BODY + Vector2(6, 6)
	_outline.visible = false
	_outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_outline)

	_body = ColorRect.new()
	_body.color = c.data.color
	_body.size = BODY
	_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_body)

	_name_label = Label.new()
	_name_label.text = c.display_name()
	_name_label.position = Vector2(0, BODY.y + 2)
	_name_label.size = Vector2(FULL.x, 14)
	add_child(_name_label)

	_hp_label = Label.new()
	_hp_label.position = Vector2(0, BODY.y + 16)
	_hp_label.size = Vector2(FULL.x, 14)
	add_child(_hp_label)
	set_hp(c.current_hp, c.data.max_hp)

func set_hp(hp: int, max_hp: int) -> void:
	_hp_label.text = "HP %d/%d" % [hp, max_hp]

func set_active(active: bool) -> void:
	_outline.visible = active

func set_dead(dead: bool) -> void:
	modulate = Color(0.35, 0.35, 0.35) if dead else Color.WHITE
