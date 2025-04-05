extends Control

const BUTTON = preload("res://component_choice_button.tscn")

@onready var choices_row = %ComponentChoicesRow

var component_choice: String

func _ready():
	for i in range(1,4):
		%KeyChoicesRow.get_node(str(i)).pressed.connect(key_choice_made.bind(i))

func appear() -> bool:
	get_tree().paused = true
	show()
	%ComponentChoice.show()
	%KeyChoice.hide()
	scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)
	if ComponentPool.components_available.size() <= 0:
		queue_free()
		return false
	var available = ComponentPool.components_available.duplicate()
	available.shuffle()
	var choices = available.slice(0, 3)
	for choice in choices:
		var button = BUTTON.instantiate()
		button.set_key_component(choice)
		button.text = ComponentPool.component_info[choice]["name"]
		button.tooltip_text = ComponentPool.component_info[choice]["description"]
		button.chosen.connect(component_choice_made)
		choices_row.add_child(button)
	
	return true

func component_choice_made(path: String):
	component_choice = path
	ComponentPool.components_available.remove_at(ComponentPool.components_available.find(path))
	%ComponentChoice.hide()
	%KeyChoice.show()
	for i in range(1, 4):
		var button: Button = %KeyChoicesRow.get_node(str(i))
		button.text = "Key %s" % str(i)
		var player: Player = get_tree().get_first_node_in_group("Player")
		var key: Key = player.key_list[i]
		var current_components = key.get_key_components()
		for component in current_components:
			button.text += "\n -" + ComponentPool.component_info[component.scene_file_path]["name"]
		if current_components.size() >= 3:
			button.disabled = true
			button.text += "\nMax Capacity!"
func key_choice_made(choice_index: int):
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.key_list[choice_index].add_component(load(component_choice).instantiate())
	for child in %KeyChoicesRow.get_children():
		child.disabled = true
	disappear()

func disappear():
	get_tree().paused = false
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(queue_free)
