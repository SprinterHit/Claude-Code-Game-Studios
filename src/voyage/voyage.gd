class_name Voyage
extends Node2D
## One voyage on this chart. It can be sailed again. It does not open another shore.


const SAILING := "sailing"
const LANDED := "landed"
const MISSED := "missed"
const SUPPLY_FAILED := "supply_failed"

const TRACK_STEP := 0.22
const TRACK_SAMPLES := 14
const CHART_FRAME := Rect2(-2400, -1700, 4800, 3400)
const CHART_REVEAL := 64.0

var outcome: String = SAILING

var _ship: Ship
var _wind: WindField
var _current: CurrentBand
var _coast: Coast
var _supply: SupplyStore
var _geography: GeographyLine
var _outcome_line: Label
var _outcome_card: Panel
var _again: Button
var _hint: Label
var _hint_card: Panel
var _track: Line2D
var _track_glow: Line2D
var _camera: Camera2D
var _audio: SeaAudio
var _screen: Control
var _departure: Vector2 = Vector2.ZERO
var _land_seen: bool = false
var _hint_used: bool = false
var _hint_time: float = 0.0
var _aim_cooldown: float = 0.0


func _ready() -> void:
	_ship = get_node("Ship") as Ship
	_camera = _ship.get_node("Camera2D") as Camera2D
	_departure = _ship.global_position
	_ship.heading_changed.connect(_on_heading_changed)
	_build_chart()
	_apply_launch_pose()
	if outcome != SAILING:
		_set_hint_shown(false)
		_set_track_shown(false)


func _process(delta: float) -> void:
	_aim_cooldown = maxf(0.0, _aim_cooldown - delta)
	_place_hint(delta)
	_draw_track()


func _physics_process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	if outcome != SAILING:
		return
	if not _wind.shifted and _ship.global_position.x <= _wind.shift_x:
		_wind.shift()
	_ship.wind_push = _wind.vector_at(_ship.global_position)
	_ship.current_push = _current.vector_at(_ship.global_position)
	_ship.integrate(delta)
	_keep_ship_on_the_chart()
	_supply.tick(delta)
	_draw_track()
	var view := _view_rect()
	var coast_visible := _coast.intersects_view(view)
	if coast_visible:
		_land_seen = true
	var coast_state := _coast.evaluate(_ship.global_position)
	if coast_state == Coast.LANDED:
		_finish_landed()
	elif coast_state == Coast.PASSED and coast_visible:
		_finish_missed()
	elif _supply.is_empty() and not _land_seen:
		_finish_supply()


func restart() -> void:
	outcome = SAILING
	_land_seen = false
	_wind.reset()
	_coast.conceal()
	_supply.refill()
	_geography.visible = false
	_set_outcome_shown(false)
	_hide_again()
	_ship.resume_sailing()
	_ship.global_position = _departure
	_ship.heading = _ship.initial_heading
	_ship.wind_push = Vector2.ZERO
	_ship.current_push = Vector2.ZERO
	_ship.clear_wake()
	_hint_used = false
	_hint_time = 0.0
	_hint.modulate = Color(1, 1, 1, 1)
	_set_hint_shown(true)
	_set_track_shown(true)


func wind_field() -> WindField:
	return _wind


func current_band() -> CurrentBand:
	return _current


func coast() -> Coast:
	return _coast


func supply() -> SupplyStore:
	return _supply


func geography() -> GeographyLine:
	return _geography


func outcome_text() -> String:
	return _outcome_line.text if _outcome_line.visible else ""


func again_visible() -> bool:
	return _again.visible


func land_seen() -> bool:
	return _land_seen


func track_points() -> PackedVector2Array:
	return _track.points


func hint_text() -> String:
	return _hint.text


func _finish_landed() -> void:
	outcome = LANDED
	_ship.global_position = _coast.berth_beside(_ship.global_position)
	_ship.heading = _coast.berth_heading(_ship.global_position)
	_seat_hull_in_the_water()
	_ship.stop_sailing()
	_coast.reveal()
	_geography.show_reason()
	_set_outcome_shown(false)
	_set_track_shown(false)
	_show_again()
	_audio.play_landing()


func _finish_missed() -> void:
	outcome = MISSED
	_ship.stop_sailing()
	_show_outcome(ChartStyle.MISSED_LINE)
	_audio.play_miss()


func _finish_supply() -> void:
	outcome = SUPPLY_FAILED
	_ship.stop_sailing()
	_show_outcome(ChartStyle.SUPPLY_LINE)
	_audio.play_miss()


func _seat_hull_in_the_water() -> void:
	var outward := (_ship.global_position - _coast.sample_point()).normalized()
	if outward.length_squared() < 0.01:
		outward = Vector2.RIGHT
	for _step: int in 6:
		if _hull_clears_the_shore():
			return
		_ship.global_position += outward * 14.0


func _hull_clears_the_shore() -> bool:
	var reach := _ship.scale.x
	var side := _ship.heading.rotated(PI * 0.5)
	var toward_shore := (_coast.sample_point() - _ship.global_position).normalized()
	if toward_shore.length_squared() < 0.01:
		toward_shore = Vector2.LEFT
	var samples: Array[Vector2] = [
		Vector2(46, 0), Vector2(-40, 0), Vector2(22, 13), Vector2(22, -13),
		Vector2(-32, 10), Vector2(-32, -10), Vector2(0, 13), Vector2(0, -13),
	]
	for sample: Vector2 in samples:
		var world: Vector2 = _ship.global_position + _ship.heading * sample.x * reach + side * sample.y * reach
		world += toward_shore * 14.0
		if _coast.evaluate(world) == Coast.LANDED:
			return false
	return true


func _show_outcome(line: String) -> void:
	_geography.visible = false
	_outcome_line.text = line
	_set_outcome_shown(true)
	_set_track_shown(false)
	_show_again()


func _set_outcome_shown(shown: bool) -> void:
	_outcome_line.visible = shown
	if _outcome_card != null:
		_outcome_card.visible = shown


func _set_hint_shown(shown: bool) -> void:
	_hint.visible = shown
	if _hint_card != null:
		_hint_card.visible = shown


func _set_track_shown(shown: bool) -> void:
	_track.visible = shown
	if _track_glow != null:
		_track_glow.visible = shown


func _show_again() -> void:
	_again.visible = true
	_again.mouse_filter = Control.MOUSE_FILTER_STOP


func _hide_again() -> void:
	_again.visible = false
	_again.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_heading_changed() -> void:
	_hint_used = true
	_hide_hint()
	if _aim_cooldown > 0.0:
		return
	_aim_cooldown = 0.14
	if _audio != null:
		_audio.play_aim()


## Stops the ship where the camera would leave the chart, and slides it along that edge.
func _keep_ship_on_the_chart() -> void:
	var half := _view_rect().size * 0.5
	var shift := _camera.offset
	var reveal := Vector2(CHART_REVEAL, CHART_REVEAL)
	var min_pos := CHART_FRAME.position - reveal + half - shift
	var max_pos := CHART_FRAME.end + reveal - half - shift
	var pos := _ship.global_position
	pos.x = clampf(pos.x, min_pos.x, max_pos.x)
	pos.y = clampf(pos.y, min_pos.y, max_pos.y)
	_ship.global_position = pos


func _view_rect() -> Rect2:
	var center := _camera.global_position + _camera.offset
	var viewport_size := Vector2(
		float(ProjectSettings.get_setting("display/window/size/viewport_width")),
		float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	)
	var half := viewport_size * 0.5 / _camera.zoom
	return Rect2(center - half, half * 2.0)


func _build_chart() -> void:
	var sea_rect := CHART_FRAME.grow(180.0)
	var sea := Polygon2D.new()
	sea.polygon = PackedVector2Array([
		sea_rect.position,
		Vector2(sea_rect.end.x, sea_rect.position.y),
		sea_rect.end,
		Vector2(sea_rect.position.x, sea_rect.end.y),
	])
	sea.uv = PackedVector2Array([
		Vector2(-1.6, -1.2), Vector2(2.4, -1.2), Vector2(2.4, 1.6), Vector2(-1.6, 1.6),
	])
	var material := ShaderMaterial.new()
	material.shader = preload("res://src/voyage/sea.gdshader")
	sea.material = material
	sea.z_index = -10
	add_child(sea)
	_add_chart_frame()
	_add_departure_mark()

	_current = CurrentBand.new()
	add_child(_current)
	_wind = WindField.new()
	add_child(_wind)
	_coast = Coast.new()
	add_child(_coast)
	_add_chart_note(ChartStyle.WIND_NOTE, Vector2(860, -90), ChartStyle.WIND)
	_add_chart_note(ChartStyle.CURRENT_NOTE, Vector2(560, 150), ChartStyle.CURRENT_LABEL)

	_track_glow = _make_track_line(8.0, Color(1, 0.98, 0.92, 0.38), 4)
	_track = _make_track_line(3.2, ChartStyle.TRACK, 5)

	_audio = SeaAudio.new()
	add_child(_audio)

	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)
	_screen = Control.new()
	_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_screen)

	_supply = SupplyStore.new()
	_supply.position = Vector2(28, 24)
	_screen.add_child(_supply)

	_hint_card = Panel.new()
	_hint_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hint_card.size = Vector2(236, 46)
	_hint_card.add_theme_stylebox_override("panel", _paper_chip(16))
	_screen.add_child(_hint_card)
	_hint = Label.new()
	_hint.text = ChartStyle.HINT_LINE
	_hint.position = Vector2(22, 11)
	_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hint.add_theme_font_override("font", ChartStyle.FONT)
	_hint.add_theme_font_size_override("font_size", 20)
	_hint.add_theme_color_override("font_color", ChartStyle.INK)
	_hint_card.add_child(_hint)

	_geography = GeographyLine.new()
	_screen.add_child(_geography)

	_outcome_card = Panel.new()
	_outcome_card.visible = false
	_outcome_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outcome_card.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_outcome_card.offset_left = -390.0
	_outcome_card.offset_right = 390.0
	_outcome_card.offset_top = -118.0
	_outcome_card.offset_bottom = -46.0
	_outcome_card.add_theme_stylebox_override("panel", _paper_chip(16))
	_screen.add_child(_outcome_card)

	_outcome_line = Label.new()
	_outcome_line.visible = false
	_outcome_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outcome_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_outcome_line.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_outcome_line.offset_left = -460.0
	_outcome_line.offset_right = 460.0
	_outcome_line.offset_top = -108.0
	_outcome_line.offset_bottom = -52.0
	_outcome_line.add_theme_font_override("font", ChartStyle.FONT)
	_outcome_line.add_theme_font_size_override("font_size", 22)
	_outcome_line.add_theme_color_override("font_color", ChartStyle.VERMILION)
	_screen.add_child(_outcome_line)

	_again = Button.new()
	_again.text = ChartStyle.AGAIN_LINE
	_again.visible = false
	_again.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_again.focus_mode = Control.FOCUS_NONE
	_again.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_again.offset_left = -120.0
	_again.offset_right = 120.0
	_again.offset_top = -196.0
	_again.offset_bottom = -136.0
	var plate := StyleBoxFlat.new()
	plate.bg_color = ChartStyle.PAPER
	plate.border_color = ChartStyle.INK
	plate.set_border_width_all(2)
	plate.set_corner_radius_all(16)
	plate.content_margin_left = 18.0
	plate.content_margin_right = 18.0
	plate.shadow_color = Color(0.06, 0.16, 0.18, 0.3)
	plate.shadow_size = 8
	plate.shadow_offset = Vector2(0, 3)
	_again.add_theme_stylebox_override("normal", plate)
	_again.add_theme_stylebox_override("hover", plate)
	_again.add_theme_stylebox_override("pressed", plate)
	_again.add_theme_font_override("font", ChartStyle.FONT)
	_again.add_theme_font_size_override("font_size", 22)
	_again.add_theme_color_override("font_color", ChartStyle.INK)
	_again.add_theme_color_override("font_hover_color", ChartStyle.INK)
	_again.add_theme_color_override("font_pressed_color", ChartStyle.VERMILION)
	_again.pressed.connect(restart)
	_screen.add_child(_again)
	_add_compass(_screen)
	_draw_track()


func _add_chart_frame() -> void:
	var outer := PackedVector2Array([
		CHART_FRAME.position,
		Vector2(CHART_FRAME.end.x, CHART_FRAME.position.y),
		CHART_FRAME.end,
		Vector2(CHART_FRAME.position.x, CHART_FRAME.end.y),
	])
	var ink := Line2D.new()
	ink.width = 10.0
	ink.default_color = ChartStyle.INK
	ink.closed = true
	ink.joint_mode = Line2D.LINE_JOINT_ROUND
	ink.z_index = 0
	for point: Vector2 in outer:
		ink.add_point(point)
	add_child(ink)
	var inner_rect := CHART_FRAME.grow(-18.0)
	var paper := Line2D.new()
	paper.width = 3.0
	paper.default_color = ChartStyle.PAPER
	paper.closed = true
	paper.z_index = 0
	var inner := PackedVector2Array([
		inner_rect.position,
		Vector2(inner_rect.end.x, inner_rect.position.y),
		inner_rect.end,
		Vector2(inner_rect.position.x, inner_rect.end.y),
	])
	for point: Vector2 in inner:
		paper.add_point(point)
	add_child(paper)


func _add_departure_mark() -> void:
	_add_disc(_departure, 16.0, ChartStyle.VERMILION, 2)
	_add_disc(_departure, 9.0, ChartStyle.PAPER, 2)
	var flag := Polygon2D.new()
	flag.polygon = PackedVector2Array([
		_departure + Vector2(0, -2),
		_departure + Vector2(14, -8),
		_departure + Vector2(0, -14),
	])
	flag.color = ChartStyle.VERMILION
	flag.z_index = 2
	add_child(flag)


func _add_disc(at: Vector2, radius: float, color: Color, z: int) -> void:
	var disc := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in 18:
		var angle := TAU * float(index) / 18.0
		points.append(at + Vector2(cos(angle), sin(angle)) * radius)
	disc.polygon = points
	disc.color = color
	disc.z_index = z
	add_child(disc)


func _add_chart_note(text: String, at: Vector2, color: Color) -> void:
	var chip := Panel.new()
	chip.position = at + Vector2(-10, -6)
	chip.size = Vector2(44, 36)
	chip.z_index = 4
	chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_theme_stylebox_override("panel", _paper_chip(12))
	add_child(chip)
	var note := Label.new()
	note.text = text
	note.position = at
	note.z_index = 5
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	note.add_theme_font_override("font", ChartStyle.FONT)
	note.add_theme_font_size_override("font_size", 22)
	note.add_theme_color_override("font_color", color)
	add_child(note)


func _paper_chip(radius: int) -> StyleBoxFlat:
	var plate := StyleBoxFlat.new()
	plate.bg_color = ChartStyle.PAPER
	plate.border_color = ChartStyle.INK
	plate.set_border_width_all(2)
	plate.set_corner_radius_all(radius)
	plate.shadow_color = Color(0.06, 0.16, 0.18, 0.28)
	plate.shadow_size = 5
	plate.shadow_offset = Vector2(0, 2)
	return plate


func _make_track_line(width: float, color: Color, z: int) -> Line2D:
	var line := Line2D.new()
	line.top_level = true
	line.width = width
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.z_index = z
	add_child(line)
	return line


func _add_compass(screen: Control) -> void:
	var rose := CompassRose.new()
	rose.position = Vector2(1136, 18)
	screen.add_child(rose)


func _place_hint(delta: float) -> void:
	if not _hint.visible:
		return
	if not _hint_used:
		_hint_time += delta
		if _hint_time > 8.0:
			_hide_hint()
			return
	var screen_point: Vector2 = get_viewport().get_canvas_transform() * _ship.global_position
	_hint_card.position = screen_point + Vector2(-118, -96)


func _hide_hint() -> void:
	_set_hint_shown(false)


func _draw_track() -> void:
	if outcome != SAILING:
		_set_track_shown(false)
		return
	_set_track_shown(true)
	var points := PackedVector2Array()
	var pos := _ship.global_position
	points.append(pos)
	for _index: int in TRACK_SAMPLES:
		var wind_push := _wind.forecast_push(pos)
		var current_push := _current.vector_at(pos)
		pos += (_ship.heading * _ship.sail_speed + wind_push + current_push) * TRACK_STEP
		points.append(pos)
	_track.points = points
	_track_glow.points = points


func _apply_launch_pose() -> void:
	var args := OS.get_cmdline_user_args()
	if args.has("landed"):
		_ship.global_position = _coast.sample_point()
		advance(0.05)
	elif args.has("approach"):
		_ship.global_position = _coast.sample_point() + Vector2(260, -10)
	elif args.has("shifted"):
		_ship.global_position = Vector2(_wind.shift_x - 20.0, 90.0)
		_wind.shift()
	elif args.has("missed"):
		_ship.global_position = Vector2(_coast.pass_line_x - 36.0, _coast.sample_point().y - 210.0)
		advance(0.05)
	elif args.has("supply"):
		_ship.global_position = Vector2(1400, -40)
		_supply.remaining = 0.0
		_supply.queue_redraw()
		advance(0.05)
