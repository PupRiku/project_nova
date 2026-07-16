class_name Battle
extends Node2D
## Phase 1 battle scene controller. Holds NO combat rules — it only wires the
## BattleStateMachine's signals to placeholder visuals, audio, and the debug
## overlay. Rules live in BattleStateMachine / TimingWindow / CombatMath.

@onready var _sm: BattleStateMachine = $StateMachine
@onready var _hero_hp_label: Label = $UI/HeroHP
@onready var _enemy_hp_label: Label = $UI/EnemyHP
@onready var _prompt: Label = $UI/Prompt
@onready var _beep: BeepPlayer = $Beep
@onready var _overlay: DebugOverlay = $UI/DebugOverlay

var _ended: bool = false

func _ready() -> void:
	_sm.hp_changed.connect(_on_hp_changed)
	_sm.prompt_changed.connect(_on_prompt_changed)
	_sm.window_opened.connect(_on_window_opened)
	_sm.input_judged.connect(_on_input_judged)
	_sm.battle_ended.connect(_on_battle_ended)
	_overlay.bind(_sm)
	_sm.start()

func _unhandled_input(event: InputEvent) -> void:
	# Fast tuning loop: once the fight is over, one press replays it instantly.
	if _ended and event.is_action_pressed("ui_action_command"):
		get_tree().reload_current_scene()

func _on_hp_changed(combatant_name: String, hp: int, max_hp: int) -> void:
	if combatant_name == _sm.hero_data.display_name:
		_hero_hp_label.text = "%s   HP %d/%d" % [combatant_name, hp, max_hp]
	else:
		_enemy_hp_label.text = "%s   HP %d/%d" % [combatant_name, hp, max_hp]

func _on_prompt_changed(text: String) -> void:
	_prompt.text = text

func _on_window_opened(_kind: int) -> void:
	_beep.play_cue()  # window-open beep — P5: read the window by ear

func _on_input_judged(_kind: int, result: int, _gap_ms: float, _open_ms: float, _close_ms: float, _input_ms: float) -> void:
	if result == TimingWindow.Result.HIT:
		_beep.play_success()
	else:
		_beep.play_fail()

func _on_battle_ended(_victor_name: String) -> void:
	_ended = true
	_prompt.text += "  —  press to retry"
