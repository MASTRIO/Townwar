@tool
extends Area2D

signal unit_idle
signal unit_moving
signal unit_attacking

enum States { IDLE, MOVING, ATTACKING }
@export var state: States = States.IDLE

@export var red_colour_x = 14.0
@export var blue_colour_x = 78.0

@export var speed = 100
@export var health = 1000
@export var attack = 500

var id = 0
var team = 0

var attack_target = null

func _enter_tree():
	self.area_entered.connect(_hitbox_entered)
	self.area_exited.connect(_hitbox_exited)
	
	Global.units.append(self)
	
	if team == 0:
		get_node("Sprite").texture.region.position.x = red_colour_x
	elif team == 1:
		get_node("Sprite").texture.region.position.x = blue_colour_x

func _physics_process(delta):
	if health <= 0:
		Global.units.remove_at(id)
		#Global.deletion_queue.append(id)
		queue_free()
	
	if state == States.IDLE:
		state_IDLE()
	elif state == States.MOVING:
		state_MOVING(delta)
	elif state == States.ATTACKING:
		state_ATTACKING()

func state_IDLE():
	emit_signal("unit_idle")
	
	var enemy_alive = false
	for unit in Global.units:
		if is_instance_valid(unit):
			if unit.team != team:
				enemy_alive = true
	if enemy_alive:
		state = States.MOVING

func state_MOVING(delta):
	emit_signal("unit_moving")
	
	if attack_target != null:
		state = States.ATTACKING
	
	var closest_direction = Vector2(100000000, 100000000)
	
	for unit in Global.units:
		if is_instance_valid(unit):
			if unit.team != team:
				var direction = (Vector2(unit.position.x, unit.position.y + 10)) - position
				
				if unit.position.distance_to(position) < closest_direction.distance_to(position):
					closest_direction = direction
	
	closest_direction = closest_direction.normalized()
	position += closest_direction * speed * delta

func state_ATTACKING():
	emit_signal("unit_attacking")
	
	if attack_target != null:
		attack_target.health -= attack

func _hitbox_entered(area):
	if area.is_in_group("Unit") and area.team != team and health > 0:
		attack_target = area

func _hitbox_exited(area):
	if attack_target != null and health > 0:
		if area == attack_target:
			attack_target = null
			state = States.IDLE
