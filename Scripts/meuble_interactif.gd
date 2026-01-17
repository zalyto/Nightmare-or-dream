extends StaticBody3D
@onready var anim: AnimationPlayer = $AnimationPlayer

var sound_open: AudioStreamPlayer3D
var sound_close: AudioStreamPlayer3D

func _ready() -> void:
	sound_open = $sound_open
	sound_close = $sound_close
	remove_from_group("interacteble")

var open
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if StoryStates.states >= 1:
		add_to_group("interacteble")
	
func interact():
	if  !anim.is_playing():
		open = !open
		if open:
			anim.play("anim/open")
			sound_open.play()
		else:
			anim.play_backwards("anim/open")
			sound_close.play()
