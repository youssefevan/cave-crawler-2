extends WorldEnvironment

func _ready():
	OptionsHandler.connect("bloom_changed", change_bloom)
	environment.glow_hdr_threshold = -OptionsHandler.bloom_intensity + 1

func change_bloom():
	environment.glow_hdr_threshold = -OptionsHandler.bloom_intensity + 1
