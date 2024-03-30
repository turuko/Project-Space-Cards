extends Node


@export var player: Player

const CARD_UI_SCENE = preload("res://Scenes/card_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.hand_cards_added.connect(add_cards)
	player.hand_cards_removed.connect(remove_cards)


func add_cards(cards: Array[Card]) -> void:
	for c in cards:
		add_card(c)


func add_card(card: Card) -> void:
	var c_ui = CARD_UI_SCENE.instantiate() as CardUI
	c_ui.initialize(card)
	add_child(c_ui)


func remove_cards(cards: Array[Card]) -> void:
	for c in cards:
		remove_card(c)


func remove_card(card: Card) -> void:
	var cui = get_card_ui(card)
	if cui == null:
		printerr("No UI for card: " + str(card))
		return
	cui.queue_free()


func get_card_ui(card: Card) -> CardUI:
	for i in get_children():
		var cui := i as CardUI
		if cui.card == card:
			return cui
	return null
