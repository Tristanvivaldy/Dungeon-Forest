extends Node

var inv_data = {}

var equipment_data = {
	"Hand" : 10001
}

func _ready():
	var inv_data_file = File.new()
	inv_data_file.open("user://inv_data_file.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	inv_data = inv_data_json.result
	
