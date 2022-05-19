extends Area2D

enum States { IDLE, MOVING, ATTACKING_UNIT, ATTACKING_BUILDING }
var state = States.IDLE

var speed = 100
var health = 100
var attack = 5

var id = 0
var team = 0

var attack_target = null
var tracking_target = null

func _physics_process(delta):
	health -= 0.5
	
	if health <= 0:
		Global.units.remove_at(id)
		#Global.deletion_queue.append(id)
		queue_free()
	
	if state == States.ATTACKING_UNIT:
		attack_target.health -= attack
	
	if len(Global.units) > 0 and state == States.IDLE or state == States.MOVING:
		state = States.MOVING
		
		var closest_direction = Vector2(100000000, 100000000)
		
		for unit in Global.units:
			if is_instance_valid(unit):
				if unit.team != team:
					var direction = (Vector2(unit.position.x, unit.position.y + 10)) - position
					direction = direction.normalized()
					
					if unit.position.distance_to(position) < closest_direction.distance_to(position):
						closest_direction = direction
					#if direction < Vector2(0, 0):
					#	if direction > -closest_direction:
					#		closest_direction = direction
					#else:
					#	if direction < closest_direction:
					#		closest_direction = direction
		
		position += closest_direction * speed * delta

func _on_hitbox_entered(area):
	if area.is_in_group("Unit") and area.team != team:
		attack_target = area
		state = States.ATTACKING_UNIT

func _on_random_person_area_exited(area):
	if attack_target != null:
		if area == attack_target:
			attack_target = null
			state = States.IDLE
