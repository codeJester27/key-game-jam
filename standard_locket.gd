class_name StandardLocklet
extends CharacterBody2D

@export var SPEED = 125
@export var follow_distance: float = 100.0
@export var acceleration: float = 5.0
@export var health: int = 10

@export var player: CharacterBody2D


func _ready():
	$AnimatedSprite2D.play("front_move")
	if !player:
		player = get_tree().get_first_node_in_group("Player")
		if !player:
			push_error("No player reference assigned!")
			set_physics_process(false)
			
func _physics_process(delta):
	if !player or !is_instance_valid(player):
		return
	
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	var relative_pos = player.global_position - global_position
	
	var speed_multiplier = clamp(distance/follow_distance, 0.5, 1.0)
	var target_velocity = direction * SPEED * speed_multiplier
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
	
	if relative_pos.y < 0:
		$AnimatedSprite2D.play("back_move")
	elif relative_pos.y > 0:
		$AnimatedSprite2D.play("front_move")
	
	if relative_pos.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif relative_pos.x < 0:
		$AnimatedSprite2D.flip_h = false


func take_damage(source: Node):
	$damage_timer.start()
	
