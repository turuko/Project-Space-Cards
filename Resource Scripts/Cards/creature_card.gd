class_name CreatureCard extends Card

@export var amount: int
@export var damage_per_unit: float
@export var health_per_unit: float
@export var armor_per_unit: float
@export var attacks_per_second: float


func _on_played(player: Player) -> void:
	pass
