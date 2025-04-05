class_name GreenKeyComponent extends KeyComponent

const STAB = preload("res://stab.tscn")

func on_swing(player, key):
	self.player = player
	self.key = key
	
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)

func apply_modifiers(stats):
	stats.speed_while_attacking /= 0.7
