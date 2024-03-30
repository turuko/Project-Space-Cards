class_name DamageEffect extends CardEffect


@export var damage: float

func _init_description():
	description = "Deal " + str(damage) + " damage"

func apply() -> void:
	deal_damage()
	
	
func deal_damage() -> void:
	for t in targets:
		#TODO: take damage
		#t.take_damage(damage)
		pass

