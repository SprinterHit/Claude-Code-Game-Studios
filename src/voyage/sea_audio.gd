class_name SeaAudio
extends Node
## Wind, water, a touch click, and a short note when the ship lands.
## Streams are generated here so the chart does not depend on imported audio files.


var _wind: AudioStreamPlayer
var _water: AudioStreamPlayer
var _aim: AudioStreamPlayer
var _landing: AudioStreamPlayer
var _miss: AudioStreamPlayer


func _ready() -> void:
	_wind = _loop(_air_bed(1.8), -18.0)
	_water = _loop(_water_bed(1.8), -22.0)
	_aim = _one_shot(_tone(740.0, 0.045, 0.22))
	_landing = _one_shot(_chime())
	_miss = _one_shot(_tone(196.0, 0.22, 0.28))
	_wind.play()
	_water.play()


func play_aim() -> void:
	_aim.play()


func play_landing() -> void:
	_landing.play()


func play_miss() -> void:
	_miss.play()


func _loop(stream: AudioStreamWAV, volume_db: float) -> AudioStreamPlayer:
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = stream.data.size() / 2
	return _player(stream, volume_db)


func _one_shot(stream: AudioStreamWAV) -> AudioStreamPlayer:
	return _player(stream, -8.0)


func _player(stream: AudioStreamWAV, volume_db: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	add_child(player)
	return player


func _air_bed(seconds: float) -> AudioStreamWAV:
	var rate := 22050
	var count := int(float(rate) * seconds)
	var samples := PackedFloat32Array()
	samples.resize(count)
	var held := 0.0
	var current := 0.0
	for index: int in count:
		if index % 80 == 0:
			held = randf_range(-1.0, 1.0)
		current = lerpf(current, held, 0.04)
		var breeze := sin(TAU * 0.37 * float(index) / float(rate))
		samples[index] = (current * 0.55 + breeze * 0.2) * 0.35
	return _wav(samples, rate)


func _water_bed(seconds: float) -> AudioStreamWAV:
	var rate := 22050
	var count := int(float(rate) * seconds)
	var samples := PackedFloat32Array()
	samples.resize(count)
	var current := 0.0
	for index: int in count:
		var time := float(index) / float(rate)
		current = lerpf(current, randf_range(-1.0, 1.0), 0.015)
		var swell := sin(TAU * 0.18 * time) * 0.25
		samples[index] = (current * 0.18 + swell) * 0.4
	return _wav(samples, rate)


func _chime() -> AudioStreamWAV:
	var rate := 22050
	var first := _tone_samples(523.0, 0.16, 0.4, rate)
	var second := _tone_samples(784.0, 0.22, 0.34, rate)
	var samples := PackedFloat32Array()
	samples.resize(first.size() + second.size())
	for index: int in first.size():
		samples[index] = first[index]
	for index: int in second.size():
		samples[first.size() + index] = second[index]
	return _wav(samples, rate)


func _tone(frequency: float, seconds: float, volume: float) -> AudioStreamWAV:
	return _wav(_tone_samples(frequency, seconds, volume, 22050), 22050)


func _tone_samples(frequency: float, seconds: float, volume: float, rate: int) -> PackedFloat32Array:
	var count := maxi(int(float(rate) * seconds), 1)
	var samples := PackedFloat32Array()
	samples.resize(count)
	for index: int in count:
		var time := float(index) / float(rate)
		var envelope := 1.0 - time / seconds
		samples[index] = sin(TAU * frequency * time) * volume * envelope
	return samples


func _wav(samples: PackedFloat32Array, rate: int) -> AudioStreamWAV:
	var data := PackedByteArray()
	data.resize(samples.size() * 2)
	for index: int in samples.size():
		var unit := clampf(samples[index], -1.0, 1.0)
		data.encode_s16(index * 2, int(unit * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.stereo = false
	stream.data = data
	return stream
