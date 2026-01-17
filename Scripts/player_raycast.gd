extends RayCast3D

@onready var interaction: MarginContainer = get_tree().get_first_node_in_group("interaction_label")
@onready var crossair: TextureRect = get_tree().get_first_node_in_group("crossair")

var last_collider = Node3D.new()

func _ready():
	if interaction == null:
		push_error("Le label d'interaction n'a pas été trouvé.")

func _process(_delta):
	if not is_instance_valid(interaction):
		return
	force_raycast_update()
	if last_collider.has_method("you_are_not_collide"):
		last_collider.you_are_not_collide()

	if is_colliding():
		var collider = get_collider()
		last_collider = get_collider()
		
		if collider.has_method("you_are_collide"):
			collider.you_are_collide()

		# On vérifie si le collider est un objet interactible et a la méthode interact
		if collider.is_in_group("interacteble") and collider.has_method("interact"):
			interaction.show()
			crossair.show()
			if Input.is_action_just_pressed("interact"):
				collider.interact()
			
		else:
			interaction.hide()
			crossair.hide()
	else:
		interaction.hide()
		crossair.hide()
