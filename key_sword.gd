class_name KeySword
extends Node2D

@export var damage: int = 1
@export var thrust_speed: float = 0.8 
@export var max_thrust_distance: float = 50.0
@onready var default_position: Vector2 = position
@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D

var is_thrusting: bool = false

func _ready():
	set_active(false)
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func set_active(active: bool):
	visible = active
	if collision_shape:
		collision_shape.disabled = !active

func thrust(direction: Vector2):
	if is_thrusting: 
		return
	
	is_thrusting = true
	set_active(true)

	rotation = direction.angle() + PI/2 
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", 
		direction * max_thrust_distance, 
		0.1 / thrust_speed
	).from_current()

	tween.tween_property(self, "scale", 
		Vector2(1.2, 1.2), 
		0.15 / thrust_speed
	).from(Vector2(1, 1))

	await get_tree().create_timer(0.15 / thrust_speed).timeout
	var return_tween = create_tween()
	return_tween.tween_property(self, "position", 
		default_position, 
		0.25 / thrust_speed
	)
	return_tween.tween_property(self, "scale", 
		Vector2(1, 1), 
		0.2 / thrust_speed
	)
	
	await return_tween.finished
	set_active(false)
	is_thrusting = false

func _on_hitbox_body_entered(body):
	if is_thrusting and body.has_method("take_damage"):
		var knockback_dir = (body.global_position - global_position).normalized()
		body.take_damage(damage, knockback_dir * 200)
