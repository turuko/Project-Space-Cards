class_name SpellCard extends Card


func _on_played(player: Player) -> void:
	for e in effects:
		if e.condition == CardEffect.TriggerCondition.ON_PLAYED:
			e.apply()
	player.graveyard.add_card(self)
