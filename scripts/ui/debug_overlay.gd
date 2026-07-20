class_name DebugOverlay
extends Control
## Phase 1's timing instrument, extended for Phase 2A turn/target readout. Reads real
## data off the FSM — "you were 40 ms early" and "whose turn / which target", not a
## guess. Self-builds its labels in code.

@export var max_lines: int = 6

var _status: Label
var _log: Label
var _lines: Array[String] = []
var _turn_txt: String = "—"
var _target_txt: String = "—"

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.5)
	bg.size = Vector2(608, 66)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	_status = Label.new()
	_status.position = Vector2(6, 2)
	_status.add_theme_color_override("font_color", Color(0.6, 1, 0.6))
	add_child(_status)
	_log = Label.new()
	_log.position = Vector2(6, 20)
	_log.add_theme_color_override("font_color", Color(0.6, 1, 0.6))
	add_child(_log)
	_refresh_status()

func bind(sm: BattleStateMachine) -> void:
	sm.input_judged.connect(_on_input_judged)
	sm.turn_started.connect(_on_turn_started)
	sm.target_changed.connect(_on_target_changed)

func _on_turn_started(c: Combatant) -> void:
	_turn_txt = "%s (%s, spd %d)" % [c.display_name(), "player" if c.is_player else "enemy", c.speed()]
	_target_txt = "—"
	_refresh_status()

func _on_target_changed(candidates: Array, index: int) -> void:
	_target_txt = candidates[index].display_name()
	_refresh_status()

func _refresh_status() -> void:
	_status.text = "TURN: %s     TARGET: %s" % [_turn_txt, _target_txt]

func _on_input_judged(kind: int, result: int, gap_ms: float, open_ms: float, close_ms: float, input_ms: float) -> void:
	var kind_txt := "OFFENSE" if kind == BattleStateMachine.WindowKind.OFFENSE else "DEFENSE"
	var res_txt: String = ["PENDING", "HIT", "EARLY", "LATE", "NO-INPUT"][result]
	var detail := ""
	if result == TimingWindow.Result.NO_INPUT:
		detail = "no press  win[%.0f-%.0f]ms" % [open_ms, close_ms]
	else:
		var when := "in-window" if is_zero_approx(gap_ms) \
			else ("%+.0f ms %s" % [gap_ms, "early" if gap_ms < 0.0 else "late"])
		detail = "in %.0f  win[%.0f-%.0f]ms  %s" % [input_ms, open_ms, close_ms, when]
	_push("%-7s %-8s %s" % [kind_txt, res_txt, detail])

func _push(line: String) -> void:
	_lines.append(line)
	while _lines.size() > max_lines:
		_lines.pop_front()
	_log.text = "\n".join(_lines)
