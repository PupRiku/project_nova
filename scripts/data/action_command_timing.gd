class_name ActionCommandTiming
extends Resource
## A reusable timing-window spec drawn from the §3.0 vocabulary (Phase 1 uses
## type #1 "Press" and the §3.2 parry). This is pure TUNING DATA — per Combat
## Design, every value here is a Phase 1 target, not a decision. Editable in the
## Inspector, including live while the scene runs (open the .tres and scrub).

## Seconds from the window's local clock start until it OPENS. Doubles as the
## wind-up / anticipation beat before the cue fires. Tuning target.
@export var window_open: float = 0.6

## Seconds the window stays open once it has opened. Smaller = harder. Tuning
## target.
@export var window_duration: float = 0.25
