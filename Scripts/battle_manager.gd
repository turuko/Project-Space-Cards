class_name BattleManager extends Node

@export var draw_button: Button
@export var discard_button: Button
@export var player: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	draw_button.pressed.connect(player.draw_card)
	discard_button.pressed.connect(discard_first_card)


func discard_first_card() -> void:
	if player.hand.size() <= 0:
		return
	var first_card := player.hand.cards[0]
	player.discard_card(first_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
