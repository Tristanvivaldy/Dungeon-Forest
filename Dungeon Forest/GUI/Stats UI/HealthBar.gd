extends Control

var stats = PlayerStats

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween

func _on_health_updated():
	update_tween.interpolate_property(health_bar, "value", health_bar.value, stats.health, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health

func _physics_process(_delta):
	_on_health_updated()
	_on_max_health_updated(100)
