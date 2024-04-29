class_name Regiment extends Node3D

var regiment_area_size: Vector2
var unit_scene: PackedScene
var count: int


func _init(unit: PackedScene, _regiment_area_size: Vector2, _regiment_pos: Vector2, _count: int):
	unit_scene = unit
	count = _count
	regiment_area_size = _regiment_area_size
	position = Vector3(_regiment_pos.x, 0, _regiment_pos.y)

	_spawn_units()


func _spawn_units() -> void:
	var unit_prototype = unit_scene.instantiate() as Unit
	var spawn_positions = _calculate_spawn_positions(unit_prototype)

	for pos in spawn_positions:
		var unit_instance = unit_scene.instantiate() as Unit
		unit_instance.position = pos
		add_child(unit_instance)


func _calculate_spawn_positions(unit_prototype: Unit) -> Array[Vector3]:
	var positions: Array[Vector3] = []

	var remaining = count

	var max_units_x = floor(regiment_area_size.x / (unit_prototype.size.x +  (unit_prototype.size.x/2)))
	var rows = ceil(count / max_units_x)

	var unit_x_spacing = regiment_area_size.x / min(max_units_x, count)
	var unit_z_spacing = unit_prototype.size.z / 2

	for i in range(rows):
		var x = 0.0
		while x < regiment_area_size.x:
			var pos_x = (x + unit_prototype.size.x / 2)
			var pos_y = ((i * (1+unit_z_spacing)) + (unit_prototype.size.z / 2))

			x += unit_x_spacing
			positions.append(Vector3(pos_x, 1, pos_y))
			remaining -= 1

			if(remaining == 0):
				return positions

	return positions
