extends StaticBody3D
@onready var crossair: TextureRect = get_tree().get_first_node_in_group("crossair")

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var anim_cinematique: AnimationPlayer = $"../CinematiqueCamera/AnimationPlayer"

func you_are_collide():
	var mat = mesh.get_active_material(0).duplicate()
	mat.albedo_texture = preload("res://assets/textures/new affiche_outline.png")
	mesh.set_surface_override_material(0, mat)

func you_are_not_collide():
	var mat = mesh.get_active_material(0).duplicate()
	mat.albedo_texture = preload("res://assets/textures/new affiche.png")
	mesh.set_surface_override_material(0, mat)

func interact():
	anim_cinematique.play("affiche")
	if StoryStates.states == 2:
		StoryStates.states = 3
	CinematiqueCamera.day()
	$"../batiment/house_sire/simple_door".locked = false
