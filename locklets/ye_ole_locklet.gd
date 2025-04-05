class_name YeOleLocklet extends BaseLocklet

@onready var randompos = choose_position()

func choose_position():
	randompos = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))

func calculate_knockback(damage, direction: Vector2):
	pass

func calculate_movement(delta, pf):
	super(delta, pf)
	if navigation_agent.is_navigation_finished:
		choose_position()

func set_target_position():
	navigation_agent.target_position = randompos
	
