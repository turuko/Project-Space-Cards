class_name JumpRequester extends Node3D

@export_range(0.1, 5) var duration: float = 1

func _ready() -> void:
	add_to_group("jump_requesters")


func request_jump() -> void:
	Events.camera_jump_requested.emit(position, duration)
