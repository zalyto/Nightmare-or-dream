
extends Control

# Signal émis lorsque le dialogue est terminé
signal dialogue_finished()

@onready var dialogue_box: Panel = $DialogueBox
@onready var dialogue_text: Label = $DialogueBox/DialogueText

var dialogue_lines: Array[String] = []
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready():
	dialogue_box.hide()

func _input(event):
	# Si le dialogue est actif et que le joueur appuie sur la touche d'interaction
	if is_dialogue_active and event.is_action_pressed("interact"):
		# On attend un court instant pour éviter de passer plusieurs lignes d'un coup
		await get_tree().create_timer(0.2).timeout
		show_next_line()

func start_dialogue(lines: Array[String]):
	if lines.is_empty():
		return

	dialogue_lines = lines
	current_line_index = 0
	is_dialogue_active = true
	
	# On affiche la boîte de dialogue et la première ligne
	dialogue_box.show()
	dialogue_text.text = dialogue_lines[current_line_index]
	
	# On bloque les mouvements du joueur en utilisant la fonction dédiée
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.set_can_move(false)


func show_next_line():
	current_line_index += 1
	if current_line_index < dialogue_lines.size():
		dialogue_text.text = dialogue_lines[current_line_index]
	else:
		end_dialogue()

func end_dialogue():
	is_dialogue_active = false
	dialogue_box.hide()
	dialogue_lines.clear()
	current_line_index = 0
	
	# On réactive les mouvements du joueur en utilisant la fonction dédiée
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.set_can_move(true)
	
	# On émet le signal pour dire que c'est fini
	emit_signal("dialogue_finished")
