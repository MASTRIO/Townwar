extends Area2D

enum States { IDLE, MOVING, ATTACKING_UNIT, ATTACKING_BUILDING }
var state = States.IDLE

var red_colour_x = 14.0
var blu_colour_x = 78.0

var speed = 100
var health = 1000
var attack = 500

var id = 0
var team = 0

var attack_target = null
var tracking_target = null

func _physics_process(delta):
	if health <= 0:
		Global.units.remove_at(id)
		#Global.deletion_queue.append(id)
		Global.units_alive -= 1
		queue_free()
	
	var is_enemy = false
	
	if health > 0:
		if state == States.ATTACKING_UNIT:
			attack_target.health -= attack
		
		if len(Global.units) > 0 and state == States.IDLE or state == States.MOVING:
			state = States.MOVING
			
			var closest_direction = Vector2(100000000, 100000000)
			
			for unit in Global.units:
				if is_instance_valid(unit):
					if unit.team != team:
						is_enemy = true
						var direction = (Vector2(unit.position.x, unit.position.y + 10)) - position
						
						if unit.position.distance_to(position) < closest_direction.distance_to(position):
							closest_direction = direction
						#if direction < Vector2(0, 0):
						#	if direction > -closest_direction:
						#		closest_direction = direction
						#else:
						#	if direction < closest_direction:
						#		closest_direction = direction
			
			closest_direction = closest_direction.normalized()
			position += closest_direction * speed * delta
		
		if not is_enemy and state != States.ATTACKING_UNIT:
			state = States.MOVING
			var direction = Vector2(1000000, 1000000)
			if team == 0:
				direction = Global.blue_castle_pos - position
			elif team == 1:
				direction = Global.red_castle_pos - position
			
			direction = direction.normalized()
			
			position += direction * speed * delta

func _on_hitbox_entered(area):
	if area.is_in_group("Unit") and area.team != team and health > 0:
		attack_target = area
		state = States.ATTACKING_UNIT

func _on_random_person_area_exited(area):
	if attack_target != null and health > 0:
		if area == attack_target:
			attack_target = null
			state = States.IDLE
