extends Node2D
## Top-down cartoon caravel. Local +X is the bow, and the hull stays inside the berth clearance.


var _hull: PackedVector2Array = PackedVector2Array()


func _ready() -> void:
	_hull = PackedVector2Array([
		Vector2(46, 0), Vector2(30, 7.5), Vector2(12, 12), Vector2(-16, 12.5),
		Vector2(-32, 8), Vector2(-40, 0), Vector2(-32, -8), Vector2(-16, -12.5),
		Vector2(12, -12), Vector2(30, -7.5),
	])


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if _hull.is_empty():
		return
	var flutter := sin(float(Time.get_ticks_msec()) * 0.004) * 1.3
	_draw_shadow()
	_draw_hull()
	_draw_sails(flutter)
	_draw_pennant(flutter)


func _draw_shadow() -> void:
	var shadow := PackedVector2Array()
	for point: Vector2 in _hull:
		shadow.append(point + Vector2(3.5, 4.5))
	draw_colored_polygon(shadow, Color(0.04, 0.12, 0.16, 0.28))


func _draw_hull() -> void:
	draw_colored_polygon(_hull, ChartStyle.WOOD_DARK)
	var inset := PackedVector2Array()
	for point: Vector2 in _hull:
		inset.append(point * 0.9)
	draw_colored_polygon(inset, ChartStyle.WOOD)
	draw_line(Vector2(22, 7.2), Vector2(-30, 6.2), ChartStyle.WOOD_DARK, 1.15, true)
	draw_line(Vector2(22, -7.2), Vector2(-30, -6.2), ChartStyle.WOOD_DARK, 1.15, true)
	draw_line(Vector2(26, 3.4), Vector2(-32, 2.6), ChartStyle.WOOD_LIGHT, 1.3, true)
	var deck := PackedVector2Array([
		Vector2(18, 0), Vector2(8, 6), Vector2(-22, 6.2), Vector2(-28, 0), Vector2(-22, -6.2), Vector2(8, -6),
	])
	draw_colored_polygon(deck, ChartStyle.DECK)
	draw_colored_polygon(PackedVector2Array([
		Vector2(16, -2.2), Vector2(-20, -2.2), Vector2(-20, -4.4), Vector2(16, -4.4),
	]), ChartStyle.WOOD_LIGHT)
	for index: int in 3:
		var port := Vector2(-6.0 + float(index) * 9.0, 0.0)
		draw_circle(port, 1.7, ChartStyle.WOOD_DARK)
		draw_circle(port + Vector2(-0.4, -0.4), 0.7, Color("f2e2c4"))
	draw_circle(Vector2(-8, 0), 2.2, ChartStyle.WOOD_DARK)
	draw_circle(Vector2(40, 0), 2.4, ChartStyle.GOLD)
	_stroke(_hull, ChartStyle.WOOD_DARK, 2.2)


func _draw_sails(flutter: float) -> void:
	var main_sail := PackedVector2Array([
		Vector2(-17, -1), Vector2(-14, -11), Vector2(-2, -12.2 + flutter * 0.3),
		Vector2(7, -7 + flutter), Vector2(9, 0), Vector2(6, 8 - flutter),
		Vector2(-4, 12), Vector2(-15, 9), Vector2(-18, 2),
	])
	draw_colored_polygon(main_sail, ChartStyle.SAIL)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-2, -7), Vector2(6, 0), Vector2(-2, 7), Vector2(-4, 0),
	]), ChartStyle.SAIL_SHADE)
	draw_line(Vector2(-16, 0), Vector2(6, 0), ChartStyle.SAIL_LINE, 1.1, true)
	_stroke(main_sail, ChartStyle.SAIL_LINE, 1.4)
	var foresail := PackedVector2Array([
		Vector2(12, -5.5), Vector2(28, flutter * 0.4), Vector2(12, 5.5), Vector2(14, 0),
	])
	draw_colored_polygon(foresail, ChartStyle.SAIL)
	draw_colored_polygon(PackedVector2Array([
		Vector2(18, -2.5), Vector2(26, 0), Vector2(18, 2.5),
	]), ChartStyle.SAIL_SHADE)
	_stroke(foresail, ChartStyle.SAIL_LINE, 1.3)


func _draw_pennant(flutter: float) -> void:
	var flag := PackedVector2Array([
		Vector2(-30, -1.2), Vector2(-16, -0.4), Vector2(-24, 3.4 + flutter * 0.35),
	])
	draw_colored_polygon(flag, ChartStyle.VERMILION)
	_stroke(flag, Color("8d2b22"), 1.1)


func _stroke(points: PackedVector2Array, color: Color, width: float) -> void:
	var loop := points.duplicate()
	loop.append(points[0])
	draw_polyline(loop, color, width, true)
