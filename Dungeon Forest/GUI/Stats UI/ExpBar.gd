tool
extends ProgressBar

var stats = PlayerStats

func _ready():
	initialize(stats.experience, stats.experience_required)
	stats.connect("tambah_exp", self, "update_exp")

func initialize(current, maximum):
	max_value = maximum
	value = current

func update_exp(growth_data):
	for line in growth_data:
		var target_experience = line[0]
		var max_experience = line[1]
		max_value = max_experience
		yield(animate_value(target_experience), "completed")
		if (abs(max_value) - value < 0.01):
			value = min_value
		
func animate_value(target, tween_duration = 1.0):
	$UpdateTween.interpolate_property(self, "value", value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$UpdateTween.start()
	yield($UpdateTween, "tween_completed")
