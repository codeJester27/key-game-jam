class_name BasicKeyComponent extends KeyComponent

const STAB = preload("res://stab.tscn")

var player: Player
var key: Key

func on_swing(player, key):
	self.player = player
	self.key = key
	
	var stab = STAB.instantiate()
	add_child(stab)
	stab.stab(self)
