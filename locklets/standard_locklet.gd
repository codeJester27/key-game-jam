class_name StandardLocklet extends BaseLocklet

func attack_should_crit(source):
	return source.get("key_component") is BasicKeyComponent
