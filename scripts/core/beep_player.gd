class_name BeepPlayer
extends AudioStreamPlayer
## Placeholder procedural beeps — no binary assets, nothing for Git LFS. Three
## distinct pitches so the timing windows can be read BY EAR as well as by sight:
## Pillar P5 says players parry by sound, so a cue with audio is Phase 1 scope,
## not polish. Tones are baked once at _ready as short 16-bit PCM.

@export var cue_hz: float = 660.0      # window opens
@export var success_hz: float = 990.0  # HIT
@export var fail_hz: float = 220.0     # miss
@export var beep_seconds: float = 0.09
@export var volume: float = 0.4

var _cue: AudioStreamWAV
var _success: AudioStreamWAV
var _fail: AudioStreamWAV

func _ready() -> void:
	_cue = _make_tone(cue_hz, beep_seconds)
	_success = _make_tone(success_hz, beep_seconds)
	_fail = _make_tone(fail_hz, beep_seconds)

func play_cue() -> void:
	_play(_cue)

func play_success() -> void:
	_play(_success)

func play_fail() -> void:
	_play(_fail)

func _play(s: AudioStreamWAV) -> void:
	stream = s
	play()

func _make_tone(freq: float, duration: float) -> AudioStreamWAV:
	var rate := 22050
	var count := int(rate * duration)
	var data := PackedByteArray()
	data.resize(count * 2)  # 16-bit mono
	for i in count:
		var env := 1.0 - float(i) / float(count)  # quick linear decay, no click on release
		var s := sin(TAU * freq * float(i) / float(rate)) * volume * env
		data.encode_s16(i * 2, int(clampf(s, -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = data
	return wav
