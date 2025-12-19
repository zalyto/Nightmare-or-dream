extends OptionButton





func _on_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("fr")
	if index == 1:
		TranslationServer.set_locale("en")
