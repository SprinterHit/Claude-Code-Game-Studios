class_name WindField
extends Node2D
## Trade-wind arrows. The push turns once, after the ship is close enough to see the shore.


@export var push: Vector2 = Vector2(-64, -28)
@export var shifted_push: Vector2 = Vector2(-48, 36)
@export var shift_x: float = 180.0
@export var field_origin: Vector2 = Vector2(-160, -420)
@export var field_size: Vector2 = Vector2(1500, 980)
@export var spacing: float = 168.0

var shifted: bool = false

var _opening_push: Vector2 = Vector2(-64, -28)
var _arrows: Array[Node2D] = []


func _ready() -> void:
	z_index = 2
	_opening_push = push
	_build_arrows()


func arrow_count() -> int:
	return _arrows.size()


func vector_at(_world_point: Vector2) -> Vector2:
	return push


## Push used by the predicted track, including the turn that has not happened yet.
func forecast_push(world_point: Vector2) -> Vector2:
	if shifted or world_point.x <= shift_x:
		return shifted_push
	return _opening_push


func shift() -> void:
	if shifted:
		return
	shifted = true
	push = shifted_push
	_aim_arrows()


func reset() -> void:
	shifted = false
	push = _opening_push
	_aim_arrows()


func _process(delta: float) -> void:
	var step := Vector2.ZERO
	if push.length_squared() > 0.001:
		step = push.normalized() * 36.0 * delta
	var bounds := Rect2(field_origin, field_size)
	for arrow: Node2D in _arrows:
		arrow.position += step
		arrow.position = _wrap(arrow.position, bounds)


func _build_arrows() -> void:
	var columns := int(field_size.x / spacing) + 1
	var rows := int(field_size.y / spacing) + 1
	for row: int in rows:
		for column: int in columns:
			var arrow := WindArrow.new()
			arrow.position = field_origin + Vector2(column * spacing, row * spacing)
			arrow.position += Vector2(0.0 if row % 2 == 0 else spacing * 0.5, 0.0)
			arrow.rotation = push.angle()
			add_child(arrow)
			_arrows.append(arrow)


func _aim_arrows() -> void:
	var angle := push.angle()
	for arrow: Node2D in _arrows:
		arrow.rotation = angle


func _wrap(point: Vector2, bounds: Rect2) -> Vector2:
	var wrapped := point
	if wrapped.x < bounds.position.x:
		wrapped.x += bounds.size.x
	elif wrapped.x > bounds.end.x:
		wrapped.x -= bounds.size.x
	if wrapped.y < bounds.position.y:
		wrapped.y += bounds.size.y
	elif wrapped.y > bounds.end.y:
		wrapped.y -= bounds.size.y
	return wrapped
