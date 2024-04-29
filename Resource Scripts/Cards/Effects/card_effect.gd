class_name CardEffect extends Resource

#Defines who an effect can target. Is used in array to combine different targets. E.G: [UNIT, PLAYER, ENEMY] for a single target effect that targets units or players
enum TargetingType
{
	UNIT,
	PLAYER,
	MULTIPLE,
	ALL,
	ENEMY,
	ALLY
}

#When should the effect trigger
enum TriggerCondition
{
	ON_PLAYED,
	ON_DEATH,
	ON_ACTIVATION,
}

@export var targeting: Array[TargetingType]
@export var description: String
@export var condition: TriggerCondition

var targets: Array = [] # TODO: Define types that can be in this array

#This function should be implemented in subclasses of CardEffect. E.g: A DamageEffect would implement this as apply(x) -> deal x damage to targets
func _apply() -> void:
	pass
	
	
func _init_description() -> void:
	pass
