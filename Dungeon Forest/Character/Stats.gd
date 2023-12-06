extends Node

signal tambah_exp(growth_data)
signal naik_level(level)

export(int) var max_health = 1
export(int) var max_health_monster = 1
onready var health = max_health setget set_health
onready var health_monster = max_health_monster setget set_health_monster
export(int) var experience = 0
export(int) var level = 1
var gain = false
var experience_total = 0
var experience_required = get_required_experience(int(level)+1)

onready var save_file = SaveFile.g_data

signal no_health

func _ready():
	max_health = save_file.max_health
	health = save_file.health
	experience = save_file.exp
	level = save_file.level
	experience_total = save_file.exp_total

func upgrade_hp(levels):
	save_file.max_health = round(100 + pow(levels, 1.5) + levels * 2)
	return round(100 + pow(levels, 1.5) + levels * 2)

func upgrade_att(levels):
	save_file.damage = round(log((levels + 1) / log(2)) * levels * 0.5) + 1
	return round(log((levels + 1) / log(2)) * levels * 0.5) + 1

func get_required_experience(levels):
	return round(pow(levels, 1.8) + levels * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	save_file.exp_total = experience_total
	var growth_data = []
	while (experience >= experience_required):
		experience -= experience_required
		save_file.exp = experience
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("tambah_exp", growth_data)
	print(save_file)
		
func level_up():
	level += 1
	save_file.level = level
	health = upgrade_hp(level)
	max_health = upgrade_hp(level)
	experience_required = get_required_experience(level + 1)
	emit_signal("naik_level", upgrade_att(level))
	save_file.health = health

func set_health(value):
	health = value
	save_file.health = health
	if (health <= 0):
		health = 0
		emit_signal("no_health")
	
func set_health_monster(value):
	health_monster = value
	if (health_monster <= 0):
		health_monster = 0
		emit_signal("no_health")
	
func save_button():
	SaveFile.save_data()
	print(save_file)
