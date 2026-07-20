class_name TimingWindow
extends RefCounted
## One action-command timing window on a seconds-based clock (Combat Design §3.1
## offensive Press / §3.2 defensive Parry). Pure logic — knows nothing about the
## scene tree, so qa-test asserts against it directly.
##
## Frame-rate independent by construction: it only ever accumulates `delta`
## seconds via advance(); there is not a single frame count anywhere. The scene
## layer DRIVES this object; this object holds the rule.

enum Result { PENDING, HIT, MISS_EARLY, MISS_LATE, NO_INPUT }

## Seconds on the local clock until the window opens (also the wind-up beat).
var open_at: float = 0.0
## Seconds the window stays open once opened.
var duration: float = 0.0
## Accumulated seconds since this window started.
var elapsed: float = 0.0

var _judged: bool = false
var _result: int = Result.PENDING
var _input_at: float = -1.0

func _init(p_open_at: float, p_duration: float) -> void:
	open_at = maxf(0.0, p_open_at)
	duration = maxf(0.0, p_duration)

func close_at() -> float:
	return open_at + duration

func advance(delta: float) -> void:
	elapsed += delta

func is_open() -> bool:
	return elapsed >= open_at and elapsed <= close_at()

func has_closed() -> bool:
	return elapsed > close_at()

func is_judged() -> bool:
	return _judged

func result() -> int:
	return _result

func input_at() -> float:
	return _input_at

## Judge an input that landed at input_time (seconds on this window's clock).
## First judgement wins; later calls are ignored.
func judge(input_time: float) -> int:
	if _judged:
		return _result
	_input_at = input_time
	_judged = true
	if input_time < open_at:
		_result = Result.MISS_EARLY
	elif input_time > close_at():
		_result = Result.MISS_LATE
	else:
		_result = Result.HIT
	return _result

## Close the window with no input landed.
func expire() -> int:
	if _judged:
		return _result
	_judged = true
	_result = Result.NO_INPUT
	return _result

## Signed distance from the input to the window, in seconds: 0.0 inside the
## window, negative if early, positive if late. This is the "you were 40 ms
## early" number the debug overlay reads.
func gap_seconds() -> float:
	if _input_at < 0.0:
		return 0.0
	if _input_at < open_at:
		return _input_at - open_at
	if _input_at > close_at():
		return _input_at - close_at()
	return 0.0

func gap_ms() -> float:
	return gap_seconds() * 1000.0
