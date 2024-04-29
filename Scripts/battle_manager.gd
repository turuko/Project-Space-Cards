class_name BattleManager extends Node

@export var draw_button: Button
@export var discard_button: Button
@export var toggle_freeze_button: Button
@export var player: Player

var is_camera_frozen = false
var _last_idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_button.pressed.connect(player.draw_card)
	discard_button.pressed.connect(discard_first_card)
	toggle_freeze_button.pressed.connect(_toggle_freeze)


func discard_first_card() -> void:
	if player.hand.size() <= 0:
		return
	var first_card := player.hand.cards[0]
	player.discard_card(first_card)


func _toggle_freeze() -> void:
	if is_camera_frozen:
		Events.camera_unfreeze_requested.emit()
		toggle_freeze_button.text = "Freeze Camera"
	else:
		Events.camera_freeze_requested.emit()
		toggle_freeze_button.text = "Unfreeze Camera"
	is_camera_frozen = !is_camera_frozen


func _input(event):
	if event.is_action_pressed("camera_jump"):
		var requester = _get_requester()
		requester.request_jump()


func _get_requester() -> JumpRequester:
	var requesters = get_tree().get_nodes_in_group("jump_requesters")
	var num_requesters = requesters.size()
	var new_idx = randi() % num_requesters
	if new_idx == _last_idx:
		new_idx	= (new_idx + 1) % num_requesters
	_last_idx = new_idx
	return requesters[new_idx]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
