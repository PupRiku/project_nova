class_name BattleStateMachine
extends Node
## Phase 2A turn flow (Combat Design §1). Generalises Phase 1's two hard-coded
## actors into a **turn loop over an ordered list of `Combatant`s**. The offensive
## Press and the defensive parry are reused verbatim from Phase 1 — only the loop
## around them is new. Signals out; no visual nodes referenced here. Frame-rate
## independent: all pacing runs on accumulated `delta` seconds.
##
##   start → ROUND_START → TURN_START ─┬─(player) PLAYER_MENU → PLAYER_TARGET ─┐
##                                     └─(AI)     ENEMY_THINK → ENEMY_TELEGRAPH │
##   (player) → PLAYER_ACTION_PRESS ───────────────────────────────────────────┤
##   (AI)     → ENEMY_PARRY ────────────────────────────────────────────────────┤
##                                                          RESOLVE → CHECK_END ─┘
##   CHECK_END → next TURN_START / new ROUND_START / VICTORY / DEFEAT

enum State {
	ROUND_START,
	TURN_START,
	PLAYER_MENU,
	PLAYER_TARGET,
	PLAYER_ACTION_PRESS,
	ENEMY_THINK,
	ENEMY_TELEGRAPH,
	ENEMY_PARRY,
	RESOLVE,
	CHECK_END,
	VICTORY,
	DEFEAT,
}

enum WindowKind { OFFENSE, DEFENSE }

const CATEGORY_NAMES := ["Attack", "Magic", "Skills", "Item", "Defend"]

signal battle_setup(combatants: Array)
signal turn_order_changed(order: Array, current_index: int)
signal turn_started(combatant: Combatant)
signal prompt_changed(text: String)
signal menu_changed(labels: Array, index: int, title: String)
signal target_changed(candidates: Array, index: int)
signal selection_cleared()
signal window_opened(kind: int)
signal window_closed(kind: int)
signal input_judged(kind: int, result: int, gap_ms: float, open_ms: float, close_ms: float, input_ms: float)
signal damage_dealt(target: Combatant, amount: int, modified: bool)
signal healed(target: Combatant, amount: int)
signal hp_changed(combatant: Combatant, hp: int, max_hp: int)
signal combatant_died(combatant: Combatant)
signal battle_ended(player_won: bool)

## The fielded party + enemies. Party size = encounter.party.size() — the Phase 2A
## tunable. Assign a .tres in the Inspector; live-editable between battles.
@export var encounter: EncounterData
## Pause after an action resolves so the result is readable (seconds). Tuning target.
@export var resolve_pause: float = 0.7

var _state: State = State.ROUND_START
var _combatants: Array = []          # all, both sides (runtime Combatants)
var _order: Array = []               # this round's turn order (source of truth for the queue UI)
var _turn_index: int = 0
var _current: Combatant = null

# --- Player selection state (the FSM owns it; the UI just renders) ---
var _menu_level: int = 0             # 0 = categories, 1 = moves within a category
var _menu_categories: Array = []     # Category ids present for _current
var _menu_moves: Array = []          # MoveData in the chosen category
var _menu_index: int = 0
var _menu_index_cat: int = 0         # category index backing the current sub-list title
var _target_candidates: Array = []
var _target_index: int = 0
var _chosen_move: MoveData = null

# --- Timing window (reused from Phase 1) ---
var _window: TimingWindow = null
var _window_kind: int = WindowKind.OFFENSE
var _cue_played: bool = false

# --- Pending action, read by RESOLVE ---
var _pending_move = null             # MoveData (player) or EnemyAttackData (enemy)
var _pending_target: Combatant = null
var _pending_success: bool = false   # press landed / attack parried
var _pending_is_enemy: bool = false

var _timer: float = 0.0

# ---------------------------------------------------------------- lifecycle
func start() -> void:
	_build_combatants()
	battle_setup.emit(_combatants)
	for c in _combatants:
		hp_changed.emit(c, c.current_hp, c.data.max_hp)
	_set_state(State.ROUND_START)

func _build_combatants() -> void:
	_combatants.clear()
	var idx := 0
	for cd in encounter.party:
		_combatants.append(Combatant.new(cd, true, idx))
		idx += 1
	for cd in encounter.enemies:
		_combatants.append(Combatant.new(cd, false, idx))
		idx += 1

func get_combatants() -> Array:
	return _combatants

# ---------------------------------------------------------------- state machine
func _set_state(next: State) -> void:
	_state = next
	_timer = 0.0
	_enter(next)

func _enter(s: State) -> void:
	match s:
		State.ROUND_START:
			var living: Array = TurnOrder.living_targets(_combatants, true) + TurnOrder.living_targets(_combatants, false)
			_order = TurnOrder.sort_order(living)
			_turn_index = TurnOrder.next_living_index(_order, 0)
			turn_order_changed.emit(_order, _turn_index)
			_set_state(State.TURN_START)
		State.TURN_START:
			_current = _order[_turn_index]
			TurnOrder.begin_turn(_current)  # clears Defend — mitigation lasted until this, its next turn
			turn_started.emit(_current)
			turn_order_changed.emit(_order, _turn_index)
			if _current.is_player:
				_set_state(State.PLAYER_MENU)
			else:
				_set_state(State.ENEMY_THINK)
		State.PLAYER_MENU:
			_open_category_menu()
		State.PLAYER_TARGET:
			target_changed.emit(_target_candidates, _target_index)
			prompt_changed.emit("Choose a target")
		State.PLAYER_ACTION_PRESS:
			selection_cleared.emit()
			_begin_window(WindowKind.OFFENSE, _chosen_move.press)
			prompt_changed.emit("%s — time your press!" % _chosen_move.display_name)
		State.ENEMY_THINK:
			_enemy_choose_action()
		State.ENEMY_TELEGRAPH:
			prompt_changed.emit("%s winds up on %s..." % [_current.display_name(), _pending_target.display_name()])
		State.ENEMY_PARRY:
			_begin_window(WindowKind.DEFENSE, _pending_move.parry)
			prompt_changed.emit("PARRY! (%s)" % _pending_target.display_name())
		State.RESOLVE:
			_apply_pending()
		State.CHECK_END:
			_check_end()
		State.VICTORY:
			prompt_changed.emit("VICTORY")
			battle_ended.emit(true)
		State.DEFEAT:
			prompt_changed.emit("DEFEAT")
			battle_ended.emit(false)

func _process(delta: float) -> void:
	match _state:
		State.PLAYER_ACTION_PRESS, State.ENEMY_PARRY:
			_process_window(delta)
		State.ENEMY_TELEGRAPH:
			_timer += delta
			if _timer >= _pending_move.telegraph_lead:
				_set_state(State.ENEMY_PARRY)
		State.RESOLVE:
			_timer += delta
			if _timer >= resolve_pause:
				_set_state(State.CHECK_END)
		_:
			pass

# ---------------------------------------------------------------- player menu
func _open_category_menu() -> void:
	_menu_level = 0
	_menu_categories = _categories_for(_current)
	_menu_index = 0
	_emit_menu()

func _categories_for(c: Combatant) -> Array:
	var cats: Array = []
	for m in c.data.moves:
		if not cats.has(m.category):
			cats.append(m.category)
	cats.sort()  # enum order: Attack, Magic, Skills, Item, Defend
	return cats

func _moves_in_category(c: Combatant, cat: int) -> Array:
	var out: Array = []
	for m in c.data.moves:
		if m.category == cat:
			out.append(m)
	return out

func _emit_menu() -> void:
	var labels: Array = []
	var title := ""
	if _menu_level == 0:
		for cat in _menu_categories:
			labels.append(CATEGORY_NAMES[cat])
		title = "%s — choose action" % _current.display_name()
	else:
		for m in _menu_moves:
			labels.append(m.display_name)
		title = CATEGORY_NAMES[_menu_categories[_menu_index_cat]]
	menu_changed.emit(labels, _menu_index, title)

func _menu_input(event: InputEvent) -> void:
	var count := _menu_categories.size() if _menu_level == 0 else _menu_moves.size()
	if count == 0:
		return
	if event.is_action_pressed("ui_down"):
		_menu_index = (_menu_index + 1) % count
		_emit_menu()
	elif event.is_action_pressed("ui_up"):
		_menu_index = (_menu_index - 1 + count) % count
		_emit_menu()
	elif event.is_action_pressed("ui_accept"):
		_menu_confirm()
	elif event.is_action_pressed("ui_cancel"):
		if _menu_level == 1:
			_menu_level = 0
			_menu_index = 0
			_emit_menu()

func _menu_confirm() -> void:
	if _menu_level == 0:
		var cat: int = _menu_categories[_menu_index]
		var moves := _moves_in_category(_current, cat)
		if moves.size() == 1:
			_choose_move(moves[0])
		else:
			_menu_index_cat = _menu_index
			_menu_level = 1
			_menu_moves = moves
			_menu_index = 0
			_emit_menu()
	else:
		_choose_move(_menu_moves[_menu_index])

func _choose_move(m: MoveData) -> void:
	_chosen_move = m
	match m.target:
		MoveData.Target.SELF:
			_pending_target = _current
			_commit_player_action()
		MoveData.Target.SINGLE_ENEMY:
			_target_candidates = TurnOrder.living_targets(_combatants, false)
			_target_index = 0
			_set_state(State.PLAYER_TARGET)
		MoveData.Target.SINGLE_ALLY:
			_target_candidates = TurnOrder.living_targets(_combatants, true)
			_target_index = 0
			_set_state(State.PLAYER_TARGET)

func _target_input(event: InputEvent) -> void:
	var count := _target_candidates.size()
	if count == 0:
		return
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
		_target_index = (_target_index + 1) % count
		target_changed.emit(_target_candidates, _target_index)
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
		_target_index = (_target_index - 1 + count) % count
		target_changed.emit(_target_candidates, _target_index)
	elif event.is_action_pressed("ui_accept"):
		_pending_target = _target_candidates[_target_index]
		_commit_player_action()
	elif event.is_action_pressed("ui_cancel"):
		selection_cleared.emit()
		_set_state(State.PLAYER_MENU)

func _commit_player_action() -> void:
	_pending_move = _chosen_move
	_pending_is_enemy = false
	_pending_success = false
	if _chosen_move.uses_press and _chosen_move.press != null:
		_set_state(State.PLAYER_ACTION_PRESS)
	else:
		selection_cleared.emit()
		_set_state(State.RESOLVE)

# ---------------------------------------------------------------- enemy turn
func _enemy_choose_action() -> void:
	_pending_is_enemy = true
	_pending_move = _current.data.enemy_attacks.pick_random()
	_pending_target = TurnOrder.living_targets(_combatants, true).pick_random()
	_pending_success = false
	_set_state(State.ENEMY_TELEGRAPH)

# ---------------------------------------------------------------- timing window (Phase 1 reuse)
func _begin_window(kind: int, timing: ActionCommandTiming) -> void:
	_window_kind = kind
	_cue_played = false
	_window = TimingWindow.new(timing.window_open, timing.window_duration)

func _process_window(delta: float) -> void:
	_window.advance(delta)
	if not _cue_played and _window.is_open():
		_cue_played = true
		window_opened.emit(_window_kind)
	if not _window.is_judged() and _window.has_closed():
		window_closed.emit(_window_kind)
		_window.expire()
		_resolve_window()

func _resolve_window() -> void:
	var r := _window.result()
	input_judged.emit(
		_window_kind, r, _window.gap_ms(),
		_window.open_at * 1000.0, _window.close_at() * 1000.0, _window.input_at() * 1000.0
	)
	_pending_success = r == TimingWindow.Result.HIT
	_window = null
	_set_state(State.RESOLVE)

func _unhandled_input(event: InputEvent) -> void:
	match _state:
		State.PLAYER_MENU:
			_menu_input(event)
		State.PLAYER_TARGET:
			_target_input(event)
		State.PLAYER_ACTION_PRESS, State.ENEMY_PARRY:
			if event.is_action_pressed("ui_action_command") and _window != null and not _window.is_judged():
				_window.judge(_window.elapsed)
				_resolve_window()
		_:
			pass

# ---------------------------------------------------------------- resolve & end
func _apply_pending() -> void:
	if _pending_is_enemy:
		_apply_enemy_attack()
	else:
		_apply_player_move()

func _apply_enemy_attack() -> void:
	var atk = _pending_move  # EnemyAttackData
	var parried := _pending_success
	var dmg := CombatMath.resolve_incoming(
		atk.damage_base, parried, _pending_target.is_defending, _pending_target.mitigation)
	_damage(_pending_target, dmg, parried)

func _apply_player_move() -> void:
	var mv: MoveData = _pending_move
	match mv.effect:
		MoveData.Effect.DAMAGE:
			var dmg := CombatMath.attack_damage(mv.damage_base, _pending_success, mv.press_bonus_mult)
			_damage(_pending_target, dmg, _pending_success)
		MoveData.Effect.HEAL:
			var amt := CombatMath.attack_damage(mv.damage_base, _pending_success, mv.press_bonus_mult)
			_pending_target.heal(amt)
			healed.emit(_pending_target, amt)
			hp_changed.emit(_pending_target, _pending_target.current_hp, _pending_target.data.max_hp)
		MoveData.Effect.DEFEND:
			_pending_target.begin_defending(mv.mitigation)
			prompt_changed.emit("%s defends" % _pending_target.display_name())

func _damage(target: Combatant, amount: int, modified: bool) -> void:
	var was_alive := target.is_alive()
	target.take_damage(amount)
	damage_dealt.emit(target, amount, modified)
	hp_changed.emit(target, target.current_hp, target.data.max_hp)
	if was_alive and not target.is_alive():
		combatant_died.emit(target)
		turn_order_changed.emit(_order, _turn_index)

func _check_end() -> void:
	# The routing decision is pure (TurnOrder.resolve_turn_advance) and unit-tested;
	# the FSM only enacts its verdict.
	var step := TurnOrder.resolve_turn_advance(_order, _turn_index, _combatants)
	match step.advance:
		TurnOrder.Advance.VICTORY:
			_set_state(State.VICTORY)
		TurnOrder.Advance.DEFEAT:
			_set_state(State.DEFEAT)
		TurnOrder.Advance.NEW_ROUND:
			_set_state(State.ROUND_START)
		TurnOrder.Advance.NEXT_TURN:
			_turn_index = step.next_index
			_set_state(State.TURN_START)
