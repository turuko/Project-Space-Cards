extends CardState

var played: bool

func enter() -> void:
	card_ui.state.text = "RELEASED"

	played = card_ui.player.play_card(card_ui.card)


func on_input(_event: InputEvent) -> void:
	if played:
		card_ui.queue_free()
		return

	card_ui.modulate.a = 1.0
	transition_requested.emit(self, CardState.State.BASE)