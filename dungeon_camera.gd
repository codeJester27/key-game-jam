class_name DungeonCamera extends Camera2D

func _process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if not is_instance_valid(player):
		return 
	
	var rect = get_viewport_rect()
	var dungeon_pos = floor(player.position / rect.size)
	global_position = rect.size * dungeon_pos + rect.size / 2.0
