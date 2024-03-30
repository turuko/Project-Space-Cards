class_name Player extends Node

signal hand_cards_added(card: Array[Card])
signal hand_cards_removed(card: Array [Card])

@export var starting_deck: CardPile

var deck: CardPile
var draw_pile: CardPile
var graveyard: CardPile
var hand: CardPile
var hand_max: int = 10

var max_health: float
var health: Health
var mana: int
var mana_reset_value: int


# Called when the node enters the scene tree for the first time.
func _ready():
	deck = CardPile.new()
	for c in starting_deck.cards:
		var card = c.duplicate()
		card.init_descriptions()
		deck.add_card(card)
		
	draw_pile = CardPile.new()
	draw_pile.add_cards(deck.cards)
	
	draw_pile.shuffle()

	hand = CardPile.new()

	graveyard = CardPile.new()

	health = Health.new(max_health)

	draw_cards(3)


##Card related functions
func draw_cards(n: int) -> void:
	for i in n:
		draw_card()
	
func draw_card() -> void:
	var card_drawn := draw_pile.draw_cards(1)
	if card_drawn == []:
		return

	print("Hand:\n" + str(hand) + "\nGraveyard:\n" + str(graveyard) + "\nDraw Pile:\n" + str(draw_pile))
	
	if hand.size() + 1 > hand_max:
		print("Hand full")
		graveyard.add_card(card_drawn[0])
		return
	
	hand.add_card(card_drawn[0])

	hand_cards_added.emit(card_drawn)
	

func play_card(card: Card) -> void:
	if mana < card.cost:
		return
	
	mana -= card.cost
	hand.remove_card(card)
	card._on_played(self)

	hand_cards_removed.emit([card])
	

func discard_card(card: Card) -> void:
	hand.remove_card(card)
	graveyard.add_card(card)

	var cards: Array[Card] = [card]
	hand_cards_removed.emit(cards)


func reset_mana() -> void:
	mana = mana_reset_value


