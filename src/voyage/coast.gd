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
var _fill: Polygon2D
var _hills: Array[Polygon2D] = []
var _name: Label
var _shoal: Polygon2D


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
	if _fill != null:
		_fill.visible = false
	if _shoal != null:
		_shoal.visible = false
	if _name != null:
		_name.visible = false
	for hill: Polygon2D in _hills:
		hill.visible = false


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
	_fill.visible = true
	_shoal.visible = true
	_name.visible = true
	for hill: Polygon2D in _hills:
		hill.visible = true


func _bounds() -> Rect2:
	var bounds := Rect2(_outline[0], Vector2.ZERO)
	for point: Vector2 in _outline:
		bounds = bounds.expand(point)
	return Rect2(to_global(bounds.position), bounds.size)


func _build_ink() -> void:
	var ink := Line2D.new()
	ink.width = 3.2
	ink.default_color = ChartStyle.INK
	ink.joint_mode = Line2D.LINE_JOINT_ROUND
	ink.begin_cap_mode = Line2D.LINE_CAP_ROUND
	ink.end_cap_mode = Line2D.LINE_CAP_ROUND
	ink.closed = true
	for point: Vector2 in _outline:
		ink.add_point(point)
	add_child(ink)
	var inner := Line2D.new()
	inner.width = 1.1
	inner.default_color = Color(ChartStyle.PAPER, 0.75)
	inner.closed = true
	var center := _local_center()
	for point: Vector2 in _outline:
		inner.add_point(point.lerp(center, 0.08))
	add_child(inner)


func _build_reveal() -> void:
	_shoal = Polygon2D.new()
	_shoal.polygon = _disc(_local_center(), 168.0, 22)
	_shoal.color = Color(0.62, 0.74, 0.66, 0.34)
	_shoal.visible = false
	_shoal.z_index = 2
	add_child(_shoal)
	_fill = Polygon2D.new()
	_fill.polygon = _outline
	_fill.color = ChartStyle.LAND
	_fill.visible = false
	_fill.z_index = 3
	add_child(_fill)
	_add_hill(PackedVector2Array([
		Vector2(-230, 70), Vector2(-176, 8), Vector2(-128, 78),
	]))
	_add_hill(PackedVector2Array([
		Vector2(-168, 112), Vector2(-118, 48), Vector2(-86, 124),
	]))
	_add_hill(PackedVector2Array([
		Vector2(-210, 150), Vector2(-156, 102), Vector2(-124, 158),
	]))
	_name = Label.new()
	_name.text = ChartStyle.COAST_NAME
	_name.visible = false
	_name.position = _local_center() + Vector2(-58, -86)
	_name.add_theme_font_override("font", ChartStyle.FONT)
	_name.add_theme_font_size_override("font_size", 20)
	_name.add_theme_color_override("font_color", ChartStyle.INK)
	_name.z_index = 4
	add_child(_name)


func _add_hill(polygon: PackedVector2Array) -> void:
	var hill := Polygon2D.new()
	hill.polygon = polygon
	hill.color = ChartStyle.HILL
	hill.visible = false
	hill.z_index = 3
	add_child(hill)
	_hills.append(hill)


func _disc(center: Vector2, radius: float, sides: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index: int in sides:
		var angle := TAU * float(index) / float(sides)
		points.append(center + Vector2(cos(angle), sin(angle) * 0.72) * radius)
	return points
