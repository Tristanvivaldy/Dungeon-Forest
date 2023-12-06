extends Area2D

onready var global_variable = get_node("/root/GlobalVariable")
func _on_Area2D_body_entered(body:PhysicsBody2D):
	global_variable.entered = true


func _on_Area2D_body_exited(body):
	global_variable.entered = false

func _process(delta):
	if global_variable.entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			global_variable.entered = false
			get_tree().change_scene("res://Floors/Floor 1.tscn")
