extends GPUParticles2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	emitting = true

func _on_finished():
	call_deferred("free")
