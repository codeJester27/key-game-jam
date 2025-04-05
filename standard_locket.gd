class_name StandardLocklet
extends CharacterBody2D

@export var SPEED = 125
@export var follow_distance: float = 100.0
@export var acceleration: float = 5.0
@export var max_health: int = 20
@export var health: int = 20
@export var player: CharacterBody2D

# Assign this in inspector or provide fallback
@export var particles_scene: PackedScene = preload("res://gpu_particles_2d.tscn")

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

func take_damage(damage, source: Node, hit_position: Vector2):
	var direction = (player.global_position - global_position).normalized()
	if particles_scene == null:
		push_error("No particles scene assigned!")
		return
	
	# Instantiate and configure particles
	var particles = particles_scene.instantiate()
	add_child(particles)
	particles.global_position = hit_position
	particles.emitting = true
	
	# Auto-cleanup
	if particles.has_signal("finished"):
		particles.finished.connect(particles.queue_free)
	else:
		# Fallback timer if no finished signal
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(particles.queue_free)
	
	# Damage handling
	modify_health(-damage)
	
	
	# Knockback effect
	var knockback_dir = -direction
	velocity = knockback_dir * 400

func modify_health(delta: int):
	health = clamp(health + delta, 0, max_health)
	if health <= 0:
		queue_free()
