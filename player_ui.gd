extends CanvasLayer

@onready var health_bar = %HealthBar

func _process(delta):
	var current_scene = get_tree().current_scene
	if not is_instance_valid(current_scene):
		return

	if "menu" in current_scene.scene_file_path:
		hide()
		return
	else:
		show()
		
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		health_bar.value = player.health
		health_bar.max_value = player.max_health
