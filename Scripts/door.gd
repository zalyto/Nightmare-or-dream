extends StaticBody3D

var open = true
var tween = create_tween()
var coldown : Timer
@export var locked = false
@export var cles_requise : String
@export var feedback : String
@export var add_objective_if_is_locked : String
@export var add_objective_if_is_unlocked : String
@export var is_locked_story_states : int
@export var is_unlocked_story_states : int

@onready var audio_open: AudioStreamPlayer3D = $audio_open
@onready var audio_close: AudioStreamPlayer3D = $audio_close
@onready var audio_locked: AudioStreamPlayer3D = $audio_locked

func _ready() -> void:
	coldown = Timer.new()
	add_child(coldown)
	coldown.one_shot = true
	coldown.wait_time = 0.8

var is_shaking: bool = false

func interact():

	if Inventory.has_item(cles_requise):
		locked = false
		Inventory.remove_item(cles_requise)
		
		# quand on deverouille la porte ajouté un nouvelle objectif
		if add_objective_if_is_unlocked != "":
			Ui.new_objectif(add_objective_if_is_unlocked)
		
	if locked:
		# si la porte est verrouiller changer le story states
		if is_locked_story_states != 0:
			StoryStates.states = is_locked_story_states
			
		# ajouter un feedback comme quoi la porte est verrouiller
		if not Ui.queue_msg.has("DOOR_LOCKED"):
			Ui.feedback("DOOR_LOCKED", 1.5)
			
		# ajouter un soutitre de penser du perso comme quoi la porte est verrouiller
		if feedback != "":
			Soutitre.show_thought(feedback, 5)
			
		# si la porte est verrouiller ajouté un nouvelle objectif
		if add_objective_if_is_locked != "":
			Ui.new_objectif(add_objective_if_is_locked)
			
		
		if is_shaking == false:
			audio_locked.play()
			is_shaking = true
			var tween_shake = create_tween()
			tween_shake.tween_property(self, "rotation:y", rotation.y + deg_to_rad(3), 0.05)
			tween_shake.tween_property(self, "rotation:y", rotation.y - deg_to_rad(3), 0.05)
			tween_shake.tween_property(self, "rotation:y", rotation.y + deg_to_rad(2), 0.05)
			tween_shake.tween_property(self, "rotation:y", rotation.y, 0.05)
			
			tween_shake.finished.connect(func():
				is_shaking = false
				)
		return
		
		
	else:
		if is_unlocked_story_states != 0:
			StoryStates.states = is_unlocked_story_states

	print("Interaction avec une porte")
	rotate_door()
	
func rotate_door():
	if coldown.time_left > 0:
		return
	coldown.start()
	open = !open
	if open == true:
		audio_open.play()
		tween = create_tween()
		tween.tween_property(self, "rotation_degrees:y", 90.0, 0.8).as_relative().set_trans(Tween.TRANS_SINE)
	else:
		audio_close.play()
		tween = create_tween()
		tween.tween_property(self, "rotation_degrees:y", -90.0, 0.8).as_relative().set_trans(Tween.TRANS_SINE)
	
