@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Building", "Node2D", preload("building.gd"), preload("building.png"))
	add_custom_type("Unit", "Area2D", preload("unit.gd"), preload("unit.png"))


func _exit_tree():
	remove_custom_type("Building")
	remove_custom_type("Unit")
