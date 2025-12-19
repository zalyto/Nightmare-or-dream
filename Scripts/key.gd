extends RigidBody3D

@export var cles_de_quoi : String

@export var positions: Array[Marker3D]
@onready var rng = RandomNumberGenerator.new()

#pour placer la clef aléatoirement dans la maison
var drawer: Node3D
var local_offset: Vector3

func _physics_process(_delta):
	if drawer != null:
		# La clé suit le tiroir
		global_position = drawer.global_position + local_offset

func _on_body_entered(body: Node) -> void:
	# On vérifie que c'est un tiroir
	# On mémorise le tiroir
	drawer = body

	# On calcule la position relative
	local_offset = global_position - drawer.global_position

	# On bloque la physique
	freeze = true

#POS RANDOM------

func _ready() -> void:
	rng.randomize()
	var chance = rng.randi_range(0, positions.size() -1)
	global_transform.origin = positions[chance].global_transform.origin
	print(chance)

#TAKE KEY

func interact():
	Inventory.add_item(cles_de_quoi)
	queue_free()
	



	
