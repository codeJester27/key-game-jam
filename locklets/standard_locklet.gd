class_name StandardLocklet extends BaseLocklet

func calculate_damage_modifiers(damage, source: Node, hit_position: Vector2):
	return damage * 2.0 if source is Stab and source.key_component is BasicKeyComponent else damage
