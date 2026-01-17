extends Node3D

@onready var vent: AudioStreamPlayer = $vent
@onready var forest: AudioStreamPlayer = $forest
@onready var cimetiere: AudioStreamPlayer = $cimetiere

var current_player: AudioStreamPlayer = null
var fade_time := 3.0


func _ready():
	# On s'assure que tout est arrêté au lancement
	vent.stop()
	forest.stop()
	cimetiere.stop()


# =====================
# FONCTIONS DE FADE
# =====================

func fade_in(player: AudioStreamPlayer):
	player.volume_db = -30
	player.play()
	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0, fade_time)


func fade_out(player: AudioStreamPlayer):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -30, fade_time)
	tween.tween_callback(player.stop)


# =====================
# CHANGEMENT D’AMBIANCE
# =====================

func change_ambience(new_player: AudioStreamPlayer):
	if current_player == new_player:
		return

	if current_player:
		fade_out(current_player)

	fade_in(new_player)
	current_player = new_player


# =====================
# ZONES
# =====================

func _on_area_village_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		change_ambience(vent)


func _on_area_forest_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		change_ambience(forest)


func _on_area_cimetiere_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		change_ambience(cimetiere)
