extends Node3D

@export_group("FOV")
@export var change_fov_on_run : bool
@export var normal_fov : float = 75.0
@export var run_fov : float = 90.0

@export_group("Camera")
@export var mouse_sensitivity : float = 0.05
@export var camera_vertical_limit_deg : float = 80.0
@export var head_bob_speed_mult : float = 3.0
@export var head_bob_amount : float = 0.1
@export var landing_shake_amount : float = 0.4
@export var landing_shake_duration : float = 0.13

@export var strafe_tilt_amount : float = 5.0
@export var strafe_tilt_speed : float = 8.0

const CAMERA_BLEND : float = 0.05

@onready var spring_arm: Node3D = $"."
@onready var camera : Camera3D = %CameraFPV
@onready var player: CharacterBody3D = $"../../.."
@onready var secouse: Node3D = $".."
@onready var hurt_sound: AudioStreamPlayer3D = $"../../../sound/hurt_sound"


var mouse_motion : Vector2 = Vector2.ZERO
var time_passed : float = 0.0
var was_on_floor : bool = true

var smoothed_tilt : float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative

func _process(delta):
	if player.in_cinematique:
		return
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(deg_to_rad(-mouse_motion.x * mouse_sensitivity))
		
		var new_rotation_x = spring_arm.rotation.x + deg_to_rad(mouse_motion.y * mouse_sensitivity)

		spring_arm.rotation.x = clamp(new_rotation_x, deg_to_rad(-camera_vertical_limit_deg), deg_to_rad(camera_vertical_limit_deg))
	
	mouse_motion = Vector2.ZERO
	
	# 1. Mouvement de tête (head bobbing)
	# Vérifie si le personnage est au sol et se déplace
	var is_moving = player.velocity.length() > 0.1 and player.is_on_floor()
	
	# On utilise une vitesse de base de 1.0 si le joueur bouge
	# On peut aussi ajuster la vitesse si le joueur court
	if is_moving:
		var current_speed_mult = 1.0
		# On peut vérifier la vitesse du joueur pour ajuster le head bob
		if player.speed == player.run_speed:
			current_speed_mult = 1.5 
		
		time_passed += delta * current_speed_mult * head_bob_speed_mult
		
		# Applique un mouvement sinusoïdal de haut en bas et de gauche à droite
		camera.position.y = sin(time_passed) * head_bob_amount
		camera.position.x = cos(time_passed / 2) * head_bob_amount
	else:
		# Retourne à la position neutre quand le joueur s'arrête
		camera.position = camera.position.lerp(Vector3.ZERO, delta * 5.0)
		
		# Inclinaison (strafe)
	var input = Input.get_axis("right", "left")
	var target_tilt = deg_to_rad(input * strafe_tilt_amount)
	smoothed_tilt = lerp(smoothed_tilt, target_tilt, delta * strafe_tilt_speed)
	camera.rotation.z = smoothed_tilt
	
# Variable pour stocker la vitesse verticale de la frame précédente
var last_fall_speed = 0.0

func _physics_process(_delta):
	if player.in_cinematique:
		return
	# D'abord, on met à jour la vitesse de chute de la frame précédente
	# C'est la vitesse que l'on va utiliser pour le test
	if not player.is_on_floor():
		last_fall_speed = player.velocity.y
	
	# 2. Secousse de caméra à l'atterrissage (landing shake)
	var is_on_floor_now = player.is_on_floor()
	var fall_shake_threshold = -5.0 

	# On vérifie si on vient de toucher le sol
	# ET si la vitesse de la frame précédente était inférieure au seuil
	if was_on_floor == false and is_on_floor_now == true and last_fall_speed < fall_shake_threshold:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(secouse, "position:y", -landing_shake_amount, landing_shake_duration)
		tween.tween_property(secouse, "position:y", 0.0, landing_shake_duration)
		hurt_sound.play()
		hurt_sound.pitch_scale = randf_range(0.7,1.3)
		
	was_on_floor = is_on_floor_now
	
	# Le FOV (Champ de vision) peut rester ici
	if change_fov_on_run:
		if owner.is_on_floor():
			if Input.is_action_pressed("run"):
				camera.fov = lerp(camera.fov, run_fov, CAMERA_BLEND)
			else:
				camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
		else:
			camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
