class_name CompassRose
extends Control
## Ink rose and the chart's name, kept clear of each other.


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(128, 148)
	size = custom_minimum_size


func _draw() -> void:
	var center := Vector2(64, 58)
	var ink := ChartStyle.INK
	draw_circle(center, 48, ChartStyle.PAPER)
	draw_arc(center, 48, 0, TAU, 56, ink, 1.7, true)
	draw_arc(center, 34, 0, TAU, 48, Color(ink, 0.45), 1.0, true)
	draw_line(center + Vector2(0, -42), center + Vector2(0, 42), ink, 1.15, true)
	draw_line(center + Vector2(-42, 0), center + Vector2(42, 0), ink, 1.15, true)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(0, -44),
		center + Vector2(7, -22),
		center + Vector2(-7, -22),
	]), ChartStyle.VERMILION)
	draw_string(ChartStyle.FONT, center + Vector2(-8, -50), "北", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, ink)
	draw_string(ChartStyle.FONT, Vector2(28, 132), "读海", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, ChartStyle.PAPER)
