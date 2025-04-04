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
	position_components()
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

func position_components():
	var left_edge = 12.0
	for component in key_components.get_children():
		if component is KeyComponent:
			component.position.x = left_edge + component.width/2.0
			left_edge += component.width

func add_component(component: KeyComponent):
	key_components.add_child(component)
	position_components()
