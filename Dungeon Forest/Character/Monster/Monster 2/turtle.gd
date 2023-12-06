extends KinematicBody2D

var knockback = Vector2.ZERO 
const DeathEffect = preload("res://Effect/Monster 2/DeathEffect.tscn")
const HitEffect = preload("res://Effect/HitEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var hit = false 
var state = IDLE
var velocity = Vector2.ZERO
export var acc = 120
export var max_speed = 80
export var friction = 140

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetect
onready var hurt = $Hurtbox

var playerstats = PlayerStats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			sprite.play("default")
			seek_player()
		
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			var speed = 150
			if (player != null):
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, speed * delta)
				if((player.global_position.x - self.global_position.x >= -51 and player.global_position.x - self.global_position.x <= 47) and (player.global_position.y - self.global_position.y >= -61 and player.global_position.y - self.global_position.y <= 67)):
					sprite.play("att")
			else :
				state = IDLE
			sprite.flip_h = velocity.x > 0
			
	velocity = move_and_slide(velocity)

func seek_player():
	if (playerDetectionZone.can_see_player()):
		state = CHASE
	
func _on_Hurtbox_area_entered(area):
	if area.has_method("player"):
		var hitEffect = HitEffect.instance()
		get_parent().add_child(hitEffect)
		hitEffect.global_position = global_position
		$Damage.text = str(area.damage)	
		$Damage/label_time.start()
		sprite.play("hurt")
		hurt.centipade_hit()
		print(area.damage)
		stats.health_monster -= area.damage
		knockback = area.knockback_vector * 150
		var t = Timer.new()
		t.set_wait_time(0.25)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		sprite.play("default")
		print(stats.health_monster)

func _on_Stats_no_health():
	playerstats.gain_experience(50)
	queue_free()
	var enemyDeathEffect = DeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func enemy():
	pass
