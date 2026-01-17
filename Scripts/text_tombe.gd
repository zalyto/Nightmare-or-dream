extends MeshInstance3D

func _ready():
	if not mesh is TextMesh:
		return

	# On rend le mesh unique pour cette instance
	var text_mesh := mesh.duplicate() as TextMesh
	mesh = text_mesh

	# On demande la prochaine donnée disponible au Singleton
	var tombe = GraveManager.get_next_grave_data()

	# Application du texte
	text_mesh.text = "{0}\n{1}\n{2}".format([tombe[0], tombe[1], tombe[2]])
