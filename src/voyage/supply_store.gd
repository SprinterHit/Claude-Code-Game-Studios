class_name SupplyStore
extends Control
## Ink gauge for the stores on this one voyage. It only counts down.


@export var seconds_afloat: float = 26.0

var remaining: float = 1.0

var _plate: StyleBoxFlat
var _bar: StyleBoxFlat


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(268, 68)
	_plate = StyleBoxFlat.new()
	_plate.bg_color = ChartStyle.PAPER
	_plate.border_color = ChartStyle.INK
	_plate.set_border_width_all(2)
	_plate.set_corner_radius_all(16)
	_plate.shadow_color = Color(0.06, 0.16, 0.18, 0.32)
	_plate.shadow_size = 8
	_plate.shadow_offset = Vector2(0, 3)
	_bar = StyleBoxFlat.new()
	_bar.bg_color = ChartStyle.VERMILION
	_bar.set_corner_radius_all(6)
	var title := Label.new()
	title.text = "补给"
	title.position = Vector2(18, 8)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.add_theme_font_override("font", ChartStyle.FONT)
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", ChartStyle.INK)
	add_child(title)


func tick(delta: float) -> void:
	if remaining <= 0.0:
		return
	remaining = maxf(0.0, remaining - delta / seconds_afloat)
	queue_redraw()


func is_empty() -> bool:
	return remaining <= 0.0


func refill() -> void:
	remaining = 1.0
	queue_redraw()


func _process(_delta: float) -> void:
	if remaining > 0.0 and remaining < 0.3:
		queue_redraw()


func _draw() -> void:
	var urgent := remaining > 0.0 and remaining < 0.3
	var plate := Rect2(Vector2.ZERO, custom_minimum_size)
	_plate.border_color = ChartStyle.VERMILION if urgent else ChartStyle.INK
	_plate.set_border_width_all(3 if urgent else 2)
	_plate.draw(get_canvas_item(), plate)
	var track := Rect2(Vector2(16, 38), Vector2(236, 14))
	var track_box := StyleBoxFlat.new()
	track_box.bg_color = ChartStyle.PAPER_DEEP
	track_box.set_corner_radius_all(7)
	track_box.draw(get_canvas_item(), track)
	if remaining > 0.01:
		var fill := track
		fill.size.x = maxf(14.0, track.size.x * remaining)
		var fill_color := ChartStyle.VERMILION
		if urgent:
			var pulse := 0.5 + 0.5 * sin(float(Time.get_ticks_msec()) * 0.012)
			fill_color = ChartStyle.VERMILION.lerp(Color("f8d7a8"), pulse)
		_bar.bg_color = fill_color
		_bar.draw(get_canvas_item(), fill)
	_draw_barrel(Vector2(228, 14))


func _draw_barrel(at: Vector2) -> void:
	draw_colored_polygon(PackedVector2Array([
		at + Vector2(0, 4), at + Vector2(4, 0), at + Vector2(18, 0), at + Vector2(22, 4),
		at + Vector2(22, 14), at + Vector2(18, 18), at + Vector2(4, 18), at + Vector2(0, 14),
	]), ChartStyle.WOOD)
	draw_line(at + Vector2(4, 6), at + Vector2(18, 6), ChartStyle.WOOD_DARK, 1.4, true)
	draw_line(at + Vector2(4, 12), at + Vector2(18, 12), ChartStyle.WOOD_DARK, 1.4, true)
