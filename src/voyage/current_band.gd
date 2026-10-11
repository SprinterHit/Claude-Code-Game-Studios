class_name CurrentBand
extends Node2D
## One colored ribbon of current. It pushes the ship only while the ship is on it.


@export var push: Vector2 = Vector2(-52, 42)
@export var half_width: float = 58.0

var _band: Polygon2D
var _centerline: PackedVector2Array = PackedVector2Array([
	Vector2(760, 248),
	Vector2(420, 196),
	Vector2(80, 214),
	Vector2(-260, 246),
	Vector2(-620, 292),
])
var _streaks: Array[Polygon2D] = []
var _streak_t: Array[float] = []


func _ready() -> void:
	z_index = 1
	_band = Polygon2D.new()
	_band.polygon = _ribbon(_centerline, half_width)
	_band.color = ChartStyle.CURRENT
	_band.z_index = 1
	add_child(_band)
	var edge := Polygon2D.new()
	edge.polygon = _ribbon(_centerline, half_width * 0.22)
	edge.color = ChartStyle.CURRENT_STREAK
	edge.color.a = 0.35
	edge.z_index = 1
	add_child(edge)
	for index: int in 6:
		var streak := Polygon2D.new()
		streak.polygon = _capsule(16.0, 5.0)
		streak.color = ChartStyle.CURRENT_STREAK
		streak.z_index = 1
		add_child(streak)
		_streaks.append(streak)
		_streak_t.append(float(index) / 6.0)


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
