extends CardState


func enter() -> void:
	card_ui.state.text = "CLICKED"
	
	
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
