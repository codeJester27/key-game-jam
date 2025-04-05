extends Area2D # Using Area2D for better collision detection

@export var speed := 600.0
@export var damage := 10
var direction := Vector2.RIGHT

func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
