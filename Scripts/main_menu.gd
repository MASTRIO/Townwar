extends Control

func _on_quit_button_pressed():
	get_tree().quit()

func _on_multiplayer_button_pressed():
	$MainMenuButtons.hide()
	$MultiplayerMenuButtons.show()

func _on_mm_back_button_pressed():
	$MainMenuButtons.show()
	$MultiplayerMenuButtons.hide()

func _on_local_multiplayer_button_pressed():
	get_tree().change_scene("res://game.tscn")
