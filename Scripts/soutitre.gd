extends Control

@onready var label: Label = null
@onready var soutitre: Control = null
var is_showing := false

func _ready() -> void:
	soutitre = get_tree().get_first_node_in_group("soutitre")
	label = get_tree().get_first_node_in_group("label_soutitre")
	soutitre.visible = false

func show_thought(text: String, duration := 3.0):
	if is_showing:
		return
	
	is_showing = true
	label.text = text
	soutitre.visible = true
	
	await get_tree().create_timer(duration).timeout
	
	soutitre.visible = false
	label.text = ""
	is_showing = false
