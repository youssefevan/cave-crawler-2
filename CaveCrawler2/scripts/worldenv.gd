extends WorldEnvironment

func _ready():
	if OptionsHandler.bloom_intensity > 0.0:
		environment.glow_enabled = true
		environment.glow_hdr_threshold = OptionsHandler.bloom_intensity
	else:
		environment.glow_enabled = true
