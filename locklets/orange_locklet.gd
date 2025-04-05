extends BaseLocklet

@export var super_speed = 600

var charging = false
var rot_speed = 0.0
var speeding = false
var time_speeding = 0.0

func calculate_movement(delta: float, pf: Dictionary):
	if not charging:
		speeding = false
		rotation = 0
		rot_speed = 0.0
		time_speeding = 0.0
		if randi_range(0, int(4.0/delta)) == 0:
			charging = true
	
	if not speeding:
		super(delta, pf)
	
	if charging:
		rot_speed += delta*TAU*3.0
		rotate(rot_speed * delta)
		if rot_speed > TAU*6.0:
			speeding = true
			
	
	if speeding:
		time_speeding += delta
		var col = move_and_collide(velocity * delta)
		velocity = (velocity if velocity != Vector2.ZERO else pf["next_dir"]).normalized() * super_speed
		
		if col:
			velocity = velocity.bounce(col.get_normal())
	
	if time_speeding > 4.0:
		charging = false
		speeding = false
		time_speeding = 0.0

func attack_should_crit(source):
	return source.get("key_component") is OrangeKeyComponent
