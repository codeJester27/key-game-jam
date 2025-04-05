class_name Player
extends CharacterBody2D

const HALF_PI = PI/2.0
const HP_NUMBER = preload("res://health_modification_number.tscn")

@export var speed = 190.0
@export var base_damage := 5
@export var base_attack_speed := 1.0
@export var base_speed_while_attacking := 0.7
@onready var screen_size = get_viewport_rect().size
@onready var key_holder = %KeyHolder
@onready var key_holder_pivot = $KeyHolderPivot
@onready var sprite = $AnimatedSprite2D

@export var max_health: int = 20
@export var health: int = 20
@export var invincibility_time: float = 0.5
var is_invincible: bool = false

@export var new_key: PackedScene = preload("res://key.tscn")

var key_list: Array[Key] = []

var is_attacking: bool = false
var thrust_distance: float = 60.0
var attack_duration: float = 0.2
var base_sword_offset = Vector2(120, 0)
var stats: Stats = null

func _ready():
	add_key($KeyHolderPivot/KeyHolder/Paperclip)
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	for i in range(3):
		var key = new_key.instantiate()
		## hacky way to ready the key
		add_child(key)
		remove_child(key)
		key_list.append(key)

func _physics_process(delta):
	call_deferred("clear_stats")
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	var key = get_held_key()
	var swinging = key.is_swinging if key else false
	
	key_holder.visible = swinging
	
	var stats = get_player_stats()
	
	velocity = input_direction * (stats.speed * (stats.speed_while_attacking if key and swinging else 1.0))
	
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.speed_scale = velocity.length() / speed
	
	if not swinging:
		if Input.is_action_pressed("attack"):
			perform_attack(key)
		
		for i in range(0, 4):
			if Input.is_action_just_pressed(str(i + 1)):
				equip(key_list[i])

	if swinging:
		var swing_angle = key_holder_pivot.global_rotation
		sprite.flip_h = swing_angle > -HALF_PI and swing_angle < HALF_PI
	elif velocity.x != 0:
		sprite.flip_h = velocity.x > 0
		
	move_and_slide()

func take_damage(damage: int):
	var old_health = health
	health = max(health - damage, 0)
	
	print("[DAMAGE] Took %d damage | Health: %d → %d" % [damage, old_health, health])
	
	var num = HP_NUMBER.instantiate()
	num.global_position = global_position
	get_tree().current_scene.add_child(num)
	num.appear(-damage)
	
	if health <= 0:
		die()

func heal(hp: int):
	health = clamp(health + 1, 0, max_health)
	var num = HP_NUMBER.instantiate()
	num.global_position = global_position
	get_tree().current_scene.add_child(num)
	num.appear(hp)

func die():
	print("Player died!")
	queue_free()
	
func _on_invincibility_timer_timeout():
	is_invincible = false

func _on_hitbox_body_entered(body: Node):
	if !body.is_in_group("Player"):
		take_damage(10)
		return

func get_held_key() -> Key:
	for child in key_holder.get_children():
		if child is Key:
			return child
	return null
	
func add_key(key: Key):
	key_list.append(key)

func equip(key: Key):
	key.player = self
	for child in key_holder.get_children():
		key_holder.remove_child(child)
	key_holder.add_child(key)

func perform_attack(key: Key):
	var swing_angle = (get_global_mouse_position() - global_position).angle()
	key_holder_pivot.global_rotation = swing_angle
	if key:
		key.swing()

func get_player_stats() -> Stats:
	if stats:
		return stats
	stats = Stats.new(base_damage, base_attack_speed, speed, base_speed_while_attacking)
	var key = get_held_key()
	if key:
		for component in key.get_key_components():
			component.apply_modifiers(stats)
	return stats

func clear_stats():
	stats = null

class Stats:
	var damage
	var attack_speed
	var speed
	var speed_while_attacking
	func _init(damage, attack_speed, speed, speed_while_attacking):
		self.damage = damage
		self.attack_speed = attack_speed
		self.speed = speed
		self.speed_while_attacking = speed_while_attacking
