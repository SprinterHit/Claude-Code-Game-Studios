class_name CurrentBand
extends Node2D
## One colored ribbon of current. It pushes the ship only while the ship is on it.


@export var push: Vector2 = Vector2(-18, 10)
@export var half_width: float = 72.0

var _band: Polygon2D
var _centerline: PackedVector2Array = PackedVector2Array([
	Vector2(880, 120),
	Vector2(620, 90),
	Vector2(340, 70),
	Vector2(40, 60),
	Vector2(-220, 80),
])
var _streaks: Array[Polygon2D] = []
var _streak_t: Array[float] = []


func _ready() -> void:
	z_index = 1
	var glow := Polygon2D.new()
	glow.polygon = _ribbon(_centerline, half_width * 1.18)
	glow.color = Color(0.35, 0.82, 0.88, 0.28)
	glow.z_index = 1
	add_child(glow)
	_band = Polygon2D.new()
	_band.polygon = _ribbon(_centerline, half_width)
	var band_color := ChartStyle.CURRENT
	band_color.a = 0.5
	_band.color = band_color
	_band.z_index = 1
	add_child(_band)
	var shine := Polygon2D.new()
	shine.polygon = _ribbon(_centerline, half_width * 0.28)
	var shine_color := ChartStyle.CURRENT_STREAK
	shine_color.a = 0.55
	shine.color = shine_color
	shine.z_index = 1
	add_child(shine)
	_add_edge(1.0, Color(0.95, 0.99, 0.98, 0.7), 3.4)
	_add_edge(-1.0, Color(0.95, 0.99, 0.98, 0.45), 2.4)
	for index: int in 8:
		var streak := Polygon2D.new()
		streak.polygon = _capsule(18.0, 5.5)
		streak.color = ChartStyle.CURRENT_STREAK
		streak.z_index = 1
		add_child(streak)
		_streaks.append(streak)
		_streak_t.append(float(index) / 8.0)


func band_point_count() -> int:
	if _band == null:
		return 0
	return _band.polygon.size()


func band_color() -> Color:
	return _band.color


func vector_at(world_point: Vector2) -> Vector2:
	if _band == null:
		return Vector2.ZERO
	if Geometry2D.is_point_in_polygon(to_local(world_point), _band.polygon):
		return push
	return Vector2.ZERO


func _process(delta: float) -> void:
	for index: int in _streaks.size():
		_streak_t[index] = fmod(_streak_t[index] + delta * 0.08, 1.0)
		var sample := _sample(_centerline, _streak_t[index])
		_streaks[index].position = sample.point
		_streaks[index].rotation = sample.tangent.angle()


func _add_edge(side: float, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.width = width
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.z_index = 1
	for index: int in _centerline.size():
		var normal := _normal(_centerline, index)
		line.add_point(_centerline[index] + normal * half_width * side)
	add_child(line)


func _ribbon(centerline: PackedVector2Array, width: float) -> PackedVector2Array:
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for index: int in centerline.size():
		var normal := _normal(centerline, index)
		left.append(centerline[index] + normal * width)
		right.append(centerline[index] - normal * width)
	var polygon := PackedVector2Array()
	for point: Vector2 in left:
		polygon.append(point)
	for index: int in range(right.size() - 1, -1, -1):
		polygon.append(right[index])
	return polygon


func _normal(centerline: PackedVector2Array, index: int) -> Vector2:
	var tangent := _tangent(centerline, index)
	return Vector2(-tangent.y, tangent.x)


func _tangent(centerline: PackedVector2Array, index: int) -> Vector2:
	var previous: Vector2 = centerline[max(index - 1, 0)]
	var next: Vector2 = centerline[mini(index + 1, centerline.size() - 1)]
	return (next - previous).normalized()


func _sample(centerline: PackedVector2Array, amount: float) -> Dictionary:
	var lengths: Array[float] = []
	var total := 0.0
	for index: int in centerline.size() - 1:
		var length := centerline[index].distance_to(centerline[index + 1])
		lengths.append(length)
		total += length
	var target := amount * total
	var walked := 0.0
	for index: int in lengths.size():
		var length: float = lengths[index]
		if walked + length >= target:
			var local := 0.0 if length <= 0.001 else (target - walked) / length
			var point := centerline[index].lerp(centerline[index + 1], local)
			return {"point": point, "tangent": (centerline[index + 1] - centerline[index]).normalized()}
		walked += length
	var last := centerline.size() - 1
	return {"point": centerline[last], "tangent": _tangent(centerline, last)}


func _capsule(length: float, radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	points.append(Vector2(-length, -radius))
	points.append(Vector2(length, -radius))
	points.append(Vector2(length + radius, 0))
	points.append(Vector2(length, radius))
	points.append(Vector2(-length, radius))
	points.append(Vector2(-length - radius, 0))
	return points
