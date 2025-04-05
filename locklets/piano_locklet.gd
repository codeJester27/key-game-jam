class_name PianoLocklet
extends BaseLocklet

@export var note_scene: PackedScene = preload("res://music_note.tscn")
@export var attack_range := 1000.0
@export var attack_cooldown := 2.0
@export var shooting_stop_distance := 300.0

var can_attack := true
var is_shooting := false
var is_knockback := false

func _physics_process(delta):
	super(delta)
	if is_shooting and can_attack:
		shoot_note(get_player_offset().normalized())

func calculate_movement(delta: float, pf: Dictionary):
	if is_knockback:
		move_and_slide()
		return
	
	var player_dist = pf["player_dist"]
	var direction = pf["next_dir"]
	if not navigation_agent.is_navigation_finished():
		update_sprite_facing(direction)
		var speed_multiplier = clamp(player_dist/follow_distance, 0.5, 1.0)
		if player_dist > shooting_stop_distance:
			var target_velocity = direction * SPEED * speed_multiplier
			velocity = velocity.lerp(target_velocity, acceleration * delta)
	if player_dist <= attack_range:
		update_sprite_facing(get_player_offset().normalized())
		is_shooting = true
		velocity = Vector2.ZERO
	move_and_slide()

func get_player_offset():
	return player.global_position - global_position

func shoot_note(direction: Vector2):
	if !can_attack or !note_scene:
		return
	
	can_attack = false
	
	var note = note_scene.instantiate()
	get_parent().add_child(note)
	note.position = $NoteSpawn.global_position
	note.rotation = direction.angle()
	
	if note.has_method("set_direction"):
		note.set_direction(direction)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_shooting = false

func calculate_knockback(damage: int, direction: Vector2):
	var knockback_power = damage * -50
	
	is_knockback = true
	velocity = direction * knockback_power
	
	await get_tree().create_timer(0.3).timeout
	is_knockback = false
