extends CSGMesh3D


@export var vitesse_de_rotation : float = 15.0 # Ajuste cette valeur pour changer la vitesse

func _process(delta):
	rotate_x(vitesse_de_rotation * delta)
