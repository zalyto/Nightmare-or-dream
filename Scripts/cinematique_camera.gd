extends Camera3D

var pnj_talking_pos := Vector3.ZERO
var couleur_du_pnj := Color.WHITE

@onready var medaillon: Node3D = $medaillon
@onready var anim_fade: AnimationPlayer = $Anim_fade
var cycle_day_night: AnimationPlayer

func _process(_delta: float) -> void:
	if cycle_day_night != null:
		return
	cycle_day_night = get_tree().get_first_node_in_group("cycle_day_night")

func get_player():
	return get_tree().get_first_node_in_group("player")
	
func get_player_camera():
	return get_tree().get_first_node_in_group("player_camera")

func start_cinematique():
	get_player().in_cinematique = true
	Ui.in_cinematique = true
	make_current()	
	medaillon.show()

func end_cinematique():
	get_player().in_cinematique = false
	Ui.in_cinematique = false
	get_player_camera().make_current()
	medaillon.hide()
	anim_fade.play("fade/fade")
func add_medaillon():
	Inventory.add_item("mon medaillon")
	
func soutitre_cinematique(text: String, duration: float):
	Soutitre.show_thought(text, duration)
	
func add_objectif(text: String):
	Ui.new_objectif(text)
	
func add_acte(text: String):
	Ui.acte(text)
	
func night():
	if cycle_day_night.animation_finished:
		cycle_day_night.play("cycle")

func day():
	if cycle_day_night.animation_finished:
		cycle_day_night.play("RESET")
