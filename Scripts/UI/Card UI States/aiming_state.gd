extends CardState

var initial_mouse_pos
var previews = []
var mat

func enter() -> void:
	initial_mouse_pos = Utilities.get_ground_click_location()
	card_ui.state.text = "AIMING"
	card_ui.visible = false
	pass


var preview

func on_input(_event: InputEvent) -> void:

	if preview != null:
		preview.queue_free()

	#preview = Utilities.draw_rect(initial_mouse_pos, Utilities.get_ground_click_location())
	
	var current_mouse_pos = Utilities.get_ground_click_location()
	

	#Show an aiming "arrow"
	if card_ui.card is SpellCard:
		pass

	#Show an aiming rectangle to visualize regiment area placement
	if card_ui.card is CreatureCard:
		var creature = card_ui.card as CreatureCard
		_draw_creature_preview(creature, initial_mouse_pos, current_mouse_pos)

		if _event.is_action_released("left_mouse") or _event.is_action_pressed("left_mouse"):

			mat.albedo_color.a = 1
			var v3 = (current_mouse_pos - initial_mouse_pos).abs()
			var _area = Vector2(v3.x, v3.z)
			creature.regiment_area_size = _area

			creature.regiment_position = Vector2(min(initial_mouse_pos.x, current_mouse_pos.x), 
				min(initial_mouse_pos.z, current_mouse_pos.z))

			transition_requested.emit(self, CardState.State.RELEASED)

	#Show preview of commander to visualize placement
	if card_ui.card is CommanderCard:
		var commander = card_ui.card as CommanderCard
		_draw_commander_preview(commander, current_mouse_pos)

		if _event.is_action_released("left_mouse") or _event.is_action_pressed("left_mouse"):

			mat.albedo_color.a = 1
			commander.position = current_mouse_pos + Vector3(0, (commander.unit.instantiate() as Unit).size.y / 2, 0)

			transition_requested.emit(self, CardState.State.RELEASED)


func _draw_creature_preview(creature: CreatureCard, pos1: Vector3, pos2: Vector3) -> void:
	preview = Utilities.draw_rect(pos1, pos2)
	
	for u in previews:
		if u != null:
			u.queue_free()

	var v3 = (pos1 - pos2).abs()
	#Draw preview
	var _area = Vector2(v3.x, v3.z)
	var positions = creature._calculate_spawn_positions(_area, creature.unit_scene.instantiate() as Unit)

	for p in positions:
		var unit_instance = creature.unit_scene.instantiate() as Unit
		unit_instance.position = p + Vector3(min(pos1.x, pos2.x), 0,
				min(pos1.z, pos2.z))
		if mat == null:
			var mesh_i = (unit_instance.find_child("MeshInstance3D") as MeshInstance3D)
			mat = mesh_i.mesh.material
		mat.albedo_color.a = 0.3
		previews.append(unit_instance)
		add_child(unit_instance)


func _draw_commander_preview(commander: CommanderCard, pos: Vector3) -> void:
	var commander_unit = commander.unit.instantiate() as Unit
	preview = Utilities.draw_rect(pos + -Vector3(commander_unit.size.x / 2, 0, commander_unit.size.z / 2), pos + Vector3(commander_unit.size.x / 2, 0, commander_unit.size.z / 2))

	for u in previews:
		if u != null:
			u.queue_free()

	commander_unit.position = pos + Vector3(0, commander_unit.size.y / 2, 0)
	if mat == null:
			var mesh_i = (commander_unit.find_child("MeshInstance3D") as MeshInstance3D)
			mat = mesh_i.mesh.material
	mat.albedo_color.a = 0.3
	previews.append(commander_unit)
	add_child(commander_unit)

	
