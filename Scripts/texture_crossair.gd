extends TextureRect


var gradien_activate : GradientTexture2D = load("res://assets/sprites/ui/activate.tres")
var gradien_normal : GradientTexture2D = load("res://assets/sprites/ui/normal.tres")

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("interact"):
		self.texture = gradien_activate
	else:
		self.texture = gradien_normal
		
	
	
