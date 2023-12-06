extends Node2D

export var mainGameScene : PackedScene

func _on_start_new_game_mouse_entered():
	Sound.click.play()
func _on_options_mouse_entered():
	Sound.click.play()
func _on_about_us_mouse_entered():
	Sound.click.play()
func _on_exit_mouse_entered():
	Sound.click.play()
	
func _ready():
	var music_play = MusicController.play_music()

func _on_start_new_game_pressed():
	var change_scene = get_tree().change_scene(mainGameScene.resource_path)
	if change_scene != OK:
		print ("An unexpected error occured when trying to switch to the HomeBG scene") # Replace with function body.

func _on_options_pressed():
	print(get_tree())
	get_tree().change_scene("res://Main_menu/options/options_scene.tscn")

func _on_exit_button_down():
	get_tree().quit()

func _on_about_us_pressed():
	get_tree().change_scene("res://Main_menu/about_us/About_Us.tscn") 
