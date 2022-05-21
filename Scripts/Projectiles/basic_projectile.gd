extends Area2D

@export var speed = 10
@export var damage = 10

var target = Vector2(0, 0)
var direction = Vector2(0, 0)

func _ready():
	direction = (Vector2(target.x, target.y + 10)) - position
	direction = direction.normalized()

func _physics_process(delta):
	if position == target:
		queue_free()
	
	position += direction * speed * delta

func _on_unit_entered_range(area):
	if area.is_in_group("Unit"):
		area.health -= damage
		queue_free()
