class_name Player
extends CharacterBody2D

const HALF_PI = PI/2.0

@export var speed = 190.0
@export var base_damage := 5
@export var base_attack_speed := 1.0
@onready var screen_size = get_viewport_rect().size
@onready var key_holder = %KeyHolder
@onready var key_holder_pivot = $KeyHolderPivot
@onready var sprite = $AnimatedSprite2D

@export var new_key: PackedScene = preload("res://key.tscn")
@onready var eKey: Key = new_key.instantiate()

@onready var key_list: Array = []

var is_attacking: bool = false
var thrust_distance: float = 60.0
var attack_duration: float = 0.2
var base_sword_offset = Vector2(120, 0)
var stats: Stats = null

func _ready():
	add_key($KeyHolderPivot/KeyHolder/Paperclip)
	add_key(eKey)
	eKey.add_component(preload("res://key_components/basic_key_component.tscn").instantiate())

func _physics_process(delta):
	call_deferred("clear_stats")
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	var key = get_held_key()
	var swinging = key.is_swinging if key else false
	
	key_holder.visible = swinging
	
	velocity = input_direction * (speed * (0.7 if key and swinging else 1.0))
	
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.speed_scale = velocity.length() / speed
		
	if Input.is_action_just_pressed("attack") and not swinging:
		perform_attack(key)
		
	if Input.is_action_just_pressed("1") and not swinging:
		equip(key_list[0])
	elif Input.is_action_just_pressed("2") and not swinging:
		equip(key_list[1])

	if swinging:
		var swing_angle = key_holder_pivot.global_rotation
		sprite.flip_h = swing_angle > -HALF_PI and swing_angle < HALF_PI
	elif velocity.x != 0:
		sprite.flip_h = velocity.x > 0
		
	move_and_slide()

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
	stats = Stats.new(base_damage, base_attack_speed)
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
	func _init(damage, attack_speed):
		self.damage = damage
		self.attack_speed = attack_speed
