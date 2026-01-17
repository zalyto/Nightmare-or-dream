extends Control
@onready var option_panel: Panel = $option



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ui.in_menu_principal = true
	Ui.hide_ui()
	option_panel.visible = false
	$fade.show()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/loading_screen.tscn"))

func _on_option_pressed() -> void:
	option_panel.visible = true


func _on_back_pressed() -> void:
	option_panel.visible = false


func _on_quitter_pressed() -> void:
	get_tree().quit()
