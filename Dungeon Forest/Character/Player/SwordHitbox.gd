extends "res://Character/Hitbox and Hurtboxes/Hitbox.gd"

var knockback_vector = Vector2.ZERO
var stats = PlayerStats
var ui = InventoryUi
var base_damage = damage

var rng = RandomNumberGenerator.new()

func random_number(based_damage):
	var random1 = rng.randf_range(0, based_damage/3)
	var random_total = rng.randf_range(based_damage, based_damage+random1)
	return random_total

func _ready():
	stats.connect("naik_level", self, "att_inc")
	ui.connect('ubah2', self, 'ubah_damage')
	if PlayerData.equipment_data['Hand'] != null:
		var equipment = GameData.item_data[str(PlayerData.equipment_data['Hand'])]['Attack']
		var additional = random_number(equipment)
		damage = round(base_damage + additional)

func ubah_damage():
	if PlayerData.equipment_data['Hand'] != null:
		var equipment = GameData.item_data[str(PlayerData.equipment_data['Hand'])]['Attack']
		var additional = random_number(equipment)
		damage = round(base_damage + additional)
	else :
		damage = base_damage
	
func att_inc(damages):
	if PlayerData.equipment_data['Hand'] != null:
		var equipment = GameData.item_data[str(PlayerData.equipment_data['Hand'])]['Attack']
		var additional = random_number(equipment)
		base_damage = damages
		damage = round(base_damage + additional)
	
func player():
	pass
