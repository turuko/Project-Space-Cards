class_name Card extends Resource

@export var cost: int
@export var art: Texture2D
@export var name: String
@export var flavor_text: String

@export var effects: Array[CardEffect]

func _on_played(player: Player) -> void:
	pass
	
	
func init_descriptions():
	for e in effects:
		e._init_description()
