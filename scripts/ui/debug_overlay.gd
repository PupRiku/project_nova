class_name DebugOverlay
extends Control
## Phase 1's measurement instrument. Reads real timing data off the state machine
## and prints it so tuning is "you were 40 ms early", never a guess. Not polish —
## the exit criterion is "feel", and feel can't be tuned blind.

@export var max_lines: int = 8
@onready var _label: Label = $Log

var _lines: Array[String] = []

func bind(sm: BattleStateMachine) -> void:
	sm.input_judged.connect(_on_input_judged)

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
	_push("%-7s  %-8s  %s" % [kind_txt, res_txt, detail])

func _push(line: String) -> void:
	_lines.append(line)
	while _lines.size() > max_lines:
		_lines.pop_front()
	_label.text = "\n".join(_lines)
