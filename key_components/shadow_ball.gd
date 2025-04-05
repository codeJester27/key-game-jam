class_name ShadowBall extends Area2D 
@export var speed := 400.0
@export var damage := 15
@export var max_lifetime := 2.0
var direction := Vector2.RIGHT
var key_component: KeyComponent

func _ready():
	body_entered.connect(_on_body_entered)

func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, self, direction)
	queue_free()
