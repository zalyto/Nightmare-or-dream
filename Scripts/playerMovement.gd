extends CharacterBody2D

@export var speed := 200.0  # Vitesse du joueur en pixels/seconde
var dragon = ".DragonBonesa"

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	#if velocity == Vector2(0.0, 0.0):
	print(dragon)
	dragon.active = false
	
func _on_dragon_bones_start(armature: DragonBonesArmature, anim_name: String) -> void:
	print("test")
