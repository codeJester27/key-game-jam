extends CanvasLayer

const PICK = preload("res://pick_a_component.tscn")

func appear() -> bool:
	if get_child_count() <= 0:
		var pick = PICK.instantiate()
		add_child(pick)
		pick.appear()
		return true
	return false
