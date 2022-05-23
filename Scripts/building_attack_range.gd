extends Area2D

@export var projectile = preload("res://Projectiles/Cannonball.tscn")
@export var attack_delay = 0.5

var timer = 0

var enemies_in_range = []

func _physics_process(delta):
	timer += delta
	
	if timer >= attack_delay:
		timer -= attack_delay
		if len(enemies_in_range) > 0:
			var projectile_instance = projectile.instantiate()
			
			projectile_instance.position = position
			projectile_instance.target = enemies_in_range[0].position
			
			get_parent().get_parent().get_parent().get_node("Projectiles").add_child(projectile_instance)

func _on_range_entered(area):
	print("A")
	if area.is_in_group("Unit") and area.team != get_parent().team:
		print("sus!")
		enemies_in_range.append(area)

func _on_range_exited(area):
	if area.is_in_group("Unit"):
		if area in enemies_in_range and area.team != get_parent().team:
			var counter = 0
			for unit in enemies_in_range:
				if area == unit:
					enemies_in_range.remove_at(counter)
				counter += 1
