class_name GreenLocklet
extends CharacterBody2D

@export var SPEED = 150
@export var follow_distance: float = 100.0
@export var acceleration: float = 5.0
@export var max_health: int = 20
@export var health: int = 25
@export var player: CharacterBody2D
@export var arrow_scene: PackedScene = preload("res://arrow.tscn")
@export var attack_range := 400.0
@export var attack_cooldown := 3.0  # Now 3 seconds
@export var shooting_stop_distance := 300.0

@export var particles_scene: PackedScene = preload("res://gpu_particles_2d.tscn")
var can_attack := true
var is_shooting := false
var is_knockback := false

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
	
	if is_knockback:
		move_and_slide()
		return
	
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	var relative_pos = player.global_position - global_position
	
	# Animation handling
	if relative_pos.y < 0:
		$AnimatedSprite2D.play("back_move")
	elif relative_pos.y > 0:
		$AnimatedSprite2D.play("front_move")
	
	$AnimatedSprite2D.flip_h = relative_pos.x > 0
	
	# Movement and shooting
	if distance > shooting_stop_distance:
		is_shooting = false
		var speed_multiplier = clamp(distance/follow_distance, 0.5, 1.0)
		var target_velocity = direction * SPEED * speed_multiplier
		velocity = velocity.lerp(target_velocity, acceleration * delta)
		move_and_slide()
	elif distance <= attack_range and can_attack and not is_shooting:
		is_shooting = true
		velocity = Vector2.ZERO
		shoot_arrow(direction)

func shoot_arrow(direction: Vector2):
	if !can_attack or !arrow_scene:
		return
	
	can_attack = false
	
	# Create arrow
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.position = $ArrowSpawn.global_position
	arrow.rotation = direction.angle()
	
	if arrow.has_method("set_direction"):
		arrow.set_direction(direction)
	
	# Wait full 3 seconds before next attack
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_shooting = false

func take_damage(damage: int, source: Node, hit_position: Vector2):
	if particles_scene == null:
		push_error("No particles scene assigned!")
		return
	
	# Damage effects
	var particles = particles_scene.instantiate()
	add_child(particles)
	particles.global_position = hit_position
	particles.emitting = true
	
	if particles.has_signal("finished"):
		particles.finished.connect(particles.queue_free)
	else:
		get_tree().create_timer(1.0).timeout.connect(particles.queue_free)
	
	# Apply knockback
	apply_knockback(source.global_position, damage)
	modify_health(-damage)

func apply_knockback(source_position: Vector2, damage: int):
	var knockback_dir = (global_position - source_position).normalized()
	var knockback_power = damage * 50
	
	is_knockback = true
	velocity = knockback_dir * knockback_power
	
	await get_tree().create_timer(0.3).timeout
	is_knockback = false

func modify_health(delta: int):
	health = clamp(health + delta, 0, max_health)
	if health <= 0:
		queue_free()
