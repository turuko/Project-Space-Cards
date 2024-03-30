class_name CardPile extends Resource

signal card_pile_changed(size: int)

@export var cards:  Array[Card]

func is_empty() -> bool:
	return cards.is_empty()


func draw_cards(num: int) -> Array[Card]:
	if cards.size() <= 0:
		return []
	
	var cards_drawn: Array[Card] = []
	for i in range(num):
		cards_drawn.append(cards.pop_front())

	card_pile_changed.emit(cards.size())
	return cards_drawn


func shuffle() -> void:
	cards.shuffle()


func add_card(card: Card) -> void:
	cards.append(card)
	card_pile_changed.emit(cards.size())


func add_cards(cs: Array[Card]) -> void:
	for c in cs:
		add_card(c)


func remove_card(card: Card) -> void:
	cards.erase(card)


func clear() -> void:
	cards.clear()
	card_pile_changed.emit(cards.size())
	
	
func size() -> int:
	return cards.size()


func _to_string():
	var card_strings: PackedStringArray = []
	for i in range(cards.size()):
		card_strings.append("[%s: %s]" % [i+1, cards[i].name])
	return "\n".join(card_strings)
