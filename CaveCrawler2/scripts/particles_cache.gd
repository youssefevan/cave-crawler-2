extends Control

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
	for mat in particles:
		var particles_instance = GPUParticles2D.new()
		particles_instance.process_material = mat
		particles_instance.one_shot = true
		particles_instance.emitting = true
		self.add_child(particles_instance)
		particles_instance.global_position = Vector2(128, 72)
