extends Node3D

@onready var pivot = $Pivot
@onready var area_3d = $Area3D

# Variable to store which way the door is currently open (0: closed, 1 or -1: direction)
var open_direction = 0

func _ready():
	area_3d.body_entered.connect(_on_body_entered)
	area_3d.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Determine player's position relative to the door's local Z axis
		var local_pos = to_local(body.global_transform.origin)
		
		# If local_pos.z is positive, player is in "front", open to +90 deg
		# If local_pos.z is negative, player is "behind", open to -90 deg
		var direction = 1.0 if local_pos.z > 0 else -1.0
		open_door(direction)

func _on_body_exited(body):
	if body.is_in_group("player"):
		# Check if the area is empty before closing, in case multiple players are present
		var bodies = area_3d.get_overlapping_bodies()
		var player_still_inside = false
		for b in bodies:
			if b.is_in_group("player"):
				player_still_inside = true
				break
		
		if not player_still_inside:
			close_door()

func open_door(direction):
	# Only open if it's currently closed
	if open_direction == 0:
		print("DEBUG: Le personnage devrait lancer l'animation d'ouverture de porte.")
		open_direction = direction
		var tween = create_tween()
		tween.tween_property(pivot, "rotation_degrees:y", 90.0 * direction, 0.5).set_trans(Tween.TRANS_SINE)

func close_door():
	# Only close if it's currently open
	if open_direction != 0:
		open_direction = 0
		var tween = create_tween()
		tween.tween_property(pivot, "rotation_degrees:y", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
