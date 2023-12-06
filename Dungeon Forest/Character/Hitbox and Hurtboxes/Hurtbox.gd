extends Area2D

export(bool) var show_hit = true
var cooldown = true

const HitEffect = preload("res://Effect/HitEffect.tscn")

func player_hit():
	if (show_hit):
		var effect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position

func centipade_hit():
	if (show_hit):
		var effect = HitEffect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
	
