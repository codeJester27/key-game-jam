extends Node

const KEY_COMPONENT_PREVIEW = preload("res://key_component_preview_viewport.tscn")

var previews: Dictionary[String, KeyComponentPreviewViewport] = {}

func _ready():
	for path in ComponentPool.components:
		var scene: PackedScene = load(path)
		var kc = scene.instantiate()
		var preview = KEY_COMPONENT_PREVIEW.instantiate()
		preview.add_key_component(kc)
		add_child(preview)
		previews[path] = preview
