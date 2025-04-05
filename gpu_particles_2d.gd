class_name FlashParticles extends GPUParticles2D

func _ready():
	emitting = false
	finished.connect(queue_free)
