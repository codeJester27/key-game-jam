class_name Arrow extends RigidBody2D

var damage := 10
var speed := 600
var direction := Vector2.RIGHT

func _ready():
	$Timer.start(2.0)  # Auto-delete after 2 seconds
	apply_impulse(direction * speed)

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
