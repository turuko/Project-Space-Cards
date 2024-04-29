extends CardState

var initial_mouse_pos

func enter() -> void:
	initial_mouse_pos = Utilities.get_ground_click_location()
	card_ui.state.text = "AIMING"
	card_ui.modulate.a = 0.5
	pass


func on_input(_event: InputEvent) -> void:


	#Show an aiming "arrow"
	if card_ui.card is SpellCard:
		pass

	#Show an aiming rectangle to visualize regiment area placement
	if card_ui.card is CreatureCard:
		var creature = card_ui.card as CreatureCard
		if _event.is_action_released("left_mouse") or _event.is_action_pressed("left_mouse"):
			var current_mouse_pos = Utilities.get_ground_click_location()
			var v3 = (current_mouse_pos - initial_mouse_pos).abs()
			Utilities.draw_rect(initial_mouse_pos, current_mouse_pos)

			var _area = Vector2(v3.x, v3.z)
			creature.regiment_area_size = _area

			creature.regiment_position = Vector2(min(initial_mouse_pos.x, current_mouse_pos.x), 
                min(initial_mouse_pos.z, current_mouse_pos.z))

			transition_requested.emit(self, CardState.State.RELEASED)

	#Show preview of commander to visualize placement
	if card_ui.card is CommanderCard:
		pass
