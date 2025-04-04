class_name Stab extends Node2D

var key_component: KeyComponent
var damage := 5.0

signal on_damage

func stab(key_component: KeyComponent):
	var stats = key_component.get_player().get_player_stats()
	damage = stats.damage
	self.key_component = key_component
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.speed_scale = stats.attack_speed
	get_tree().create_timer(0.3/stats.attack_speed).timeout.connect(queue_free)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Damageable"):
		on_damage.emit()
		var hit_pos = $Area2D.global_position
		body.take_damage(damage, self, hit_pos)
