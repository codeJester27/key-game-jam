extends Label

const DAMAGE = preload("res://damage_label_settings.tres")
const CRIT = preload("res://crit_label_settings.tres")
const HEAL = preload("res://heal_label_settings.tres")

var velocity: Vector2

func appear(number, critical = false):
	text = String.num(number, 2)
	if critical:
		label_settings = CRIT
	elif number < 0:
		label_settings = DAMAGE
	else:
		label_settings = HEAL
	
	velocity = Vector2(randf_range(-400.0, 400.0), randf_range(-600.0, -400.0))
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", modulate*Color.TRANSPARENT, 1.0)
	tween.tween_callback(queue_free)

func _process(delta):
	velocity += Vector2(0, 2000*delta)
	position += velocity * delta
