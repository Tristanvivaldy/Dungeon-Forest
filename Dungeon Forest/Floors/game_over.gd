extends Control

var stats = PlayerStats

func _on_Menu_pressed():
	stats.health = 100
	stats.experience = 0
	stats.experience_total = 0
	stats.level = 1
	var _menu = get_tree().change_scene("res://Main_menu/MAIN.tscn")
	
func _on_Menu_mouse_entered():
	Sound.hover.play()
