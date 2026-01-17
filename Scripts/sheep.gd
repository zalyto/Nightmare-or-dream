extends Node3D

@export var time_scale : float = 1
@onready var animation_player: AnimationPlayer = $Sketchfab_Scene/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.speed_scale = time_scale
