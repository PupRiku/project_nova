class_name BattleStateMachine
extends Node
## Phase 1 turn flow as an explicit state machine (Combat Design §1), signals out,
## no nested ifs and no visual nodes referenced here. Fixed order: hero, then
## enemy, repeat. All pacing runs on accumulated `delta` seconds — frame-rate
## independent, never frame counts.
##
##   TURN_START -> PLAYER_INPUT -> PLAYER_PRESS -> PLAYER_RESOLVE ->
##   ENEMY_TELEGRAPH -> ENEMY_PARRY -> ENEMY_RESOLVE -> CHECK_END -> loop
##   (CHECK_END branches to VICTORY / DEFEAT on a KO.)

enum State {
	TURN_START,
	PLAYER_INPUT,
	PLAYER_PRESS,
	PLAYER_RESOLVE,
	ENEMY_TELEGRAPH,
	ENEMY_PARRY,
	ENEMY_RESOLVE,
	CHECK_END,
	VICTORY,
	DEFEAT,
}

enum WindowKind { OFFENSE, DEFENSE }

signal state_changed(from: int, to: int)
signal turn_started(actor_name: String)
signal prompt_changed(text: String)
signal window_opened(kind: int)
signal window_closed(kind: int)
## Everything the debug overlay needs to print real timing data. Times are ms on
## the window's local clock.
signal input_judged(kind: int, result: int, gap_ms: float, open_ms: float, close_ms: float, input_ms: float)
signal damage_dealt(target_name: String, amount: int, modified: bool)
signal hp_changed(combatant_name: String, hp: int, max_hp: int)
signal battle_ended(victor_name: String)

# --- Tuning data. Assign .tres in the Inspector; live-editable while running. ---
@export var hero_data: CombatantData
@export var enemy_data: CombatantData
@export var hero_move: MoveData
@export var enemy_attack: EnemyAttackData

## Pause after damage resolves so the result is readable (seconds). Tuning target.
@export var resolve_pause: float = 0.7

var _state: State = State.TURN_START
var _hero_hp: int = 0
var _enemy_hp: int = 0

var _window: TimingWindow = null
var _window_kind: WindowKind = WindowKind.OFFENSE
var _cue_played: bool = false

var _timer: float = 0.0            # generic pause accumulator for timed states
var _resolved_actor_is_hero: bool = false  # which side just acted, for CHECK_END

func start() -> void:
	_hero_hp = hero_data.max_hp
	_enemy_hp = enemy_data.max_hp
	hp_changed.emit(hero_data.display_name, _hero_hp, hero_data.max_hp)
	hp_changed.emit(enemy_data.display_name, _enemy_hp, enemy_data.max_hp)
	_set_state(State.TURN_START)

func _set_state(next: State) -> void:
	var prev := _state
	_state = next
	_timer = 0.0
	state_changed.emit(prev, next)
	_enter(next)

func _enter(s: State) -> void:
	match s:
		State.TURN_START:
			turn_started.emit(hero_data.display_name)
			_set_state(State.PLAYER_INPUT)
		State.PLAYER_INPUT:
			prompt_changed.emit("Your turn — press to ATTACK")
		State.PLAYER_PRESS:
			# Same button, two presses: the commit press got us here; now time
			# the SECOND press to the cue (Paper Mario: choose, then time).
			_begin_window(WindowKind.OFFENSE, hero_move.press)
			prompt_changed.emit("ATTACK — time your press!")
		State.PLAYER_RESOLVE:
			pass  # damage already applied at judge; this state is just the pause
		State.ENEMY_TELEGRAPH:
			turn_started.emit(enemy_data.display_name)
			prompt_changed.emit("%s winds up..." % enemy_data.display_name)
		State.ENEMY_PARRY:
			_begin_window(WindowKind.DEFENSE, enemy_attack.parry)
			prompt_changed.emit("PARRY!")
		State.ENEMY_RESOLVE:
			pass
		State.CHECK_END:
			_check_end()
		State.VICTORY:
			prompt_changed.emit("VICTORY")
			battle_ended.emit(hero_data.display_name)
		State.DEFEAT:
			prompt_changed.emit("DEFEAT")
			battle_ended.emit(enemy_data.display_name)

func _begin_window(kind: WindowKind, timing: ActionCommandTiming) -> void:
	# Read tuning values fresh here (not cached in _ready) so Inspector edits to
	# the .tres take effect on the very next window.
	_window_kind = kind
	_cue_played = false
	_window = TimingWindow.new(timing.window_open, timing.window_duration)

func _process(delta: float) -> void:
	match _state:
		State.PLAYER_PRESS, State.ENEMY_PARRY:
			_process_window(delta)
		State.ENEMY_TELEGRAPH:
			_timer += delta
			if _timer >= enemy_attack.telegraph_lead:
				_set_state(State.ENEMY_PARRY)
		State.PLAYER_RESOLVE:
			_timer += delta
			if _timer >= resolve_pause:
				_resolved_actor_is_hero = true
				_set_state(State.CHECK_END)
		State.ENEMY_RESOLVE:
			_timer += delta
			if _timer >= resolve_pause:
				_resolved_actor_is_hero = false
				_set_state(State.CHECK_END)
		_:
			pass

func _process_window(delta: float) -> void:
	_window.advance(delta)
	if not _cue_played and _window.is_open():
		_cue_played = true
		window_opened.emit(_window_kind)
	if not _window.is_judged() and _window.has_closed():
		window_closed.emit(_window_kind)
		_window.expire()
		_resolve_window()

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_action_command"):
		return
	match _state:
		State.PLAYER_INPUT:
			# Commit the attack. The NEXT press is the timed one.
			_set_state(State.PLAYER_PRESS)
		State.PLAYER_PRESS, State.ENEMY_PARRY:
			if _window != null and not _window.is_judged():
				_window.judge(_window.elapsed)
				_resolve_window()
		_:
			pass

func _resolve_window() -> void:
	var r := _window.result()
	input_judged.emit(
		_window_kind, r, _window.gap_ms(),
		_window.open_at * 1000.0, _window.close_at() * 1000.0, _window.input_at() * 1000.0
	)
	if _window_kind == WindowKind.OFFENSE:
		var success := r == TimingWindow.Result.HIT
		var dmg := CombatMath.attack_damage(hero_move.damage_base, success, hero_move.press_bonus_mult)
		_enemy_hp = maxi(0, _enemy_hp - dmg)
		damage_dealt.emit(enemy_data.display_name, dmg, success)
		hp_changed.emit(enemy_data.display_name, _enemy_hp, enemy_data.max_hp)
		_window = null
		_set_state(State.PLAYER_RESOLVE)
	else:
		var parried := r == TimingWindow.Result.HIT
		var dmg := CombatMath.incoming_damage(enemy_attack.damage_base, parried)
		_hero_hp = maxi(0, _hero_hp - dmg)
		damage_dealt.emit(hero_data.display_name, dmg, parried)
		hp_changed.emit(hero_data.display_name, _hero_hp, hero_data.max_hp)
		_window = null
		_set_state(State.ENEMY_RESOLVE)

func _check_end() -> void:
	if _enemy_hp <= 0:
		_set_state(State.VICTORY)
	elif _hero_hp <= 0:
		_set_state(State.DEFEAT)
	elif _resolved_actor_is_hero:
		_set_state(State.ENEMY_TELEGRAPH)
	else:
		_set_state(State.TURN_START)
