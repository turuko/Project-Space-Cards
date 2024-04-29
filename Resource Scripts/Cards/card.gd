class_name Card extends Resource

@export var cost: int
@export var art: Texture2D
@export var name: String
@export var flavor_text: String

@export var effects: Array[CardEffect]

func _on_played(player: Player) -> bool:
	player.graveyard.add_card(self)
	print("Hand:\n" + player.hand._to_string() + "\nGraveyard:\n" + player.graveyard._to_string())
	return true
	
	
func init_descriptions():
	for e in effects:
		e._init_description()
