extends CardState


func enter() -> void:
	card_ui.state.text = "DRAGGING"
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.save_index.emit(card_ui)
		card_ui.reparent(ui_layer)
		
		
func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel := event.is_action_pressed("right_mouse")
	var confirm := event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	var y_threshold = get_viewport().size.y - (get_viewport().size.y / 3)

	
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset

	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled()

		if card_ui.get_global_mouse_position().y > y_threshold:
			transition_requested.emit(self, CardState.State.BASE)
		else:
			transition_requested.emit(self, CardState.State.RELEASED)
		
