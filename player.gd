class_name Player extends CharacterBody2D

@export var SPEED = 500.0

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
	velocity = input_direction * SPEED
	
	move_and_slide()
