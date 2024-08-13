extends CanvasLayer

@export var path = "res://scenes/particles/"

var particles = []

func _ready():
	locate_scenes()
	cache_materials()

func locate_scenes():
	var dir = DirAccess.open(path)
	
	if dir:
		var files = dir.get_files()
		
		for i in files:
			particles.append(load(path + i))
		
	else:
		print('Error: no directory found at path "' + path + '"')
	
	# print(particles)

func cache_materials():
	for material in particles:
		var particles_instance = GPUParticles2D.new()
		particles_instance.process_material = material
		particles_instance.one_shot = true
		particles_instance.modulate = Color(1, 1, 1, 0)
		particles_instance.emitting = true
		add_child(particles_instance)
