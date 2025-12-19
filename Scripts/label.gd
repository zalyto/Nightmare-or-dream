extends Label
#@onready var player: CharacterBody3D = $"../../../Player"

	
func labels(text):
	self.text = str(text)
