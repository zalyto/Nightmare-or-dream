extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SimpleGrass.set_interactive(true)
	
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("space"):
		#Engine.time_scale = 5.0
	#else:
		#Engine.time_scale = 1.0
