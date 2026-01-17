extends RigidBody3D

@export var cles_de_quoi : String
@export var positions: Array[Marker3D]

@onready var rng = RandomNumberGenerator.new()

@onready var pick_up: AudioStreamPlayer = $pick_up
@onready var collision: CollisionShape3D = $CollisionShape3D

@onready var glow: MeshInstance3D = $"Jailers Key_002/glow"
@onready var normal: MeshInstance3D = $"Jailers Key_002/normal"


var drawer: Node3D
# On remplace local_offset par un transform complet pour garder la rotation
var relative_transform: Transform3D 

func _physics_process(_delta):
	if drawer != null:
		# La clé suit le tiroir en appliquant son transform relatif au transform global du tiroir
		global_transform = drawer.global_transform * relative_transform

func _on_body_entered(body: Node) -> void:
	# On mémorise le tiroir
	drawer = body

	# On calcule le Transform relatif (Position + Rotation)
	# On multiplie l'inverse du transform du tiroir par celui de la clé
	relative_transform = drawer.global_transform.affine_inverse() * global_transform

	# On bloque la physique
	freeze = true

func _ready() -> void:
	rng.randomize()
	if positions.size() > 0:
		var chance = rng.randi_range(0, positions.size() - 1)
		# Utiliser global_transform permet de copier aussi la rotation du Marker3D
		global_transform = positions[chance].global_transform
		print("Clé placée à la position : ", chance)
		
	
func interact():
	Inventory.add_item(cles_de_quoi)
	pick_up.play()
	hide()
	collision.disabled = true
	await pick_up.finished
	queue_free()
	
func you_are_collide():
	glow.show()
	normal.hide()
	
func you_are_not_collide():
	glow.hide()
	normal.show()
