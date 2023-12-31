extends Control

var temp_inv_slot = preload("res://GUI/Inventory/Templates/InventorySlot.tscn")

onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")

func _ready():
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = temp_inv_slot.instance()
		if PlayerData.inv_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			var icon_texture = load("res://Assets/JSON/icons/" + item_name + ".png")
			inv_slot_new.get_node("Icon").set_texture(icon_texture)
			var item_stack = PlayerData.inv_data[i]["Stack"]
			if item_stack != null and item_stack > 1:
				inv_slot_new.get_node("Stack").set_text(str(item_stack))
		gridcontainer.add_child(inv_slot_new, true)
	
