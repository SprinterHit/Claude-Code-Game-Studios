class_name Ship
extends Node2D
## Player ship for one voyage.
##
## Sails at [member sail_speed] along [member heading]. A touch press, a touch
## drag, or a left mouse-button press aims [member heading] from the ship toward
## that point in world space. Hover and mouse motion do not change heading.
##
## Example:
##     var ship := Ship.new()
##     ship.set_heading_toward(ship.global_position + Vector2.RIGHT)


## Pixels traveled per second along [member heading]. Tuned on the ship scene.
@export var sail_speed: float = 120.0

## Direction used from the start of the voyage until the first aim.
## Tuned on the ship scene. A zero vector sails east.
@export var initial_heading: Vector2 = Vector2.RIGHT

## Unit direction the ship is sailing. Holds until the next aim.
##
## Example:
##     var direction: Vector2 = ship.heading
var heading: Vector2 = Vector2.RIGHT:
	set(value):
		heading = _unit_or_east(value)
		rotation = heading.angle()

## Squared distance below which the aim point defines no direction.
const MIN_AIM_DISTANCE_SQUARED: float = 0.0001


func _ready() -> void:
	add_to_group(&"player_ship")
	heading = initial_heading


func _physics_process(delta: float) -> void:
	global_position += heading * sail_speed * delta


func _unhandled_input(event: InputEvent) -> void:
	# Motion without a press never aims, including when a button mask is set.
	# A held mouse is delivered again as InputEventScreenDrag when
	# input_devices/pointing/emulate_touch_from_mouse is enabled.
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
		# Left press only. Device id is not compared: Godot 4.7 reports the
		# mouse as InputEvent.DEVICE_ID_MOUSE, and an emulated event may use
		# InputEvent.DEVICE_ID_EMULATION. A joypad may use 0.
		if button.pressed and not button.canceled and button.button_index == MOUSE_BUTTON_LEFT:
			_aim_at_viewport_position(button.position)


## Points the ship from its position toward [param world_point] and sails that way.
## A point with no direction from the ship leaves [member heading] unchanged.
##
## Example:
##     ship.set_heading_toward(ship.global_position + Vector2(0.0, -1.0))
func set_heading_toward(world_point: Vector2) -> void:
	var offset: Vector2 = world_point - global_position
	if offset.length_squared() < MIN_AIM_DISTANCE_SQUARED:
		return
	heading = offset


func _aim_at_viewport_position(viewport_position: Vector2) -> void:
	set_heading_toward(_viewport_to_world(viewport_position))
	get_viewport().set_input_as_handled()


func _viewport_to_world(viewport_position: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * viewport_position


func _unit_or_east(direction: Vector2) -> Vector2:
	if direction.length_squared() < MIN_AIM_DISTANCE_SQUARED:
		return Vector2.RIGHT
	return direction.normalized()
