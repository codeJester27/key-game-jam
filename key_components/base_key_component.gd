class_name KeyComponent extends Node2D

@export var width = 32

var player: Player
var key: Key

func on_swing(player: Player, key: Key):
	pass

func apply_modifiers(stats: Player.Stats):
	pass


func get_key() -> Key:
	if not key or not key.is_ancestor_of(self):
		var ancestor = get_parent()
		while ancestor and ancestor is not Key:
			ancestor = ancestor.get_parent()
		key = ancestor
	return key

func get_player() -> Player:
	if not player or not player.is_ancestor_of(self):
		var ancestor = get_parent()
		while ancestor and ancestor is not Player:
			ancestor = ancestor.get_parent()
		player = ancestor
	return player
