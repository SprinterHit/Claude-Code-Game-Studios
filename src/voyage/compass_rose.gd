class_name CompassRose
extends Control
## Cartoon rose and the chart's name, kept clear of each other.


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(128, 156)
	size = custom_minimum_size


func _draw() -> void:
	var center := Vector2(64, 62)
	draw_circle(center + Vector2(0, 3), 50, Color(0.08, 0.2, 0.24, 0.28))
	draw_circle(center, 50, ChartStyle.PAPER)
	draw_arc(center, 50, 0, TAU, 64, ChartStyle.INK, 2.6, true)
	for index: int in 16:
		var tick_angle := float(index) * TAU / 16.0
		var outer := center + Vector2(cos(tick_angle), sin(tick_angle)) * 46.0
		var inner := center + Vector2(cos(tick_angle), sin(tick_angle)) * (42.0 if index % 2 == 0 else 44.0)
		draw_line(inner, outer, ChartStyle.INK, 1.4, true)
	for index: int in 8:
		var angle := -PI * 0.5 + float(index) * TAU / 8.0
		var length := 34.0 if index % 2 == 0 else 22.0
		var half := 7.0 if index % 2 == 0 else 5.5
		var color := ChartStyle.INK
		if index == 0:
			color = ChartStyle.VERMILION
		elif index % 2 == 1:
			color = ChartStyle.GOLD
		_rose_point(center, angle, length, half, color)
	draw_circle(center, 6.0, ChartStyle.VERMILION)
	draw_circle(center, 2.6, ChartStyle.PAPER)
	draw_string(ChartStyle.FONT, center + Vector2(-8, -54), "北", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, ChartStyle.VERMILION)
	var title := Rect2(Vector2(18, 122), Vector2(92, 30))
	var plate := StyleBoxFlat.new()
	plate.bg_color = ChartStyle.PAPER
	plate.border_color = ChartStyle.INK
	plate.set_border_width_all(2)
	plate.set_corner_radius_all(12)
	plate.shadow_color = Color(0.08, 0.18, 0.2, 0.3)
	plate.shadow_size = 4
	plate.draw(get_canvas_item(), title)
	draw_string(ChartStyle.FONT, Vector2(40, 143), "读海", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, ChartStyle.INK)


func _rose_point(center: Vector2, angle: float, length: float, half_width: float, color: Color) -> void:
	var forward := Vector2(cos(angle), sin(angle))
	var side := Vector2(-forward.y, forward.x)
	var tip := center + forward * length
	var waist := center + forward * 7.0
	draw_colored_polygon(PackedVector2Array([
		tip, waist + side * half_width, waist - side * half_width,
	]), color)
	draw_polyline(PackedVector2Array([
		tip, waist + side * half_width, waist - side * half_width, tip,
	]), ChartStyle.INK, 1.1, true)
