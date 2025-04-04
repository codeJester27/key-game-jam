class_name Player
extends CharacterBody2D

@export var SPEED = 250.0
@onready var sword: Node2D = $key_sword
@onready var screen_size = get_viewport_rect().size
var attack_cooldown: float = 0.5
var can_attack: bool = true

# Animation properties
var is_attacking: bool = false
var thrust_distance: float = 60.0
var attack_duration: float = 0.2
var base_sword_offset = Vector2(120, 0) # Position relative to player body

func _ready():
	set_physics_process(true)
	sword.visible = false
	if sword.has_node("Hitbox"):
		sword.get_node("Hitbox/CollisionShape2D").disabled = true
	sword.position = base_sword_offset # Set initial position

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
	velocity = input_direction * (SPEED * (0.7 if is_attacking else 1.0))
	move_and_slide()
	_clamp_to_screen()
	
	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()

func _clamp_to_screen():
	# Get the sprite's actual size (adjust if your hitbox is different)
	var sprite_size = Vector2(128, 128) * .35
	var half_size = sprite_size / 2
	
	# Calculate screen boundaries considering sprite size
	var min_x = half_size.x
	var max_x = screen_size.x - half_size.x
	var min_y = half_size.y
	var max_y = screen_size.y - half_size.y
	
	# Clamp position
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func perform_attack():
	if !can_attack: return
	
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	
	# Position sword at body with proper rotation
	sword.rotation = mouse_dir.angle() + PI/2
	sword.position = base_sword_offset.rotated(mouse_dir.angle())
	sword.visible = true
	
	# Enable hitbox
	if sword.has_node("Hitbox"):
		sword.get_node("Hitbox/CollisionShape2D").disabled = false
	
	can_attack = false
	is_attacking = true
	
	# Thrust animation
	var thrust_tween = create_tween()
	thrust_tween.tween_property(sword, "position", 
		base_sword_offset.rotated(mouse_dir.angle()) + mouse_dir * thrust_distance, 
		attack_duration * 0.4)
	thrust_tween.parallel().tween_property(sword, "scale", 
		Vector2(1.3, 1.3), 
		attack_duration * 0.3)
	
	# Return animation
	await get_tree().create_timer(attack_duration * 0.5).timeout
	var return_tween = create_tween()
	return_tween.tween_property(sword, "position", 
		base_sword_offset.rotated(mouse_dir.angle()), 
		attack_duration * 0.6)
	return_tween.parallel().tween_property(sword, "scale", 
		Vector2.ONE, 
		attack_duration * 0.5)
	
	await return_tween.finished
	
	# Reset
	sword.visible = false
	if sword.has_node("Hitbox"):
		sword.get_node("Hitbox/CollisionShape2D").disabled = true
	
	is_attacking = false
	can_attack = true
