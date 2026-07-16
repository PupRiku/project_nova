extends GutTest
## Behaviour, NOT values. Every window here is built with arbitrary numbers and
## we assert relationships (in-window hits, early misses, frame-rate independence).
## The real timing values live in Combat Design and will change constantly in
## Phase 1 — these tests must not care what they are.

func test_press_inside_window_is_hit() -> void:
	var w := TimingWindow.new(0.5, 0.2)  # opens at 0.5s, open for 0.2s
	w.advance(0.6)                       # 0.6 is inside [0.5, 0.7]
	assert_eq(w.judge(w.elapsed), TimingWindow.Result.HIT)

func test_press_before_open_is_early_miss() -> void:
	var w := TimingWindow.new(0.5, 0.2)
	assert_eq(w.judge(0.3), TimingWindow.Result.MISS_EARLY)

func test_press_after_close_is_late_miss() -> void:
	var w := TimingWindow.new(0.5, 0.2)
	assert_eq(w.judge(0.9), TimingWindow.Result.MISS_LATE)

func test_no_press_expires_as_no_input() -> void:
	var w := TimingWindow.new(0.5, 0.2)
	w.advance(1.0)
	assert_true(w.has_closed(), "window should have closed by 1.0s")
	assert_eq(w.expire(), TimingWindow.Result.NO_INPUT)

func test_first_judgement_wins() -> void:
	var w := TimingWindow.new(0.5, 0.2)
	w.judge(0.6)                         # HIT
	assert_eq(w.judge(0.9), TimingWindow.Result.HIT, "a second input must not overwrite the first")

func test_frame_rate_independent_open_state() -> void:
	# Many tiny advances must land on the same window state as one big advance.
	var coarse := TimingWindow.new(0.5, 0.2)
	coarse.advance(0.6)
	var fine := TimingWindow.new(0.5, 0.2)
	for i in 60:
		fine.advance(0.01)               # 60 * 0.01 == 0.6
	assert_eq(fine.is_open(), coarse.is_open())
	assert_true(fine.is_open(), "0.6s should be inside [0.5, 0.7]")

func test_gap_sign_early_negative_late_positive() -> void:
	var early := TimingWindow.new(0.5, 0.2)
	early.judge(0.4)
	assert_lt(early.gap_ms(), 0.0, "an early press reads as negative ms")
	var late := TimingWindow.new(0.5, 0.2)
	late.judge(0.8)
	assert_gt(late.gap_ms(), 0.0, "a late press reads as positive ms")

func test_gap_is_zero_inside_window() -> void:
	var w := TimingWindow.new(0.5, 0.2)
	w.judge(0.6)
	assert_almost_eq(w.gap_ms(), 0.0, 0.001)
