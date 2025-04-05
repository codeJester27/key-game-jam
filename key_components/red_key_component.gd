class_name RedKeyComponent extends KeyComponent

const STAB = preload("res://stab.tscn")
const FIRE = preload("res://key_components/fire.tscn")

func on_swing(player, key):
	self.player = player
	self.key = key
	
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)


func _on_spawn_fire_timer_timeout():
	var player = get_player()
	if player:
		var fire = FIRE.instantiate()
		fire.key_component = self
		get_tree().current_scene.add_child(fire)
		fire.global_position = player.global_position
