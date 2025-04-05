class_name RedLocklet
extends BaseLocklet

# remove knockback
func calculate_knockback(damage, direction: Vector2):
	pass

func attack_should_crit(source):
	return source.get("key_component") is RedKeyComponent
