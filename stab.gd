class_name Stab extends Node2D

var key_component: KeyComponent

func stab(key_component: KeyComponent):
	self.key_component = key_component
	$AnimatedSprite2D.play("default")
	get_tree().create_timer(0.3).timeout.connect(queue_free)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Damageable"):
		body.take_damage(key_component)
