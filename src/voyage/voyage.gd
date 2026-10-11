class_name Voyage
extends Node2D
## One voyage, from casting off to a landing or a failure. It does not start another.


const SAILING := "sailing"
const LANDED := "landed"
const MISSED := "missed"
const SUPPLY_FAILED := "supply_failed"

var outcome: String = SAILING

var _ship: Ship
var _wind: WindField
var _current: CurrentBand
var _coast: Coast
var _supply: SupplyStore
var _geography: GeographyLine
var _outcome_line: Label
var _camera: Camera2D


func _ready() -> void:
	_ship = get_node("Ship") as Ship
	_camera = _ship.get_node("Camera2D") as Camera2D
	_build_chart()
	_apply_launch_pose()


func _physics_process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	if outcome != SAILING:
		return
	_ship.wind_push = _wind.vector_at(_ship.global_position)
	_ship.current_push = _current.vector_at(_ship.global_position)
	_ship.integrate(delta)
	_supply.tick(delta)
	var view := _view_rect()
	var coast_state := _coast.evaluate(_ship.global_position)
	if coast_state == Coast.LANDED:
		_finish_landed()
	elif coast_state == Coast.PASSED:
		_finish_missed()
	elif _supply.is_empty() and not _coast.intersects_view(view):
		_finish_supply()


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


func _finish_landed() -> void:
	outcome = LANDED
	_ship.stop_sailing()
	_coast.reveal()
	_geography.show_reason()
	_outcome_line.visible = false


func _finish_missed() -> void:
	outcome = MISSED
	_ship.stop_sailing()
	_show_outcome(ChartStyle.MISSED_LINE)


func _finish_supply() -> void:
	outcome = SUPPLY_FAILED
	_ship.stop_sailing()
	_show_outcome(ChartStyle.SUPPLY_LINE)


func _show_outcome(line: String) -> void:
	_geography.visible = false
	_outcome_line.text = line
	_outcome_line.visible = true


func _view_rect() -> Rect2:
	var center := _camera.global_position + _camera.offset
	var viewport_size := Vector2(
		float(ProjectSettings.get_setting("display/window/size/viewport_width")),
		float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	)
	var half := viewport_size * 0.5 / _camera.zoom
	return Rect2(center - half, half * 2.0)


func _build_chart() -> void:
	var sea := Polygon2D.new()
	sea.polygon = PackedVector2Array([
		Vector2(-1800, -1200), Vector2(1800, -1200),
		Vector2(1800, 1200), Vector2(-1800, 1200),
	])
	sea.uv = PackedVector2Array([
		Vector2(-1.6, -1.2), Vector2(2.4, -1.2), Vector2(2.4, 1.6), Vector2(-1.6, 1.6),
	])
	var material := ShaderMaterial.new()
	material.shader = preload("res://src/voyage/sea.gdshader")
	sea.material = material
	sea.z_index = -10
	add_child(sea)
	_add_departure_mark()

	_current = CurrentBand.new()
	add_child(_current)
	_wind = WindField.new()
	add_child(_wind)
	_coast = Coast.new()
	add_child(_coast)

	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)
	var screen := Control.new()
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(screen)

	_supply = SupplyStore.new()
	_supply.position = Vector2(28, 24)
	screen.add_child(_supply)

	_geography = GeographyLine.new()
	screen.add_child(_geography)

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
	screen.add_child(_outcome_line)
	_add_compass(screen)


func _add_departure_mark() -> void:
	var mark := Line2D.new()
	mark.width = 1.6
	mark.default_color = Color(ChartStyle.PAPER, 0.85)
	var origin := Vector2(620, 20)
	mark.add_point(origin + Vector2(-16, 0))
	mark.add_point(origin + Vector2(16, 0))
	add_child(mark)
	var stem := Line2D.new()
	stem.width = 1.6
	stem.default_color = Color(ChartStyle.PAPER, 0.85)
	stem.add_point(origin + Vector2(0, -16))
	stem.add_point(origin + Vector2(0, 16))
	add_child(stem)


func _add_compass(screen: Control) -> void:
	var rose := CompassRose.new()
	rose.position = Vector2(1136, 18)
	screen.add_child(rose)


func _apply_launch_pose() -> void:
	var args := OS.get_cmdline_user_args()
	if args.has("landed"):
		_ship.global_position = _coast.sample_point()
		advance(0.05)
	elif args.has("approach"):
		_ship.global_position = _coast.sample_point() + Vector2(260, -10)
	elif args.has("missed"):
		_ship.global_position = Vector2(_coast.pass_line_x - 36.0, _coast.sample_point().y - 210.0)
		advance(0.05)
	elif args.has("supply"):
		_ship.global_position = Vector2(1100, -40)
		_supply.remaining = 0.0
		_supply.queue_redraw()
		advance(0.05)
