extends Node2D

enum GameplayState { PLACING, BATTLING }
var current_gameplay_state = GameplayState.PLACING

const SELECTOR_SPEED = 10
var prev_selection_position = Vector2(0, 0)
var selection_active = true

func start_round():
	Global.units = []
	var buildings = $GameWorld.get_used_cells(2)
	
	for building in buildings:
		if $GameWorld.get_cell_source_id(2, building, false) == 6:
			var chimney_smoke = preload("res://BuildingEffects/ChimneySmoke.tscn")
			var smoke_instance = chimney_smoke.instantiate()
			smoke_instance.position = building * 32
			smoke_instance.position += Vector2(16, 16)
			$BuildingEffects.add_child(smoke_instance)
		elif $GameWorld.get_cell_source_id(2, building, false) == 7:
			print("AH")
			var castle_range = preload("res://BuildingAttackRanges/Castle.tscn")
			var range_instance = castle_range.instantiate()
			range_instance.position = building * 32
			range_instance.position += Vector2(16, 16)
			
			if building in Global.red_buildings:
				range_instance.team = 0
			elif building in Global.blu_buildings:
				range_instance.team = 1
			$BuildingAttackRanges.add_child(range_instance)
	
	for building in buildings:
		if $GameWorld.get_cell_source_id(2, building, false) == 6:
			var random_person = preload("res://Units/RandomPerson.tscn")
			var random_person_instance = random_person.instantiate()
			
			if building in Global.red_buildings:
				random_person_instance.team = 0
				random_person_instance.get_node("Sprite").texture.region.position.x = random_person_instance.red_colour_x
			elif building in Global.blu_buildings:
				random_person_instance.team = 1
				random_person_instance.get_node("Sprite").texture.region.position.x = random_person_instance.blu_colour_x
			
			Global.units.append(random_person_instance)
			random_person_instance.id = Global.next_id
			Global.next_id += 1
			
			random_person_instance.position = building * 32
			random_person_instance.position += Vector2(16, 16)
			$Units.add_child(random_person_instance)
			Global.units_alive += 1

func _physics_process(_delta):
	if current_gameplay_state == GameplayState.BATTLING:
		if Global.units_alive <= 0:
			Global.total_turns += 1
			current_gameplay_state = GameplayState.PLACING
			for effect in $BuildingEffects.get_children():
				$BuildingEffects.remove_child(effect)
			for attack_range in $BuildingAttackRanges.get_children():
				$BuildingAttackRanges.remove_child(attack_range)
			for projectile in $Projectiles.get_children():
				$Projectiles.remove_child(projectile)

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
					if Global.total_turns == 0:
						$GameWorld.set_cell(2, map_position, 7, Vector2i(Global.player_turn, 0))
						if Global.player_turn == 0:
							Global.red_castle_pos = map_position * 32
						else:
							Global.blue_castle_pos = map_position * 32
					else:
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
