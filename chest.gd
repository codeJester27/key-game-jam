extends Node2D

var unopened = true

func _on_area_2d_body_entered(body):
	if unopened and body is Player:
		if PickAComponentController.appear():
			$Sprite2D.frame = 1
			unopened = false
