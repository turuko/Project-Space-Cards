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
	var regiment = Regiment.new(unit_scene, regiment_area_size, regiment_position, amount)
	player.add_child(regiment)
	return super(player)
