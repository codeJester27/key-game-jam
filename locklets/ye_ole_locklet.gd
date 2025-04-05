class_name YeOleLocklet extends BaseLocklet

@onready var randompos = choose_position()
const all_locklets = [
	preload("res://locklets/standard_locklet.tscn"),
	preload("res://locklets/red_locklet.tscn"),
	preload("res://locklets/pink_locklet.tscn"),
	preload("res://locklets/orange_locklet.tscn"),
	preload("res://locklets/green_locklet.tscn")
] 

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
	
func spawn_locklets():
	all_locklets.shuffle()
	var locklet = all_locklets[0].instantiate()
	get_parent().add_child(locklet)
