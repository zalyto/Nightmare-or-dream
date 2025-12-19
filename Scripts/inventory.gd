extends Node

var items := {}

func add_item(item_name: String, quantity := 1):
	Ui.feedback("you have pick up " + item_name + " !", 3)
	if items.has(item_name):
		items[item_name] += quantity
	else:
		items[item_name] = quantity

func remove_item(item_name: String, quantity := 1):
	if not items.has(item_name):
		return
	
	items[item_name] -= quantity
	Ui.feedback("you have used " + item_name + " !", 3)
	if items[item_name] <= 0:
		items.erase(item_name)

func has_item(item_name: String) -> bool:
	return items.has(item_name)
