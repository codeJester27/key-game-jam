class_name PurpleKeyComponent extends KeyComponent

@export var ball_scene: PackedScene = preload("res://key_components/shadow_ball.tscn")
@export var attack_range := 400.0
@export var ball_speed := 400.0
@export var attack_cooldown := 1.0
@export var shooting_stop_distance := 300.0

var can_attack := true
@onready var ball_spawn := $BallSpawn

const STAB = preload("res://stab.tscn")

func on_swing(player, key):
	self.player = player
	self.key = key

	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)

	if can_attack:
		shoot_balls()

func shoot_balls():
	if !can_attack or !ball_scene or !ball_spawn:
		return
	
	can_attack = false

	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - ball_spawn.global_position).normalized()

	var ball = ball_scene.instantiate()

	var root = get_tree().current_scene
	root.add_child(ball)

	ball.global_position = ball_spawn.global_position
	ball.key_component = self
	ball.rotation = direction.angle()

	if ball.has_method("set_velocity"):
		ball.set_velocity(direction * ball_speed)
	elif ball.has_method("set_direction"):
		ball.set_direction(direction)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
