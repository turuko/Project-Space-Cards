class_name Health extends Node

var health: float
var max_health: float

func _init(_max_health: float):
	health = _max_health
	max_health = _max_health


##Stats related functions
func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		die()


func heal(amount: float) -> void:
	health += amount
	clampf(health, 0, max_health)


#TODO: Implement death
func die() -> void:
	pass
