class_name YeOleLocklet extends BaseLocklet

var randompos = Vector2.ZERO:
	set(value):
		randompos = value
const all_locklets = [
	preload("res://locklets/standard_locklet.tscn"),
	preload("res://locklets/red_locklet.tscn"),
	preload("res://locklets/pink_locklet.tscn"),
	preload("res://locklets/orange_locklet.tscn"),
	preload("res://locklets/green_locklet.tscn")
] 

func _ready():
	died.connect(win_game)
	super()

func win_game():
	get_tree().change_scene_to_file("res://win_screen.tscn")

func choose_position():
	randompos = global_position + Vector2(randf_range(-500, 500), randf_range(-500, 500))

func calculate_knockback(damage, direction: Vector2):
	pass

func calculate_movement(delta, pf):
	super(delta, pf)
	if navigation_agent.is_navigation_finished():
		choose_position()

func set_target_position():
	navigation_agent.target_position = randompos
	
func spawn_locklet():
	var locklet = all_locklets.pick_random().instantiate()
	locklet.global_position = global_position
	get_parent().add_child(locklet)
	choose_position()
