class_name BattleMenuUI
extends Control
## Renders the FSM's player-menu selection (categories or the move sub-list). A dumb
## view — the FSM owns the cursor state and options; this just draws labels and the
## ▶ cursor. Built in code; no scene wiring.

var _bg: ColorRect
var _title: Label
var _items: VBoxContainer

func _ready() -> void:
	_bg = ColorRect.new()
	_bg.color = Color(0, 0, 0, 0.65)
	_bg.size = Vector2(184, 150)
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)

	_title = Label.new()
	_title.position = Vector2(8, 6)
	_title.size = Vector2(168, 16)
	add_child(_title)

	_items = VBoxContainer.new()
	_items.position = Vector2(12, 28)
	add_child(_items)

	hide()

func render(labels: Array, index: int, title: String) -> void:
	show()
	_title.text = title
	for c in _items.get_children():
		_items.remove_child(c)
		c.queue_free()
	for i in labels.size():
		var lbl := Label.new()
		lbl.text = ("▶ " if i == index else "    ") + str(labels[i])
		_items.add_child(lbl)

func clear() -> void:
	hide()
