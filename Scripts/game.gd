extends Node2D

enum GameplayState { PLACING, WAITING, BATTLING }
var current_gameplay_state: GameplayState = GameplayState.PLACING

const SELECTOR_SPEED = 10
var prev_selection_position = Vector2(0, 0)
var selection_active = true

func start_round():
	$AnimationPlayer.play("BattleStart")
	Global.units = []
	for building in Global.buildings:
		if building.spawns_units:
			building._spawn_units()

func _physics_process(delta):
	if current_gameplay_state == GameplayState.PLACING:
		$Camera/UI.show()
		if Global.player_turn == 0:
			$Camera/UI/FancyGradient/BlueBack.show()
			$Camera/UI/FancyGradient/RedBack.hide()
		else:
			$Camera/UI/FancyGradient/RedBack.show()
			$Camera/UI/FancyGradient/BlueBack.hide()
	elif current_gameplay_state == GameplayState.BATTLING:
		$Camera/UI.hide()
	
	if current_gameplay_state == GameplayState.BATTLING:
		if $Units.get_child_count() == 0:
			Global.units = []
		
		if len(Global.units) <= 0:
			Global.total_turns += 1
			$AnimationPlayer.play("TurnSwitch")
			current_gameplay_state = GameplayState.PLACING
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
						$GameWorld.set_cell(2, map_position, 10, Vector2i(0, 0), 2)
						
						if Global.player_turn == 0:
							Global.red_castle_pos = map_position * 32
						else:
							Global.blue_castle_pos = map_position * 32
					else:
						$GameWorld.set_cell(2, map_position, 10, Vector2i(0, 0), 1)
					
					if Global.player_turn == 0:
						Global.red_buildings.append(map_position)
					elif Global.player_turn == 1:
						Global.blu_buildings.append(map_position)
					
					if Global.player_turn < Global.max_turn:
						$AnimationPlayer.play("TurnSwitch")
						Global.player_turn += 1
					else:
						Global.player_turn = 0
						current_gameplay_state = GameplayState.WAITING
						await get_tree().create_timer(1).timeout
						current_gameplay_state = GameplayState.BATTLING
						start_round()
			
			#print(Global.player_turn)

func _on_selection_button_pressed(button_num):
	print("aaaaaaaaa " + str(button_num))
