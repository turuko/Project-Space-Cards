class_name CreatureCard extends Card

@export var amount: int
@export var damage_per_unit: float
@export var health_per_unit: float
@export var armor_per_unit: float
@export var attacks_per_second: float

@export var unit_scene: PackedScene

var regiment_area_size: Vector2
var regiment_position: Vector2

func _on_played(player: Player) -> bool:
	var positions = _calculate_spawn_positions(regiment_area_size, unit_scene.instantiate() as Unit)
	var regiment = Regiment.new(unit_scene, regiment_area_size, regiment_position, positions, amount)
	player.add_child(regiment)
	return super(player)


func _calculate_spawn_positions(area: Vector2, unit_prototype: Unit) -> Array[Vector3]:
	var positions: Array[Vector3] = []

	var remaining = amount

	var max_units_x = floor(area.x / (unit_prototype.size.x +  (unit_prototype.size.x/2)))
	var rows = ceil(amount / max_units_x)

	var unit_x_spacing = area.x / min(max_units_x, amount)
	var unit_z_spacing = unit_prototype.size.z / 2

	for i in range(rows):
		var x = 0.0
		while x < area.x:
			var pos_x = (x + unit_prototype.size.x / 2)
			var pos_y = ((i * (1+unit_z_spacing)) + (unit_prototype.size.z / 2))

			x += unit_x_spacing
			positions.append(Vector3(pos_x, 1, pos_y))
			remaining -= 1

			if(remaining == 0):
				return positions

	return positions

