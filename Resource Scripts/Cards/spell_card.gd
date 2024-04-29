class_name SpellCard extends Card


func _on_played(player: Player) -> bool:

	var no_targets = false

	for e in effects:
		if e.targets == []:
			no_targets = true
			break

	if no_targets:
		return false

	for e in effects:
		if e.condition == CardEffect.TriggerCondition.ON_PLAYED:
			e.apply()
	return super(player)
