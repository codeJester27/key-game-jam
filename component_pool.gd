class_name ComponentPool extends Object

const components: Array[String] = [
	"res://key_components/basic_key_component.tscn",
	"res://key_components/red_key_component.tscn",
	"res://key_components/green_key_component.tscn",
	"res://key_components/purple_key_component.tscn",
	"res://key_components/pink_key_component.tscn"
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
	},
	"res://key_components/green_key_component.tscn": {
		"name": "Green Component",
		"description": "Does more damage to Green Locklets. Move at normal speed while attacking."
	},
	"res://key_components/purple_key_component.tscn": {
		"name": "Purple Component",
		"description": "Shoots a powerful shadow energy ball that can deal with a horde of enemies."
	},
	"res://key_components/pink_key_component.tscn": {
		"name": "Pink Component",
		"description": "Does more damage to Pink Locklets. Heal from attacks."
	}
}
