extends Node

@onready var Player := AudioStreamPlayer.new()
var music := load("res://assets/audio/music/synth_type.mp3")
var base_volume = -15.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(Player)
	Player.stream = music
	Player.volume_db = base_volume
	Player.play()
	
func stop_music():
	if Player != null:
		Player.volume_db = lerp(Player.volume_db, -80.0, 1.5)
	
func play_music(volume: float = base_volume):
	Player.volume_db = lerp(Player.volume_db, volume, 1.5)
