@tool
extends Area2D

var team = 0

@export var spawns_units = false
@export var unit_to_spawn = preload("res://Units/RandomPerson.tscn")

@export var health = 100

@export var red_building_x = 1.0
@export var blue_building_x = 0.0

var id = 0

func _enter_tree():
	Global.buildings.append(self)
	
	id = Global.next_building_id
	Global.next_building_id += 1
	
	team = Global.player_turn
	
	if team == 0:
		get_node("Sprite").texture.region.position.x = red_building_x
	elif team == 1:
		get_node("Sprite").texture.region.position.x = blue_building_x

func _spawn_units():
	var unit_instance = unit_to_spawn.instantiate()
	unit_instance.position = self.get_global_transform().origin
	unit_instance.team = team
	unit_instance.id = Global.next_unit_id
	Global.next_unit_id += 1
	
	get_parent().get_parent().get_node("Units").add_child(unit_instance)
