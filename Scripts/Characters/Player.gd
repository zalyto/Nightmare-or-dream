extends CharacterBody3D

const LERP_VALUE : float = 0.15
const ANIMATION_BLEND : float = 5.0

var snap_vector : Vector3 = Vector3.DOWN
var speed : float
var current_blend_position = Vector2.ZERO
var blend_speed = 5
var footstep_timer := 0.0
var step_interval := 0.5 # une étape toutes les 0.3 secondes

var in_cinematique: bool = false
var is_in_interior := false
@export_group("Movement variables")
@export var walk_speed : float = 2.0
@export var run_speed : float = 5.0
@export var jump_strength : float = 8
@export var gravity : float = 50.0
@export var fall_animation_threshold = -2.0  # Ajuste cette valeur pour un meilleur rendu
@onready var player_mesh: Node3D = $Mesh
@onready var player: CharacterBody3D = $"."
@onready var spring_arm_pivot : Node3D = $tete/secouse/SpringArmPivot
@onready var animator : AnimationTree = $AnimationTree
@onready var my_camera = %CameraFPV
@onready var footstep_path: AudioStreamPlayer3D = $sound/footstep_sound
@onready var jump_sound: AudioStreamPlayer3D = $sound/jump_sound
@onready var failling_sound: AudioStreamPlayer3D = $sound/failling_sound
@onready var pos_processe: MeshInstance3D = $tete/secouse/SpringArmPivot/CameraFPV/PosProcesse
@onready var simplegrass: MeshInstance3D = $simplegrass
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var chant_de_ble_sound: AudioStreamPlayer3D = $chant_de_ble

var on_chant_de_ble := false
func _ready() -> void:
	simplegrass.show()
	#enable pos processe
	pos_processe.show()
	pass
	
func chant_de_ble_enterred():
	on_chant_de_ble = true

		
func chant_de_ble_exited():
	on_chant_de_ble = false

func _physics_process(delta):
	
	if !velocity:
		chant_de_ble_sound.stop()
		
	if velocity and on_chant_de_ble == true:
		if !chant_de_ble_sound.playing:
			chant_de_ble_sound.play()
	if velocity and on_chant_de_ble == false:
		chant_de_ble_sound.stop()
		
	SimpleGrass.set_player_position(global_position)
	var move_direction : Vector3 = Vector3.ZERO
	if not in_cinematique and not Ui.in_dialog:
		
		if velocity:
			gpu_particles_3d.emitting = true
		else:
			gpu_particles_3d.emitting = false
	
		move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		move_direction.z = Input.get_action_strength("down") - Input.get_action_strength("up")
		move_direction = move_direction.normalized()
		
		move_direction = move_direction.rotated(Vector3.UP, player.rotation.y)
		
	var input_dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	var target_speed = 0.0
	
	if not input_dir:
		speed = 0.0
	else:
		if Input.is_action_just_pressed("run"):
			if is_in_interior:
				if not Ui.queue_msg.has("vous ne pouver pas courire a l'interieur d'un batiment !"):
					Ui.feedback("vous ne pouver pas courire a l'interieur d'un batiment !")
		if Input.is_action_pressed("run"):
			if is_in_interior:
				target_speed = walk_speed
			else:
				target_speed = run_speed
		else:
			target_speed = walk_speed 
		if velocity == Vector3.ZERO:
			target_speed = walk_speed


	# Fait la transition en douceur entre la vitesse actuelle et la vitesse cible
	speed = lerp(speed, target_speed, delta * 2.0)

	# Utilise la variable "current_speed" pour ton mouvement (par exemple, dans ton move_and_slide())
	# velocity = direction * current_speed
	
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	
	
	#var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
	#var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") and not in_cinematique and not Ui.in_dialog
	#if is_jumping:
		#velocity.y = jump_strength
		#snap_vector = Vector3.ZERO
		#jump_sound.play()	
		#
	#elif just_landed:
		#snap_vector = Vector3.DOWN
	#if !is_jumping:
	velocity.y -= gravity * delta
	
	apply_floor_snap()
	move_and_slide()
	animate(delta)
	animator.set("parameters/walk/blend_position", current_blend_position)
	animator.set("parameters/Run/blend_position", current_blend_position)
	
	# lerp le blend 2D
	var target_blend_position = input_dir
	current_blend_position = current_blend_position.lerp(target_blend_position, delta * blend_speed)
	
	#play sound footstep
	if is_on_floor() and move_direction != Vector3.ZERO:
			
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			footstep_path.play()
			footstep_timer = step_interval
	else:
		footstep_timer = 0.0
	
	if velocity.y <= -10:
		if not failling_sound.playing:
			failling_sound.volume_db = 0
			failling_sound.play()
			failling_sound.volume_db = lerp(failling_sound.volume_db, 1.0, 1)
	else:
		failling_sound.stop()

func _process(_delta: float) -> void:
	if in_cinematique:
		return
	if Ui.in_dialog == true:
		%cam_dialog.look_at(CinematiqueCamera.pnj_talking_pos+ Vector3(0.0, -0.2, 0.0))
		%cam_dialog.current = true
	else:
		%cam_dialog.current = false
		my_camera.current = true
func animate(delta):
	if is_on_floor():
		animator.set("parameters/ground_air_transition/transition_request", "grounded")
		
		if velocity.length() > 0:
			if speed >= run_speed -1 and speed <= run_speed +1: # si speed est == a run_speed avec une marge de 1
				animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 1.0, delta * ANIMATION_BLEND))
				step_interval = 0.3
				footstep_path.pitch_scale = randf_range(speed/5 +1, speed/5 +2)
				#animation de run
			else:
				animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 0.0, delta * ANIMATION_BLEND))
				step_interval = 0.6
				footstep_path.pitch_scale = randf_range(speed/5 +1, speed/5 +2)
				#animation de walk
		else:
			animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), -1.0, delta * ANIMATION_BLEND))
			#animation de idle
	
	# On vérifie si on est en l'air ET qu'on tombe assez vite
	elif player.velocity.y < fall_animation_threshold or player.velocity.y > 0 :
		animator.set("parameters/ground_air_transition/transition_request", "air")
		# Ici, "air" est l'animation de chute
	
	# Si on est en l'air mais qu'on ne tombe pas (par exemple pendant un saut)
	# on peut ne rien faire, ou jouer une autre animation

func in_interior(base:bool):
	is_in_interior = base
	print("player is in house: ",is_in_interior)
