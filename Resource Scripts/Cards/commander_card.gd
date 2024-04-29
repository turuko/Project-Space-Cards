class_name CommanderCard extends Card

@export var damage: float
@export var health: float
@export var armor: float
@export var attacks_per_second: float
@export var unit: PackedScene #Unit scene

func _on_played(player: Player) -> bool:
	var unit_instance = unit.instantiate() as Unit
	player.add_child(unit_instance)
	return super(player)