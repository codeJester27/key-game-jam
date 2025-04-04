class_name Stab extends Node2D

func stab():
	$AnimatedSprite2D.play("default")
	
	get_tree().create_timer(0.3).timeout.connect(queue_free)
