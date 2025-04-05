class_name DungeonCamera extends Camera2D

func _process(delta):
	var player: Node2D = get_tree().get_first_node_in_group("Player")
	var rect = get_viewport_rect()
	
	var dungeon_pos: Vector2 = floor(player.position / rect.size)
	
	global_position = rect.size*dungeon_pos + rect.size/2.0
