class_name Hand extends Node

const CARD_UI_SCENE = preload("res://Scenes/card_ui.tscn")

@export var player: Player

var card_indices = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	player.hand_cards_added.connect(add_cards)
	player.hand_cards_removed.connect(remove_cards)

	for child in get_children():
		var card_ui := child as CardUI
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
		card_ui.save_index.connect(_on_card_ui_save_index_requested)


func add_cards(cards: Array[Card]) -> void:
	for c in cards:
		add_card(c)


func add_card(card: Card) -> void:
	var c_ui = CARD_UI_SCENE.instantiate() as CardUI
	c_ui.initialize(card, player)
	add_child(c_ui)
	c_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	c_ui.save_index.connect(_on_card_ui_save_index_requested)


func remove_cards(cards: Array[Card]) -> void:
	for c in cards:
		remove_card(c)


func remove_card(card: Card) -> void:
	var cui = get_card_ui(card)
	if cui == null:
		push_warning("No UI for card: " + str(card))
		return
	cui.queue_free()


func get_card_ui(card: Card) -> CardUI:
	for i in get_children():
		var cui := i as CardUI
		if cui.card == card:
			return cui
	return null


func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
	move_child(child, card_indices[child])


func _on_card_ui_save_index_requested(child: CardUI) -> void:
	card_indices[child] = child.get_index()