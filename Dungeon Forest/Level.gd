extends Label

var stats = PlayerStats
var level = stats.level

func level_validation():
	text = str("Level Karakter :", level)
	
func _physics_process(_delta):
	level = stats.level
	level_validation()
