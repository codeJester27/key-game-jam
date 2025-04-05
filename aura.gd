extends Area2D

@export var heal_amount := 5
@export var heal_interval := 3.0
var allies_in_range := []

func _ready():
	$Timer.wait_time = heal_interval
	$Timer.start()

func _on_body_entered(body):
	if body.is_in_group("enemies") and body != get_parent():
		allies_in_range.append(body)

func _on_body_exited(body):
	allies_in_range.erase(body)

func _on_timer_timeout():
	for ally in allies_in_range:
		if is_instance_valid(ally) and ally.has_method("heal"):
			ally.heal(heal_amount)
