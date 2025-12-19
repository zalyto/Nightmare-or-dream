extends StaticBody3D
# Exporter la variable pour la rendre modifiable dans l'éditeur Godot
@export var dialogue_lines: Array[String] = ["Bonjour, aventurier !", "Que puis-je faire pour vous ?"]
@export var nom: String = "basename"
@export var value: Color

@onready var label_pnj: Label3D = %Label_pnj
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	# Ajoute le PNJ au groupe "PNJ" pour que le raycast puisse le détecter
	add_to_group("interacteble")
	label_pnj.text = nom
	label_pnj.set_modulate(value)

func interact():
	print("Interaction avec le PNJ")
	# Démarre le dialogue en utilisant le singleton Ui
	audio.play()



#regardé la tete du joueur
@onready var neck = %neck
@onready var look_object = $"../../Player/head"
@onready var skeleton = $"../character/Skeleton3D"
var new_rotation
var max_horizontal_angle = 90
var max_vertical_angle = 20
var bonesmoothrot = 0.0
var distance: float = 3


func look_at_object(delta):
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
	if look_object != null:
		look_at_object(delta)
	else:
		print("ERRORE : pnj ne trouve pas la tete du joueur pour regarder dans ça direction")
	
