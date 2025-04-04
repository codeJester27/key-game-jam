class_name Player
extends CharacterBody2D

@export var SPEED = 250.0
@onready var screen_size = get_viewport_rect().size
@onready var key_holder = %KeyHolder
@onready var key_holder_pivot = $KeyHolderPivot


var is_attacking: bool = false
var thrust_distance: float = 60.0
var attack_duration: float = 0.2
var base_sword_offset = Vector2(120, 0) 

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	var key = get_held_key()
	
	if not key.is_swinging:
		var swing_angle = (get_global_mouse_position() - global_position).angle()
		key_holder_pivot.global_rotation = swing_angle
	
	velocity = input_direction * (SPEED * (0.7 if key and key.is_swinging else 1.0))
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and key:
		perform_attack(key)

func get_held_key() -> Key:
	for child in key_holder.get_children():
		if child is Key:
			return child
	return null

func equip(key: Key):
	key.player = self

func perform_attack(key: Key):
	key.swing()
	
