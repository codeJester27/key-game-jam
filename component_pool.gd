class_name ComponentPool extends Object

const components: Array[String] = [
	"res://key_components/basic_key_component.tscn",
	"res://key_components/red_key_component.tscn"
]

static var components_available: Array[String] = components.duplicate()

const component_info = {
	"res://key_components/basic_key_component.tscn": {
		"name": "Yellow Component",
		"description": "Does more damage to Yellow Locklets. Slightly increases your speed."
	},
	"res://key_components/red_key_component.tscn": {
		"name": "Red Component",
		"description": "Does more damage to Red Locklets. Leave a trail of fire."
	}
}
