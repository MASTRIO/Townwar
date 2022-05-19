extends Node2D

enum GameplayState { PLACING, BATTLING }
var current_gameplay_state = GameplayState.PLACING

const SELECTOR_SPEED = 10
var prev_selection_position = Vector2(0, 0)
var selection_active = true

func start_round():
	Global.units = []
	
	var houses = $GameWorld.get_used_cells(2)
	for house in houses:
		var random_person = preload("res://Units/RandomPerson.tscn")
		var random_person_instance = random_person.instantiate()
		
		if house in Global.red_buildings:
			random_person_instance.team = 0
			random_person_instance.get_node("Sprite").texture.region.position.x = 18.0
		elif house in Global.blu_buildings:
			random_person_instance.team = 1
			random_person_instance.get_node("Sprite").texture.region.position.x = 82.0
		
		Global.units.append(random_person_instance)
		random_person_instance.id = Global.next_id
		Global.next_id += 1
		
		random_person_instance.position = house * 32
		random_person_instance.position += Vector2(16, 16)
		$Units.add_child(random_person_instance)

func _physics_process(_delta):
	if current_gameplay_state == GameplayState.BATTLING:
		if $Units.get_child_count() <= 0:
			current_gameplay_state = GameplayState.PLACING

func _input(event):
	if event.is_action_pressed("place"):
		if current_gameplay_state == GameplayState.PLACING:
			$MouseClicky.position = get_global_mouse_position()
			var map_position = $GameWorld.world_to_map($MouseClicky.position * 2)
			print(map_position)
			
			if map_position.x >= -16 and map_position.y >= -10 and map_position.x <= 15 and map_position.y <= 9:
				var used_cells = $GameWorld.get_used_cells(2)
				var found_cell = false
				for cell in used_cells:
					if cell == map_position:
						found_cell = true
						break
				if not found_cell:
					$GameWorld.set_cell(2, map_position, 6, Vector2i(Global.player_turn, 0))
					
					if Global.player_turn == 0:
						Global.red_buildings.append(map_position)
					elif Global.player_turn == 1:
						Global.blu_buildings.append(map_position)
					
					if Global.player_turn < Global.max_turn:
						Global.player_turn += 1
					else:
						Global.player_turn = 0
						current_gameplay_state = GameplayState.BATTLING
						start_round()
			
			#print(Global.player_turn)
