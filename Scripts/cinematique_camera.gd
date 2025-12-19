extends Camera3D



#

func get_player():
	return get_tree().get_first_node_in_group("player")
	
func get_player_camera():
	return get_tree().get_first_node_in_group("player_camera")

func start_cinematique():
	get_player().in_cinematique = true
	Ui.in_cinematique = true
	make_current()	

func end_cinematique():
	get_player().in_cinematique = false
	Ui.in_cinematique = false
	get_player_camera().make_current()
	
func add_medaillon():
	Inventory.add_item("mon medaillon")
	
func soutitre_cinematique(text: String, duration: float):
	Soutitre.show_thought(text, duration)
	
func add_objectif(text: String):
	Ui.new_objectif(text)
	
func add_acte(text: String):
	Ui.acte(text)
