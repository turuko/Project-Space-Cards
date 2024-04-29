extends Node3D

@export_range(0,1000) var move_speed: float

@export_range(0, 90) var min_elevation_angle: int = 10
@export_range(0, 90) var max_elevation_angle: int = 90
@export_range(0, 1000) var rotation_speed: float = 10

@export_range(0, 1000) var min_zoom: int = 10
@export_range(0, 1000) var max_zoom: int = 90
@export_range(0, 1000) var zoom_speed: float = 10
@export_range(0, 1) var zoom_speed_damp: float = 0.5

@export_range(0, 10) var pan_speed: float = 3

@export var allow_rotation: bool = true
@export var inverted_y: bool = false
@export var zoom_to_cursor: bool = true
@export var allow_pan = true


var _last_mouse_pos = Vector2()
var _is_rotating = false
var _is_panning = false
var _is_frozen = false
@onready var elevation = $Elevation
@onready var camera = $Elevation/MainCamera
@onready var tween: Tween
const GROUND_PLANE = Plane(Vector3.UP, 0)
const RAY_LENGTH = 1000

var _zoom_direction = 0


func _ready() -> void:
	Events.camera_freeze_requested.connect(_freeze)
	Events.camera_unfreeze_requested.connect(_unfreeze)
	Events.camera_jump_requested.connect(_jump_to_location)


func _process(delta: float) -> void:
	if _is_frozen:
		return
	_move(delta)
	_rotate(delta)
	_zoom(delta)
	_pan(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_rotate"):
		_is_rotating = true
		_last_mouse_pos = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		_is_rotating = false

	if event.is_action_pressed("camera_zoom_in"):
		_zoom_direction = -1
	if event.is_action_pressed("camera_zoom_out"):
		_zoom_direction = 1

	if event.is_action_pressed("camera_pan"):
		_is_panning = true
		_last_mouse_pos = get_viewport().get_mouse_position()
	if event.is_action_released("camera_pan"):
		_is_panning = false

func _move(delta: float) -> void:
	var velocity = Vector3()

	if Input.is_action_pressed("camera_forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		velocity += transform.basis.z

	if Input.is_action_pressed("camera_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		velocity += transform.basis.x

	velocity = velocity.normalized()

	_translate_position(velocity * delta * move_speed)


func _rotate(delta: float) -> void:
	if not _is_rotating or not allow_rotation:
		return

	var displacement = _get_mouse_displacement()

	_rotate_left_right(delta, displacement.x)
	_elevate(delta, displacement.y)


func _zoom(delta: float) -> void:
	if _zoom_direction == 0:
		return
	
	var new_zoom = clamp(camera.position.z + zoom_speed * delta * _zoom_direction, min_zoom, max_zoom)

	var pointing_at = _get_ground_click_location()

	camera.position.z = new_zoom

	if zoom_to_cursor and pointing_at != null:
		_realign_camera(pointing_at)

	_zoom_direction *= zoom_speed_damp
	if abs(_zoom_direction) <= 0.0001:
		_zoom_direction = 0


func _pan(delta: float) -> void:
	if not _is_panning or not allow_pan:
		return

	var displacement = _get_mouse_displacement()

	var velocity = (global_transform.basis.z * displacement.y +  global_transform.basis.x  * displacement.x) * delta * pan_speed

	_translate_position(-velocity)


func _jump_to_location(location: Vector3, duration: float) -> void:
	if tween != null:
		tween.kill() 
	tween = create_tween()
	tween.finished.connect(_end_jump)
	_freeze()
	tween.tween_property(self, "position", location, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)



func _get_mouse_displacement() -> Vector2:
	var current_mouse_pos = get_viewport().get_mouse_position()
	var displacement = current_mouse_pos - _last_mouse_pos;
	_last_mouse_pos = current_mouse_pos
	return displacement


func _rotate_left_right(delta: float, val: float) -> void:
	rotation_degrees.y += -val * delta * rotation_speed


func _elevate(delta: float, val: float) -> void:
	var new_elevation = elevation.rotation_degrees.x + -val * delta * rotation_speed if not inverted_y else elevation.rotation_degrees.x + val * delta * rotation_speed
	new_elevation = clamp(new_elevation, -max_elevation_angle, -min_elevation_angle)

	elevation.rotation_degrees.x = new_elevation


func _get_ground_click_location() -> Variant:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	return GROUND_PLANE.intersects_ray(ray_from, ray_to)


func _realign_camera(location: Vector3) -> void:
	var new_location = _get_ground_click_location()
	var displacement = location - new_location

	_translate_position(displacement)


func _translate_position(v: Vector3) -> void:
	position += v
	Events.camera_moved.emit(position)


func _freeze() -> void:
	_is_frozen = true

	
func _unfreeze() -> void:
	_is_frozen = false


func _end_jump() -> void:
	_unfreeze()
