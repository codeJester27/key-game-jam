extends Button

var path: String

signal chosen(path: String)

func set_key_component(path: String):
	self.path = path
	icon = KeyComponentPreviewGenerator.previews[path].get_texture()

func _on_pressed():
	chosen.emit(path)
