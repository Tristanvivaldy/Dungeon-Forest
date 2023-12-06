extends CanvasLayer

func _ready():
	set_visible(false)
	
func _input(event):
	if event.is_action_pressed("backpack"):
		for i in PlayerData.inv_data:
			if (PlayerData.inv_data[i]["Stack"] != null and PlayerData.inv_data[i]["Stack"] > 1):
				get_node("Inventory/Background/M/V/ScrollContainer/GridContainer/" + i + "/Stack").set_text(str(PlayerData.inv_data[i]["Stack"]))
			else :	
				if (PlayerData.inv_data[i]["Item"] == null):
					get_node("Inventory/Background/M/V/ScrollContainer/GridContainer/" + i + "/Icon").set_texture(null)
				get_node("Inventory/Background/M/V/ScrollContainer/GridContainer/" + i + "/Stack").set_text("")
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible		

func _on_Button_pressed():
	set_visible(!get_tree().paused)
	get_tree().paused = !get_tree().paused
