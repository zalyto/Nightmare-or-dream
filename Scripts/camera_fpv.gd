extends Camera3D

# NOTE : Ce script doit être placé sur un nœud qui est dans l'arbre de scène
# pour pouvoir accéder au monde physique via get_world_3d().

func _physics_process(_delta: float) -> void:

	# =========================================================================
	# 1. ACCÈS AU SERVEUR PHYSIQUE
	# =========================================================================
	# On récupère l'état de l'espace physique direct du monde 3D.
	# C'est notre porte d'entrée pour toutes les requêtes physiques
	# qui ne dépendent pas de nœuds (comme RayCast3D).
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	# =========================================================================
	# 2. DÉFINITION DU RAYON
	# =========================================================================
	# On définit le point de départ (from) et d'arrivée (to) du rayon.
	# Ici, pour l'exemple, on le fait partir de la position de ce nœud
	# et on le projette 20 mètres tout droit devant lui.
	# Le vecteur "avant" d'un Node3D est -global_transform.basis.z
	var ray_origin: Vector3 = global_transform.origin
	var ray_end: Vector3 = ray_origin + -global_transform.basis.z * 20.0

	# =========================================================================
	# 3. CONFIGURATION DE LA REQUÊTE (LA PARTIE LA PLUS IMPORTANTE)
	# =========================================================================
	# On crée un objet de paramètres pour notre requête de rayon.
	# C'est plus propre et plus performant que de passer les arguments un par un.
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	# --- DÉTECTION DU GROUPE "PNJ" ---
	# On définit le "masque de collision". C'est un nombre entier qui indique au rayon
	# quelles couches physiques il a le droit de toucher.
	#
	# Pour trouver la valeur du masque, on prend le numéro de la couche et on calcule :
	# valeur = 2 ^ (numéro_de_couche - 1)
	#
	# - Couche 1 -> 2^(1-1) = 1
	# - Couche 2 ("PNJ") -> 2^(2-1) = 2
	# - Couche 3 -> 2^(3-1) = 4
	# - Couche 4 -> 2^(4-1) = 8
	# etc.
	#
	# Puisque nous avons mis nos PNJ sur la couche 2, le masque est 2.
	query.collision_mask = 2
	#query.collision_layer = 1 # On peut aussi définir la couche de collision si besoin.
	# Optionnel : si vous voulez que le rayon ignore certains objets spécifiques
	# (par exemple, le joueur lui-même), vous pouvez les ajouter à une liste d'exclusions.
	# query.exclude = [get_rid()] # get_rid() récupère l'ID de ressource de l'objet courant.

	# =========================================================================
	# 4. EXÉCUTION ET LECTURE DU RÉSULTAT
	# =========================================================================
	# On exécute la requête en passant nos paramètres.
	# Le résultat est un dictionnaire qui contient toutes les infos sur ce qui a été touché.
	var result: Dictionary = space_state.intersect_ray(query)

	# On vérifie si le dictionnaire de résultat n'est PAS vide.
	# S'il n'est pas vide, cela signifie que notre rayon a touché quelque chose
	# qui correspondait à notre masque de collision.
	if not result.is_empty():

		# Puisque notre masque ne cible QUE la couche "PNJ", nous sommes maintenant
		# certains que l'objet que nous avons touché est un PNJ.

		#print(">>> RAYCAST : J'ai trouvé un PNJ !")

		# En bonus, voici comment accéder à plus d'informations depuis le résultat :
		var _collider_hit: Object = result.collider # Récupère le nœud qui a été touché.
		var _hit_position: Vector3 = result.position # Récupère le point d'impact exact dans le monde.
		var _hit_normal: Vector3 = result.normal # Récupère la normale de la surface au point d'impact.

		# On peut maintenant utiliser ces informations.
		#print("    -> Objet touché : ", collider_hit.name)
		#print("    -> En position : ", hit_position)
		#print("    -> Normale de la surface : ", hit_normal)
