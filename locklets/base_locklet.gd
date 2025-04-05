class_name BaseLocklet
extends CharacterBody2D

const HP_NUMBER = preload("res://health_modification_number.tscn")

@export var SPEED = 200
@export var follow_distance: float = 100.0
@export var acceleration: float = 5.0
@export var max_health: int = 20
@export var health: int = 20
@export var player: CharacterBody2D
@onready var navigation_agent = $NavigationAgent2D

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
	set_target_position()
	calculate_movement(delta, get_pathfinding_info())

func set_target_position():
	var target_position = player.global_position
	navigation_agent.target_position = target_position

func get_pathfinding_info():
	var next_path_position = navigation_agent.get_next_path_position()
	return {
		"next_pos": next_path_position,
		"next_dir": (next_path_position - global_position).normalized(),
		"next_dist": global_position.distance_to(next_path_position),
		"player_dist": global_position.distance_to(player.global_position),
	}

func calculate_movement(delta: float, pf: Dictionary):
	if not navigation_agent.is_navigation_finished():
		var next_path_position = pf["next_pos"]
		var direction = pf["next_dir"]
		var distance = pf["next_dist"]
		
		update_sprite_facing(direction)
		
		var speed_multiplier = clamp(pf["player_dist"]/follow_distance, 0.5, 1.0)
		var target_velocity = direction * SPEED * speed_multiplier
		velocity = velocity.lerp(target_velocity, acceleration * delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func update_sprite_facing(facing: Vector2):
	if facing.y < 0:
		$AnimatedSprite2D.play("back_move")
	elif facing.y > 0:
		$AnimatedSprite2D.play("front_move")
	
	if facing.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif facing.x < 0:
		$AnimatedSprite2D.flip_h = false

func calculate_damage_modifiers(damage, source: Node, hit_position: Vector2):
	return damage * 2.0 if attack_should_crit(source) else damage

func attack_should_crit(source: Node) -> bool:
	return false

func take_damage(damage, source: Node, hit_position: Vector2):
	var direction = (player.global_position - global_position).normalized()
	damage = calculate_damage_modifiers(damage, source, hit_position)
	
	var hp_num = HP_NUMBER.instantiate()
	hp_num.global_position = global_position
	get_tree().current_scene.add_child(hp_num)
	hp_num.appear(-damage, attack_should_crit(source))
	
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
	
	calculate_knockback(damage, direction)

func calculate_knockback(damage, direction: Vector2):
	# Knockback effect
	var knockback_dir = -direction
	velocity = knockback_dir * 400 * (damage/10.0)

func modify_health(delta: int):
	health = clamp(health + delta, 0, max_health)
	if health <= 0:
		queue_free()

func heal(num: int):
	modify_health(num)
	
	var hp_num = HP_NUMBER.instantiate()
	hp_num.global_position = global_position
	get_tree().current_scene.add_child(hp_num)
	hp_num.appear(num)
