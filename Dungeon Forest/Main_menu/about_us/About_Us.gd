extends Node2D
var reset_state = false
onready var timer = get_node("Timer")

func _on_back_mouse_entered():
	Sound.click.play()


func _on_back_pressed():
	if reset_state == false:
		reset_state = true
		timer.set_wait_time(1)
		timer.start()
	Sound.hover.play()
	get_tree().change_scene("res://Main_menu/MAIN.tscn")


func _on_Timer_timeout():
	timer.stop()
	reset_state = false
