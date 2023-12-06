extends Node2D

var music = load("res://Assets/Sound/sound background.wav")

func _ready():
	pass
	
func play_music():
	$music.stream = music 
	$music.play()

func stop_music():
	$music.stop()
	
func pause_sound_play():
	$pause_music.play()

func pause_sound_stop():
	$pause_music.stop()
