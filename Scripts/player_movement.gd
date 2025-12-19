extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002

# Variable pour contrôler si le joueur peut bouger
var can_move: bool = true

func _ready() -> void:
	#Cacher la souris
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Ajoute le joueur au groupe "Player" pour un accès facile
	add_to_group("Player")

func _physics_process(delta):
	if not can_move:
		velocity = Vector3.ZERO # S'assurer que le joueur s'arrête complètement
		move_and_slide() # Appliquer l'arrêt
		return
		
	#Permet au player de bouger
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		
func _input(event):
	#Gère la rotation de la caméra uniquement si le joueur peut bouger
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and can_move:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	#Permet de réafficher la souris quand on appuie sur "Echap"
	if event.is_action_pressed("echap"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Fonctions pour activer/désactiver le mouvement
func set_can_move(value: bool):
	can_move = value
	# On change aussi le mode de la souris pour la cohérence
	if value:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE