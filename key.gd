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
	
	##this is most for testing purposes
	for child in get_children():
		if child is KeyComponent:
			remove_child(child)
			add_component(child)

func swing():
	for comp in key_components.get_children():
		if comp is KeyComponent:
			comp.on_swing(player, self)
	animation_player.play("swing")
	var stats = get_player().get_player_stats()
	animation_player.speed_scale = stats.attack_speed

func position_components():
	var left_edge = 12.0
	var z = 0
	for component in key_components.get_children():
		if component is KeyComponent:
			component.position.x = left_edge + component.width/2.0
			component.z_index = z
			z += 1
			left_edge += component.width - 1

func get_player() -> Player:
	if not player or not player.is_ancestor_of(self):
		var ancestor = get_parent()
		while ancestor and ancestor is not Player:
			ancestor = ancestor.get_parent()
		player = ancestor
	return player

func get_key_components() -> Array[KeyComponent]:
	var comps: Array[KeyComponent] = []
	for component in key_components.get_children():
		if component is KeyComponent:
			comps.append(component)
	return comps

func add_component(component: KeyComponent):
	if not is_node_ready():
		await ready
	key_components.add_child(component)
	position_components()
