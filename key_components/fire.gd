extends Node2D

var key_component: KeyComponent

func _ready():
	$TickTimer.start()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 2.0).set_delay(3.0)
	tween.tween_callback(queue_free)

func _on_tick_timer_timeout():
	$Sprite2D.flip_h = not $Sprite2D.flip_h
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Damageable"):
			body.take_damage(1.0, self, global_position)
