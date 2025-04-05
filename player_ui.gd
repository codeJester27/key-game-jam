extends CanvasLayer

@onready var health_bar = %HealthBar

func _process(delta):
	var player: Player = get_tree().get_first_node_in_group("Player")
	
	if player:
		health_bar.value = player.health
		health_bar.max_value = player.max_health
