class_name Key extends Node2D

## Use for testing only plz
@export var auto_equip = false

var player: Player
var is_swinging:
	get:
		return animation_player.current_animation == "swing" and animation_player.is_playing()

@onready var key_components = %KeyComponents
@onready var pivot = $Pivot
@onready var animation_player = %AnimationPlayer

func _ready():
	if auto_equip:
		var ancestor = get_parent()
		while ancestor and ancestor is not Player:
			ancestor = ancestor.get_parent()
		if ancestor:
			ancestor.equip(self)

func swing():
	for comp in key_components.get_children():
		if comp is KeyComponent:
			comp.on_swing(player, self)
	animation_player.play("swing")

func add_component(component):
	key_components
	pass
