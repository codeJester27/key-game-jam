extends KeyComponent

const STAB = preload("res://stab.tscn")

func on_swing(player, key):
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)

func apply_modifiers(stats):
	stats.damage *= 1.5
