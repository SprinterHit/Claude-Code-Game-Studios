class_name Coast
extends Node2D
## The one shore of this voyage. Ink first; the historical coast fills in on landing.


const LANDED := "landed"
const PASSED := "passed"
const SAILING := "sailing"

var revealed: bool = false
var pass_line_x: float = 0.0

var _outline: PackedVector2Array = PackedVector2Array([
	Vector2(-300, 28),
	Vector2(-268, -18),
	Vector2(-214, -52),
	Vector2(-168, -24),
	Vector2(-132, -46),
	Vector2(-96, -6),
	Vector2(-72, 34),
	Vector2(-98, 78),
	Vector2(-64, 118),
	Vector2(-102, 162),
	Vector2(-158, 196),
	Vector2(-214, 176),
	Vector2(-258, 132),
	Vector2(-286, 78),
])
var _dress: Array[CanvasItem] = []


func _ready() -> void:
	z_index = 3
	var west := _outline[0].x
	for point: Vector2 in _outline:
		west = min(west, point.x)
	pass_line_x = west - 64.0
	_build_ink()
	_build_reveal()


func evaluate(world_point: Vector2) -> String:
	var local_point := to_local(world_point)
	if Geometry2D.is_point_in_polygon(local_point, _outline):
		return LANDED
	if local_point.x < pass_line_x:
		return PASSED
	return SAILING


func intersects_view(view: Rect2) -> bool:
	return view.intersects(_bounds())


func sample_point() -> Vector2:
	return to_global(_local_center())


func _local_center() -> Vector2:
	var sum := Vector2.ZERO
	for point: Vector2 in _outline:
		sum += point
	return sum / float(_outline.size())


func conceal() -> void:
	revealed = false
	for item: CanvasItem in _dress:
		item.visible = false


## A point in the water just outside the ink line, beside [param from_point].
## The offset clears the hull, so the ship sits in the water rather than on the shore.
func berth_beside(from_point: Vector2) -> Vector2:
	var closest := _closest_outline_point(to_local(from_point))
	var outward := _outward_from(closest)
	for step: int in 8:
		var landed := closest + outward * (56.0 + float(step) * 14.0)
		if not Geometry2D.is_point_in_polygon(landed, _outline):
			return to_global(landed)
	return to_global(closest + outward * 160.0)


## Heading that lays the ship along the ink, bow toward the west.
func berth_heading(at_world: Vector2) -> Vector2:
	var outward := _outward_from(to_local(at_world))
	var along := Vector2(-outward.y, outward.x)
	if along.x > 0.0:
		along = -along
	return along


func _closest_outline_point(local_from: Vector2) -> Vector2:
	var closest := _outline[0]
	var best := local_from.distance_squared_to(closest)
	for point: Vector2 in _outline:
		var distance := local_from.distance_squared_to(point)
		if distance < best:
			best = distance
			closest = point
	return closest


func _outward_from(local_point: Vector2) -> Vector2:
	var outward := (local_point - _local_center()).normalized()
	if outward.length_squared() < 0.01:
		return Vector2.RIGHT
	return outward


func reveal() -> void:
	if revealed:
		return
	revealed = true
	for item: CanvasItem in _dress:
		item.visible = true


func _bounds() -> Rect2:
	var bounds := Rect2(_outline[0], Vector2.ZERO)
	for point: Vector2 in _outline:
		bounds = bounds.expand(point)
	return Rect2(to_global(bounds.position), bounds.size)


func _build_ink() -> void:
	_add_closed_line(_outline, 9.0, Color(0.05, 0.16, 0.2, 0.22), 2)
	_add_closed_line(_outline, 4.6, ChartStyle.INK, 5)
	var center := _local_center()
	var inner := PackedVector2Array()
	for point: Vector2 in _outline:
		inner.append(point.lerp(center, 0.06))
	_add_closed_line(inner, 1.5, Color(ChartStyle.PAPER, 0.85), 5)


func _add_closed_line(points: PackedVector2Array, width: float, color: Color, z: int) -> void:
	var line := Line2D.new()
	line.width = width
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.closed = true
	line.z_index = z
	for point: Vector2 in points:
		line.add_point(point)
	add_child(line)


func _build_reveal() -> void:
	var center := _local_center()
	_add_dress(_disc(center, 176.0, 24), Color(0.55, 0.86, 0.8, 0.32), 2)
	var shadow := PackedVector2Array()
	for point: Vector2 in _outline:
		shadow.append(point + Vector2(7, 10))
	_add_dress(shadow, Color(0.05, 0.18, 0.22, 0.22), 2)
	_add_dress(_outline, ChartStyle.SHORE, 3)
	_add_dress(_inset(0.16), ChartStyle.GRASS, 3)
	_add_dress(_inset(0.4), ChartStyle.GRASS_DEEP, 3)
	_add_hill(center + Vector2(-34, -8), 46.0)
	_add_hill(center + Vector2(32, 22), 34.0)
	_add_hill(center + Vector2(-6, 36), 26.0)
	_add_palm(center + Vector2(-46, -16))
	_add_palm(center + Vector2(34, 6))
	_add_palm(center + Vector2(-12, 48))
	_add_hut(center + Vector2(6, 18))
	_add_flowers(center)
	var name_at := center + Vector2(-52, -92)
	_add_name_plaque(name_at)
	var name := Label.new()
	name.text = ChartStyle.COAST_NAME
	name.visible = false
	name.position = name_at
	name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name.add_theme_font_override("font", ChartStyle.FONT)
	name.add_theme_font_size_override("font_size", 20)
	name.add_theme_color_override("font_color", ChartStyle.INK)
	name.z_index = 6
	add_child(name)
	_dress.append(name)


func _add_hill(at: Vector2, radius: float) -> void:
	_add_dress(_disc(at, radius, 16), ChartStyle.HILL, 4)
	_add_dress(_disc(at + Vector2(-radius * 0.18, -radius * 0.28), radius * 0.62, 12), ChartStyle.HILL_LIGHT, 4)


func _add_palm(root: Vector2) -> void:
	_add_dress(PackedVector2Array([
		root + Vector2(-3.2, 20), root + Vector2(3.2, 20),
		root + Vector2(2.2, 0), root + Vector2(-2.2, 0),
	]), ChartStyle.WOOD, 4)
	var fronds: Array[Vector2] = [
		Vector2(-26, -8), Vector2(-14, -24), Vector2(2, -26), Vector2(18, -16), Vector2(24, -2),
	]
	for tip: Vector2 in fronds:
		_add_dress(PackedVector2Array([
			root, root + tip, root + tip.rotated(0.45) * 0.62,
		]), ChartStyle.GRASS_DEEP, 4)
	_add_dress(_disc(root + Vector2(-5, -8), 11.0, 10), ChartStyle.HILL_LIGHT, 4)


func _add_hut(at: Vector2) -> void:
	_add_dress(PackedVector2Array([
		at + Vector2(-11, 8), at + Vector2(11, 8), at + Vector2(11, -2), at + Vector2(-11, -2),
	]), ChartStyle.PAPER, 4)
	_add_dress(PackedVector2Array([
		at + Vector2(-14, -2), at + Vector2(0, -16), at + Vector2(14, -2),
	]), ChartStyle.VERMILION, 4)
	_add_dress(PackedVector2Array([
		at + Vector2(-2.2, 8), at + Vector2(2.2, 8), at + Vector2(2.2, 1.5), at + Vector2(-2.2, 1.5),
	]), ChartStyle.WOOD_DARK, 4)


func _add_flowers(center: Vector2) -> void:
	var spots: Array[Vector2] = [
		center + Vector2(-20, 8), center + Vector2(18, -6),
		center + Vector2(-8, 28), center + Vector2(24, 34),
	]
	var colors: Array[Color] = [
		Color("f2d15a"), Color("f29a9a"), Color("fff4ea"), Color("f2d15a"),
	]
	for index: int in spots.size():
		_add_dress(_disc(spots[index], 3.4, 7), colors[index], 4)


func _add_name_plaque(at: Vector2) -> void:
	var plaque := Panel.new()
	plaque.visible = false
	plaque.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plaque.position = at + Vector2(-14, -6)
	plaque.size = Vector2(124, 34)
	plaque.z_index = 5
	var plate := StyleBoxFlat.new()
	plate.bg_color = ChartStyle.PAPER
	plate.border_color = ChartStyle.INK
	plate.set_border_width_all(2)
	plate.set_corner_radius_all(12)
	plate.shadow_color = Color(0.2, 0.12, 0.08, 0.28)
	plate.shadow_size = 4
	plaque.add_theme_stylebox_override("panel", plate)
	add_child(plaque)
	_dress.append(plaque)


func _add_dress(polygon: PackedVector2Array, color: Color, z: int) -> void:
	var node := Polygon2D.new()
	node.polygon = polygon
	node.color = color
	node.visible = false
	node.z_index = z
	add_child(node)
	_dress.append(node)


func _inset(amount: float) -> PackedVector2Array:
	var center := _local_center()
	var points := PackedVector2Array()
	for point: Vector2 in _outline:
		points.append(point.lerp(center, amount))
	return points


func _disc(center: Vector2, radius: float, sides: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index: int in sides:
		var angle := TAU * float(index) / float(sides)
		points.append(center + Vector2(cos(angle), sin(angle) * 0.72) * radius)
	return points
