class_name PinkLocklet
extends BaseLocklet

@export var aura_heal_amount := 5
@export var heal_particles_scene: PackedScene = preload("res://heal_particles.tscn")

var allies_in_range: Array[Node] = []

func _ready():
	super._ready()  # Call parent's _ready first
	$Aura.body_entered.connect(_on_aura_body_entered)
	$Aura.body_exited.connect(_on_aura_body_exited)
	$Aura/Timer.timeout.connect(_on_aura_timer_timeout)
	$Aura/Timer.start()

func _on_aura_body_entered(body: Node):
	if body.is_in_group("enemies") and body != self:
		allies_in_range.append(body)
		print("Ally entered: ", body.name)

func _on_aura_body_exited(body: Node):
	allies_in_range.erase(body)
	print("Ally exited: ", body.name)

func _on_aura_timer_timeout():
	heal_all_allies(aura_heal_amount)

func heal_all_allies(amount: int):
	for ally in allies_in_range:
		if is_instance_valid(ally) and ally.has_method("heal"):
			heal_ally(ally, amount)

func heal_ally(ally: Node, amount: int):
	ally.heal(amount)
	spawn_heal_particles_on(ally)

func spawn_heal_particles_on(target: Node):
	var particles = heal_particles_scene.instantiate() 
	target.add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)

func heal(amount: int):
	super.modify_health(amount)
	var particles = heal_particles_scene.instantiate()
	add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
