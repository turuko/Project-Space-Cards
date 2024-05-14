class_name Regiment extends Node3D

var regiment_area_size: Vector2
var unit_scene: PackedScene
var count: int


func _init(unit: PackedScene, _regiment_area_size: Vector2, _regiment_pos: Vector2, positions: Array[Vector3], _count: int):
	unit_scene = unit
	count = _count
	regiment_area_size = _regiment_area_size
	position = Vector3(_regiment_pos.x, 0, _regiment_pos.y)

	_spawn_units(positions)
	var jumper = JumpRequester.new()
	jumper.position = Vector3(position.x + regiment_area_size.x / 2, position.y, position.z + regiment_area_size.y / 2)
	jumper.duration = 1.5
	jumper.request_jump()
	add_child(jumper)


func _spawn_units(positions: Array[Vector3]) -> void:
	var unit_prototype = unit_scene.instantiate() as Unit

	for pos in positions:
		var unit_instance = unit_scene.instantiate() as Unit
		unit_instance.position = pos
		add_child(unit_instance)



