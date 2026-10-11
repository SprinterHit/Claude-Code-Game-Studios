class_name SupplyStore
extends Control
## Ink gauge for the stores on this one voyage. It only counts down.


@export var seconds_afloat: float = 42.0

var remaining: float = 1.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(248, 58)
	var title := Label.new()
	title.text = "补给"
	title.position = Vector2(14, 4)
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


func _draw() -> void:
	var plate := Rect2(Vector2.ZERO, custom_minimum_size)
	draw_rect(plate, ChartStyle.PAPER)
	draw_rect(plate, ChartStyle.INK, false, 1.6)
	var track := Rect2(Vector2(14, 32), Vector2(220, 12))
	draw_rect(track, ChartStyle.PAPER_DEEP)
	var fill := track
	fill.size.x = track.size.x * remaining
	draw_rect(fill, ChartStyle.VERMILION)
	draw_rect(track, ChartStyle.INK, false, 1.0)
