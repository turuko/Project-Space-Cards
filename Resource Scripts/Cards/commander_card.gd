class_name CommanderCard extends Card

@export var damage: float
@export var health: float
@export var armor: float
@export var attacks_per_second: float
@export var unit: PackedScene #Unit scene

var position: Vector3

func _on_played(player: Player) -> bool:
	var unit_instance = unit.instantiate() as Unit
	unit_instance.position = position

	var jumper = JumpRequester.new()
	jumper.position = position
	jumper.duration = 1.5
	jumper.request_jump()
	unit_instance.add_child(jumper)

	player.add_child(unit_instance)
	return super(player)