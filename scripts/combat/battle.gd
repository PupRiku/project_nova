class_name Battle
extends Node2D
## Phase 2A battle controller. Owns NO combat rules — it wires the FSM's signals to
## placeholder views, audio, the turn-queue strip, the menu, and the target cursor,
## and spawns one view per combatant from the encounter. Rules live in
## BattleStateMachine / TurnOrder / TimingWindow / CombatMath.

const PARTY_ORIGIN := Vector2(30, 190)
const ENEMY_ORIGIN := Vector2(372, 58)
const VIEW_STRIDE := 98.0

@onready var _sm: BattleStateMachine = $StateMachine
@onready var _combatants_root: Control = $UI/Combatants
@onready var _queue: TurnQueueUI = $UI/QueueUI
@onready var _menu: BattleMenuUI = $UI/MenuUI
@onready var _prompt: Label = $UI/Prompt
@onready var _overlay: DebugOverlay = $UI/DebugOverlay
@onready var _beep: BeepPlayer = $Beep
@onready var _cursor: Label = $UI/TargetCursor

var _views: Dictionary = {}   # Combatant -> CombatantView
var _ended: bool = false

func _ready() -> void:
	_sm.battle_setup.connect(_on_battle_setup)
	_sm.hp_changed.connect(_on_hp_changed)
	_sm.turn_started.connect(_on_turn_started)
	_sm.turn_order_changed.connect(_on_turn_order_changed)
	_sm.prompt_changed.connect(_on_prompt_changed)
	_sm.menu_changed.connect(_on_menu_changed)
	_sm.target_changed.connect(_on_target_changed)
	_sm.selection_cleared.connect(_on_selection_cleared)
	_sm.window_opened.connect(_on_window_opened)
	_sm.input_judged.connect(_on_input_judged)
	_sm.combatant_died.connect(_on_combatant_died)
	_sm.battle_ended.connect(_on_battle_ended)
	_overlay.bind(_sm)
	_cursor.hide()
	_sm.start()

func _on_battle_setup(combatants: Array) -> void:
	var party_i := 0
	var enemy_i := 0
	for c in combatants:
		var view := CombatantView.new()
		_combatants_root.add_child(view)
		view.setup(c)
		if c.is_player:
			view.position = PARTY_ORIGIN + Vector2(VIEW_STRIDE * party_i, 0.0)
			party_i += 1
		else:
			view.position = ENEMY_ORIGIN + Vector2(VIEW_STRIDE * enemy_i, 0.0)
			enemy_i += 1
		_views[c] = view

func _on_hp_changed(c: Combatant, hp: int, max_hp: int) -> void:
	if _views.has(c):
		_views[c].set_hp(hp, max_hp)

func _on_turn_started(c: Combatant) -> void:
	for other in _views:
		_views[other].set_active(other == c)
	_cursor.hide()

func _on_turn_order_changed(order: Array, index: int) -> void:
	_queue.render(order, index)

func _on_prompt_changed(text: String) -> void:
	_prompt.text = text

func _on_menu_changed(labels: Array, index: int, title: String) -> void:
	_cursor.hide()
	_menu.render(labels, index, title)

func _on_target_changed(candidates: Array, index: int) -> void:
	_menu.clear()
	var c: Combatant = candidates[index]
	if _views.has(c):
		var v: CombatantView = _views[c]
		_cursor.position = v.position + Vector2(30.0, -20.0)
		_cursor.show()

func _on_selection_cleared() -> void:
	_menu.clear()
	_cursor.hide()

func _on_window_opened(_kind: int) -> void:
	_beep.play_cue()  # window-open beep — P5: read the window by ear

func _on_input_judged(_kind: int, result: int, _gap: float, _open: float, _close: float, _in: float) -> void:
	if result == TimingWindow.Result.HIT:
		_beep.play_success()
	else:
		_beep.play_fail()

func _on_combatant_died(c: Combatant) -> void:
	if _views.has(c):
		_views[c].set_dead(true)
		_views[c].set_active(false)

func _on_battle_ended(_player_won: bool) -> void:
	_ended = true
	_prompt.text += "  —  press to retry"

func _unhandled_input(event: InputEvent) -> void:
	# Fast tuning loop: once the fight is over, one press replays it.
	if _ended and (event.is_action_pressed("ui_action_command") or event.is_action_pressed("ui_accept")):
		get_tree().reload_current_scene()
