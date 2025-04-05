class_name KeyComponentPreviewViewport extends SubViewport

func add_key_component(key_component: Node2D):
	add_child(key_component)
	key_component.position = Vector2(32, 32)
