extends AnimatedSprite

func _ready():
	var _finished = connect("animation_finished", self, "_on_animation_finished")	
	play("Animate")

func _on_animation_finished():
	queue_free()
