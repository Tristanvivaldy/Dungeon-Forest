extends StaticBody2D

var temp_inv_slot = preload("res://GUI/Inventory/Templates/InventorySlot.tscn")

onready var gridcontainer = get_node("../../../InventoryUi/CanvasLayer/Inventory/Background/M/V/ScrollContainer/GridContainer")

var p_data = PlayerData

var chest_open = false
var counter = 0

func _on_ChestZone_body_entered(_body):
	chest_open = true

func _on_ChestZone_body_exited(_body):
	chest_open = false
	
func _process(_delta):
	if (chest_open == true):
		if(Input.is_action_just_pressed("open") and counter < 1):
			Sound.open_chest.play()
			## Bikin Item
			var new_item = {}
			var last_item = getLastItem()
			new_item['item_id'] = ItemDetermineType()
			var stackable
			if (GameData.item_data[new_item['item_id']]["Stackable"]) == false:
				stackable = null
			else :
				stackable = 1
			var dict = {"Item" : int(new_item['item_id']), "Stack" : stackable}
			$AnimationPlayer.play("open")
			counter += 1
			var inv_slot_new = temp_inv_slot.instance()
			var item_name = GameData.item_data[new_item['item_id']]["Name"]
			var icon_texture = load("res://Assets/JSON/icons/" + item_name + ".png")
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
			gridcontainer.add_child(inv_slot_new, true)
			var inv_data_file = File.new()
			inv_data_file.open("user://inv_data_file.json", File.READ_WRITE)
			PlayerData.inv_data[last_item] = dict
			## Input to JSON
			inv_data_file.seek_end(-2)
			inv_data_file.store_line(",\n")
			inv_data_file.store_line(to_json(last_item))
			inv_data_file.store_line(":")
			inv_data_file.store_line(to_json(dict))
			inv_data_file.store_line("}")
			
func ItemDetermineType():
	var new_item_type
	var item_types = GameData.item_data.keys()
	randomize()
	new_item_type = item_types[randi() % item_types.size()]
	return new_item_type

func getLastItem():
	var new_item_type
	var item_types = PlayerData.inv_data.keys()
	var m = "Inv" + str(item_types.size()+1)
	# new_item_type = item_types[item_types.size()-1]
	return m

