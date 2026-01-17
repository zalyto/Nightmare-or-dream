extends TabBar

@onready var audio: AudioStreamPlayer = %button_sound

func _on_tab_hovered(_tab: int) -> void:
	audio.play()
