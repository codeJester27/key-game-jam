class_name PinkKeyComponent extends KeyComponent

const STAB = preload("res://stab.tscn")

func on_swing(player, key):
	self.player = player
	self.key = key
	
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)
	stab.on_damage.connect(heal_player)

func heal_player():
	var player = get_player()
	if player:
		player.heal(1)
