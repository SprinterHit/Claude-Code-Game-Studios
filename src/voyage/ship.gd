class_name Ship
extends Node2D

## Emitted when a touch or press sets a new heading.
signal heading_changed
## Player ship for one voyage.
##
## Sails at [member sail_speed] along [member heading], then adds the wind and
## the current. A touch press, a touch drag, or a left mouse-button press aims
## [member heading] from the ship toward that point. Hover does not.


## Pixels traveled per second along [member heading]. Tuned on the ship scene.
@export var sail_speed: float = 110.0

## Direction used from the start of the voyage until the first aim.
## Tuned on the ship scene. A zero vector sails west, toward the one coast.
@export var initial_heading: Vector2 = Vector2.LEFT

## Unit direction the ship is sailing. Holds until the next aim.
var heading: Vector2 = Vector2.LEFT:
	set(value):
		heading = _unit_or_west(value)
		rotation = heading.angle()

## Push from the wind, in pixels per second. The voyage writes this.
var wind_push: Vector2 = Vector2.ZERO

## Push from the current, in pixels per second. Zero when the ship is off the ribbon.
var current_push: Vector2 = Vector2.ZERO

var sailing: bool = true

## Squared distance below which the aim point defines no direction.
const MIN_AIM_DISTANCE_SQUARED: float = 0.0001

var _wake: Line2D


func _ready() -> void:
	add_to_group(&"player_ship")
	heading = initial_heading
	z_index = 6
	_wake = Line2D.new()
	_wake.top_level = true
	_wake.width = 10.0
	_wake.joint_mode = Line2D.LINE_JOINT_ROUND
	_wake.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_wake.end_cap_mode = Line2D.LINE_CAP_ROUND
	_wake.z_index = 4
	var fade := Gradient.new()
	fade.set_color(0, Color(ChartStyle.WAKE, 0.0))
	fade.set_color(1, ChartStyle.WAKE)
	_wake.gradient = fade
	add_child(_wake)


func integrate(delta: float) -> void:
	if not sailing:
		return
	global_position += (heading * sail_speed + wind_push + current_push) * delta
	_lay_wake()


func _unhandled_input(event: InputEvent) -> void:
	if not sailing:
		return
	if event is InputEventMouseMotion:
		return
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event as InputEventScreenTouch
		if touch.pressed and not touch.canceled:
			_aim_at_viewport_position(touch.position)
		return
	if event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event as InputEventScreenDrag
		_aim_at_viewport_position(drag.position)
		return
	if event is InputEventMouseButton:
		var button: InputEventMouseButton = event as InputEventMouseButton
		if button.pressed and not button.canceled and button.button_index == MOUSE_BUTTON_LEFT:
			_aim_at_viewport_position(button.position)


## Points the ship from its position toward [param world_point] and sails that way.
## A point with no direction from the ship leaves [member heading] unchanged.
func set_heading_toward(world_point: Vector2) -> void:
	var previous_heading := heading
	var offset: Vector2 = world_point - global_position
	if offset.length_squared() < MIN_AIM_DISTANCE_SQUARED:
		return
	heading = offset
	if not heading.is_equal_approx(previous_heading):
		heading_changed.emit()


## Ends movement and aim for this voyage. The ship stays where it is.
func stop_sailing() -> void:
	sailing = false
	_show_heading_tick(false)


## Starts another run of the same voyage. The heading tick comes back.
func resume_sailing() -> void:
	sailing = true
	_show_heading_tick(true)


func _show_heading_tick(visible_tick: bool) -> void:
	var tick := get_node_or_null("Heading") as Line2D
	if tick != null:
		tick.visible = visible_tick


func clear_wake() -> void:
	if _wake != null:
		_wake.clear_points()


func _aim_at_viewport_position(viewport_position: Vector2) -> void:
	set_heading_toward(_viewport_to_world(viewport_position))
	get_viewport().set_input_as_handled()


func _viewport_to_world(viewport_position: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * viewport_position


func _lay_wake() -> void:
	_wake.add_point(global_position - heading * 34.0 * scale.x)
	if _wake.get_point_count() > 36:
		_wake.remove_point(0)


func _unit_or_west(direction: Vector2) -> Vector2:
	if direction.length_squared() < MIN_AIM_DISTANCE_SQUARED:
		return Vector2.LEFT
	return direction.normalized()
