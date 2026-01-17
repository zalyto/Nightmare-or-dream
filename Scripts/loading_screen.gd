extends Control

@onready var animation_player: AnimationPlayer = $fade/AnimationPlayer

var next_sceen = "res://Scenes/main.tscn" #main
var fade_out := false

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_sceen)
	Ui.hide_ui()
	$fade.show()
func _process(_delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(next_sceen, progress)
	if !progress[0] == 0:
		$ProgressBar.value = progress[0]*100
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next_sceen)
		if fade_out == false:
			animation_player.play_backwards("fade_in")
			MusicManager.stop_music()
			await animation_player.animation_finished
			fade_out = true
			
		
		get_tree().change_scene_to_packed(packed_scene)
		Ui.in_menu_principal = false
		Ui.menu_visible()
		Ui.show_ui()
