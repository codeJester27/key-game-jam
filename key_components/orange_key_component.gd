class_name OrangeKeyComponent extends KeyComponent

const STAB = preload("res://stab.tscn")

func on_swing(player, key):
	self.player = player
	self.key = key
	
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)

func apply_modifiers(stats):
	stats.damage *= 1.0/3.0
	stats.attack_speed *= 5.0
