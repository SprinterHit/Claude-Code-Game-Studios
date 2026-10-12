class_name WindArrow
extends Node2D
## One illustrated trade-wind arrow. The voyage rotates the whole node when the wind turns.


func _ready() -> void:
	z_index = 2


func _draw() -> void:
	var shape := PackedVector2Array([
		Vector2(24, 0), Vector2(7, 7.4), Vector2(9, 2.8),
		Vector2(-18, 2.8), Vector2(-18, -2.8), Vector2(9, -2.8), Vector2(7, -7.4),
	])
	var shadow := PackedVector2Array()
	for point: Vector2 in shape:
		shadow.append(point + Vector2(1.4, 1.8))
	draw_colored_polygon(shadow, Color(0.45, 0.16, 0.08, 0.22))
	draw_colored_polygon(shape, ChartStyle.WIND)
	draw_colored_polygon(PackedVector2Array([
		Vector2(16, 0), Vector2(8, 2.6), Vector2(8, -2.6),
	]), ChartStyle.WIND_LIGHT)
	var loop := shape.duplicate()
	loop.append(shape[0])
	draw_polyline(loop, ChartStyle.PAPER, 1.8, true)
