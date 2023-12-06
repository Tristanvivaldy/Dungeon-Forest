extends Area2D

var entered = false 

func _on_Area2D_body_entered(_body: PhysicsBody2D):
	entered = true


func _on_Area2D_body_exited(_body):
	entered = false

func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			Sound.open_door.play(0.51)
			var _floor1 = get_tree().change_scene("res://Floors/Floor 1.tscn")
