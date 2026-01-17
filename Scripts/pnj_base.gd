extends StaticBody3D
# Exporter la variable pour la rendre modifiable dans l'éditeur Godot
@export var nom: String = "basename"
@export var value: Color
var look_object 
@onready var label_pnj: Label3D = %Label_pnj
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
var in_dialog := false

@export var movement_rule: Array[Dictionary] = [
	{
		"state": 0,
		"position": Vector3.ZERO,
		"rotation": Vector3.ZERO
	}
]


func _ready():
	DialogueManager.dialogue_ended.connect(_on_dialog_ended)
	# Ajoute le PNJ au groupe "PNJ" pour que le raycast puisse le détecter
	add_to_group("interacteble")
	label_pnj.text = nom
	label_pnj.set_modulate(value)
	look_object = get_tree().get_first_node_in_group("head_player")
	
	#if not movement_rule.is_empty():
		#for rule in movement_rule:
			#var parent = get_parent()
			##if rule["state"] == 0:
			#rule["position"] = parent.global_position
			#rule["rotation"] = parent.global_rotation

func _on_dialog_ended(_SIRE):
	Ui.in_dialog = false
	Ui.menu_visible()
	Ui.in_cinematique = false
	in_dialog = false
	print("fin du dialogue")
	
func interact():
	if in_dialog == true:
		return
	print("Interaction avec le PNJ")
	# Démarre le dialogue en utilisant le singleton Ui
	audio.play()
	print(get_parent().name)
	
	Ui.in_dialog = true
	Ui.menu_visible()
	Ui.in_cinematique = true
	in_dialog = true
	
	#Resource des dialogue------------------------------------------
	const SIRE = preload("uid://bfod64dtuoyw5")
	const INSPECTER = preload("uid://cy3iu2xvhdnjl")
	const AGNES = preload("uid://cv14t4tbnlehs")
	const ALPHONSE = preload("uid://du6qegsvxlxvx")
	const BIERE_NARD = preload("uid://bdc3lyev8cf1w")
	const GARDE_DECHILD = preload("uid://c6m6545hwsj7g")
	const JÉNNY = preload("uid://bxr6a8jsoy6c7")
	const LENNY = preload("uid://c7w01ncxdhlbw")
	
	# LANCER LES DIALOG EN FONCTION DU PNJ----------------------------
	if get_parent().name == "sire":
		DialogueManager.show_dialogue_balloon(SIRE, "start")

	elif get_parent().name == "inspecter_gaga":
		DialogueManager.show_dialogue_balloon(INSPECTER, "start")
		
	elif get_parent().name == "Jénny":
		DialogueManager.show_dialogue_balloon(JÉNNY, "start")
		
	elif get_parent().name == "Alphonse":
		DialogueManager.show_dialogue_balloon(ALPHONSE, "start")
		
	elif get_parent().name == "Bière-nard_Bush":
		DialogueManager.show_dialogue_balloon(BIERE_NARD, "start")
		
	elif get_parent().name == "Lenny":
		DialogueManager.show_dialogue_balloon(LENNY, "start")
		
	elif get_parent().name == "agnes":
		DialogueManager.show_dialogue_balloon(AGNES, "start")
		
	elif get_parent().name == "garde_dechild":
		DialogueManager.show_dialogue_balloon(GARDE_DECHILD, "start")
		
	else:
		print("il n'y a pas de dialogue pour ce pnj")
		Ui.in_dialog = false
		Ui.menu_visible()
		Ui.in_cinematique = false
		in_dialog = false
		return
		
	CinematiqueCamera.pnj_talking_pos = get_parent().get_node("PNJ_BASE/neck").global_position
	CinematiqueCamera.couleur_du_pnj = value

#regardé la tete du joueur
@onready var neck = %neck
@onready var skeleton = $"../character/Skeleton3D"
var new_rotation
var max_horizontal_angle = 90
var max_vertical_angle = 20
var bonesmoothrot = 0.0
var distance: float = 3

func look_at_object(delta):
	if get_tree().paused:
		return
	if global_position.distance_to(look_object.global_position) < distance:
		var neck_bone = skeleton.find_bone("Neck")
		neck.look_at(look_object.global_position, Vector3.UP ,true)
		var marker_rotation_degrees = neck.rotation_degrees
		marker_rotation_degrees.x = clamp(marker_rotation_degrees.x, -max_vertical_angle, max_vertical_angle)
		marker_rotation_degrees.y = clamp(marker_rotation_degrees.y, -max_horizontal_angle, max_horizontal_angle)
		bonesmoothrot = lerp_angle(bonesmoothrot, deg_to_rad(marker_rotation_degrees.y), 2 * delta)
		new_rotation = Quaternion.from_euler(Vector3(deg_to_rad(marker_rotation_degrees.x), bonesmoothrot, 0))
		skeleton.set_bone_pose_rotation(neck_bone, new_rotation)
	else:
		# Code pour ramener le cou à sa position par défaut
		var neck_bone = skeleton.find_bone("Neck")
		
		# 1. Remettre bonesmoothrot à 0 (l'angle de base pour l'axe Y)
		# On utilise lerp_angle pour une transition douce
		bonesmoothrot = lerp_angle(bonesmoothrot, 0.0, 5 * delta) # J'ai augmenté la vitesse (5) pour que ça revienne vite.
		
		# 2. Définir la nouvelle rotation comme (0, bonesmoothrot, 0)
		# La rotation X revient immédiatement à 0 (regarder droit), et Y est l'angle lissé.
		# On assume que la rotation X est lue directement de 'neck.rotation_degrees.x' dans le 'if', 
		# donc pour revenir à zéro on le met explicitement à 0.0 ici.
		var reset_rotation = Quaternion.from_euler(Vector3(0.0, bonesmoothrot, 0))
		
		# 3. Appliquer la rotation lissée
		skeleton.set_bone_pose_rotation(neck_bone, reset_rotation)

func _process(delta: float) -> void:

	if get_tree().paused:
		return 
	if look_object != null:
		look_at_object(delta)
	else:
		print("ERRORE : pnj ne trouve pas la tete du joueur pour regarder dans ça direction")
		
	#STATE STORY POSITION MOVE
	if not movement_rule.is_empty():
		for rule in movement_rule:
			var parent = get_parent()
			if rule["state"] == StoryStates.states:
				parent.global_position = rule["position"]
				parent.global_rotation = deg_to_rad_vec3(rule["rotation"])
			
func deg_to_rad_vec3(deg:Vector3):
	return Vector3(deg_to_rad(deg.x),deg_to_rad(deg.y),deg_to_rad(deg.z))
	
	
