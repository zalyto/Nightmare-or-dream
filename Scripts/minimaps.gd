extends SubViewportContainer
 
# Référence à la caméra Camera2D située dans le SubViewport
# VÉRIFIEZ QUE CE CHEMIN CORRESPOND À LA STRUCTURE DE VOTRE SCÈNE :
# $SubViewport/Node2D/Camera2D est le chemin standard si vous n'avez pas renommé les nœuds.
@onready var camera: Camera2D = $SubViewport/Node2D/Camera2D
 
# Variables de contrôle pour le déplacement (panning)
var is_dragging: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO
const ZOOM_FACTOR = 1.1 # Facteur de zoom, ajustez si vous voulez un zoom plus lent ou rapide
 
# _gui_input est idéal pour les entrées d'interface utilisateur, il ne s'active 
# que lorsque la souris est au-dessus du SubViewportContainer.
func _gui_input(event: InputEvent):
	camera.zoom = clamp(camera.zoom, Vector2(1, 1), Vector2(4, 4))
	# --- GESTION DU ZOOM (Molette de la souris) ---
	if event is InputEventMouseButton:
		
		# 1. Début/Fin du clic gauche (pour le Déplacement/Panning)
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.is_pressed()
			if is_dragging:
				last_mouse_pos = event.position
			
		# 2. Zoom In (Molette Haut) : Rapprocher l'image
		# On suppose que Molette Haut = Zoom In, Molette Bas = Zoom Out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			# Diminuer la valeur de zoom pour rapprocher (e.g., de 1.0 à 0.9)
			camera.zoom /= ZOOM_FACTOR
			accept_event() # Consomme l'événement
			
		# 3. Zoom Out (Molette Bas) : Éloigner l'image
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			# Augmenter la valeur de zoom pour éloigner (e.g., de 1.0 à 1.1)
			camera.zoom *= ZOOM_FACTOR
			accept_event() # Consomme l'événement

	# --- GESTION DU DÉPLACEMENT (Clic gauche maintenu) ---
	if event is InputEventMouseMotion and is_dragging:
		
		# Calculer la différence de position de la souris
		var delta_pos = event.position - last_mouse_pos
		
		# 1. Calculer la nouvelle position souhaitée (déplacement inversé)
		# On divise par camera.zoom pour que le déplacement soit cohérent.
		var new_position = camera.position - delta_pos / camera.zoom
		
		# 2. Clamper la position aux limites de la caméra
		# Cela empêche la variable camera.position de dépasser les limites visuelles.
		new_position.x = clamp(
			new_position.x, 
			camera.limit_left, 
			camera.limit_right
		)
		new_position.y = clamp(
			new_position.y, 
			camera.limit_top, 
			camera.limit_bottom
		)
		
		# 3. Appliquer la position "clamée"
		camera.position = new_position
		
		# Mettre à jour la dernière position pour le calcul suivant
		last_mouse_pos = event.position
		
		accept_event() # Consomme l'événement
