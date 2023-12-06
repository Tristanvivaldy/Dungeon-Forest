extends KinematicBody2D

var damage
var state_machine
export(float) var speed = 160.0
var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var ROLL_SPEED = 3
var swordHitbox
var stats = PlayerStats

var enemy_inattack_range = false
var enemy_attack_cooldown = true

const level_anim = preload("res://Effect/level_up_anim.tscn")

onready var backpack = preload("res://GUI/Inventory/Inventory_UI.tscn")

enum {
	MOVE,
	JUMP,
	ATTACK
}

func _ready():
	$levelup.visible = false
	stats.connect("no_health", self, "died")
	state_machine = $AnimationTree.get("parameters/playback")
	swordHitbox = $HitBoxPivot/SwordHitbox
	swordHitbox.knockback_vector = roll_vector

func died():
	var game_over = get_tree().change_scene("res://Floors/game_over.tscn")
	MusicController.stop_music()
	Sound.game_over.play()
	if (game_over != OK):
		print("An unexpected error occured when trying to switch to the Game Over scene")
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		JUMP:
			jump(delta)
			
		ATTACK:
			attack_state(delta)
		
func move_state(_delta):
	velocity = Vector2.ZERO
	enemy_attack()
	if (Input.is_action_pressed("kanan")):
		velocity.x += 1.0
		$AnimationPlayer.play("walk")
		if $walk_timer.time_left <= 0:
			$walking.pitch_scale = rand_range(1.1,5)
			$walking.play(0.17)
			$walk_timer.start(0.3)
	if (Input.is_action_pressed("kiri")):
		velocity.x -= 1.0
		$AnimationPlayer.play("walk")
		if $walk_timer.time_left <= 0:
			$walking.pitch_scale = rand_range(1.1,5)
			$walking.play(0.17)
			$walk_timer.start(0.3)
	if (Input.is_action_pressed("mundur")):
		velocity.y += 1.0
		$AnimationPlayer.play("walk")
		if $walk_timer.time_left <= 0:
			$walking.pitch_scale = rand_range(1.1,5)
			$walking.play(0.17)
			$walk_timer.start(0.3)
	if (Input.is_action_pressed("maju")):
		velocity.y -= 1.0
		$AnimationPlayer.play("walk")
		if $walk_timer.time_left <= 0:
			$walking.pitch_scale = rand_range(1.1,5)
			$walking.play(0.17)
			$walk_timer.start(0.3)
		
	velocity = velocity.normalized()
	
	if (velocity == Vector2.ZERO):
		state_machine.travel("Idle")
	else :
		roll_vector = velocity
		state_machine.travel("Walk")
		swordHitbox.knockback_vector = velocity
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		$AnimationTree.set("parameters/Attack/blend_position", velocity)
		$AnimationTree.set("parameters/Jump/blend_position", velocity)
	
	character_move(velocity)

	if (Input.is_action_just_pressed("att")):
		state = ATTACK
		Sound.kena_hit.play()
	if (Input.is_action_just_pressed("jump")):
		state = JUMP
		Sound.dash.play()
	if (Input.is_action_just_pressed("potion")):
		for i in PlayerData.inv_data:
			var data = PlayerData.inv_data[i]
			if (data["Item"] != null and GameData.item_data[str(data["Item"])]["PotionHealth"] != null):
				PlayerStats.health += GameData.item_data[str(data["Item"])]["PotionHealth"]
				if PlayerStats.health > PlayerStats.max_health:
					PlayerStats.health = PlayerStats.max_health
				data["Stack"] -= 1
				Sound.potion.play()
					
				if (data["Stack"] == 0):
					data["Stack"] = null
					data["Item"] = null
				print(data["Stack"])
				return
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	state_machine.travel("Attack")

func attack_animation_finished():
	state = MOVE

func jump(_delta):
	velocity = roll_vector * ROLL_SPEED * 0.5
	state_machine.travel("Jump")
	character_move(velocity)

func jump_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func character_move(move_velocity):
	velocity = move_and_slide(move_velocity*speed)
	
func enemy_attack():
	if (enemy_inattack_range and enemy_attack_cooldown):
		$AnimationPlayer.play("get_hit")
		stats.health -= damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$Hurtbox.player_hit()
		Sound.enemy_hit.play()

func player():
	pass

func _on_Hurtbox_area_entered(area):
	if area.has_method("enemy"):
		damage = area.damage
		enemy_inattack_range = true

func _on_Hurtbox_area_exited(area):
	if area.has_method("enemy"):
		enemy_inattack_range = false

func _on_attack_cooldown_timeout():
	$AnimationPlayer.stop()
	enemy_attack_cooldown = true
	$attack_cooldown.stop()


func _on_PlayerStats_naik_level():
	$levelup.play("default")
	$levelup.visible = true
	var t = Timer.new()
	t.set_wait_time(1.65)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$levelup.stop()
	$levelup.visible = false
	
	
