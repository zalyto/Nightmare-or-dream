extends Button

@onready var audio: AudioStreamPlayer = get_tree().get_first_node_in_group("sound_button")

var anim_speed := 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)
		
	if not self.mouse_exited.is_connected(_on_mouse_exited):
		self.mouse_exited.connect(_on_mouse_exited)
		


func _on_mouse_entered() -> void:
	audio.play()
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", scale*1.1, anim_speed)

func _on_mouse_exited() -> void:
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), anim_speed)
