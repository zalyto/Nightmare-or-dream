extends Control

@onready var menu: CanvasLayer = $menu
@onready var hud: Control = $HUD

@onready var tab_bar: TabBar = $menu/mainpanel/TabBar

#TABS
@onready var tab_3: MarginContainer = $menu/mainpanel/Tab3_maps
@onready var tab_2: MarginContainer = $menu/mainpanel/Tab2_inventory
@onready var tab_1: MarginContainer = $menu/mainpanel/Tab1_objectif

#inventory
@onready var grid: GridContainer = %Gridinventory

#FEEDBACK
@onready var labelfeedback: Label = $HUD/CanvasLayer/Control_FB/MarginContainer_FB/feedback
@onready var Control_FB: Control = $HUD/CanvasLayer/Control_FB
@onready var animation_player: AnimationPlayer = $HUD/CanvasLayer/Control_FB/AnimationPlayer
@onready var feedback_pop: AudioStreamPlayer = $HUD/CanvasLayer/Control_FB/feedbackPop
@onready var timer: Timer = $HUD/CanvasLayer/Control_FB/Timer

var queue_msg: Array[String]
var queue_duration: Array[float]
var occuper : bool = false
var in_cinematique: bool = false
var idx

#OBJECTIFE
var current_objectif: String
@onready var label_objectife: Label = $menu/mainpanel/Tab1_objectif/Label_objectife

#OPTION
@onready var option_panel: Panel = $menu/option
var option: bool = false
@onready var mainpanel: Panel = $menu/mainpanel


#ACTE
@onready var label_acte: RichTextLabel = $acte/label_acte
@onready var anim_acte: AnimationPlayer = $acte/label_acte/Anim_acte

#var
var in_dialog := false
var in_menu_principal = true

func hide_ui():

	$HUD.hide()
	$menu.hide()
	$ST_CanvasLayer.hide()
	$acte.hide()
	print("hide ui")
	
func show_ui():
	$HUD.show()
	$ST_CanvasLayer.show()
	$acte.show()
	print("show ui")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idx = tab_bar.current_tab
	update_tab()
	Control_FB.hide()
	option_panel.visible = option
	mainpanel.visible = !option
	anim_acte.play("RESET")
	menu.visible = false
	menu_visible()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if in_menu_principal:
		return
	if occuper == false and not queue_msg.is_empty():
		draw_feedback(queue_msg.pop_front(), queue_duration.pop_front())
			
	if menu.visible:
		hud.hide()
		get_tree().paused = true
	else:
		hud.show()
		get_tree().paused = false
		
	if in_cinematique:
		hud.hide()
	else:
		hud.show()

func _input(event):
	if in_menu_principal:
		return
	# Gère la capture de la souris
	if event.is_action_pressed("escape" ):
		menu.visible = not menu.visible
		menu_visible()
		refresh()
		
	if event.is_action_pressed("click") and !menu.visible:
		menu_visible()
		
func menu_visible():
	if menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if in_dialog:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif in_menu_principal == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
#TAB-------------------------------------------------
func _on_tab_bar_tab_changed(tab: int) -> void:
	idx = tab
	update_tab()
	
func update_tab():
	if idx == 0:
		tab_3.visible = false
		tab_2.visible = false
		tab_1.visible = true
	if idx == 1:
		tab_3.visible = false
		tab_2.visible = true
		tab_1.visible = false
	if idx == 2:
		tab_3.visible = true
		tab_2.visible = false
		tab_1.visible = false
	refresh()

#BOUTON------------------------------------------------

func retoure_on_reprendre_pressed() -> void:
	menu.visible = false
	menu_visible()

func quitter_on_quitter_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	option = true
	option_panel.visible = option
	mainpanel.visible = !option

func _on_back_pressed() -> void:
	option = false
	option_panel.visible = option
	mainpanel.visible = !option

	

#inventory
func refresh():
	for child in grid.get_children():
		child.queue_free()
	for item in Inventory.items:
		var label = Label.new()
		label.text = item + " X" + str(Inventory.items[item])
		grid.add_child(label)
		label_objectife.text = current_objectif

func feedback(msg: String, duration: float = 1.5) -> void:
	queue_msg.append(msg)
	queue_duration.append(duration)
	
	
	
func draw_feedback(msg: String, duration: float):
	occuper = true
	if not timer.timeout:
		occuper = false
		return
	labelfeedback.text = msg
	Control_FB.show()
	
	timer.wait_time = duration
	animation_player.play("drop")
	feedback_pop.play()
	timer.start()
	await timer.timeout
	animation_player.play("hide")
	await animation_player.animation_finished 
	Control_FB.hide()
	occuper = false

func new_objectif(new_objectif: String):
	if current_objectif == new_objectif:
		return
	current_objectif = new_objectif
	var text = tr("OBJECTIVE_UPDATED") + " : " + tr(new_objectif)
	feedback(text, 3)

func acte(text: String):
	label_acte.text = text
	anim_acte.play("fade")
	await anim_acte.animation_finished
	anim_acte.play("RESET")
	
	
