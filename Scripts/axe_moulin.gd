@tool
extends Node3D



func _enter_tree() -> void:
	set_process(true)
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		rotate_x(1 * delta)
