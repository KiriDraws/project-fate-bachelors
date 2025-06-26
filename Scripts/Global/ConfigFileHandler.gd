extends Node

var config = ConfigFile.new()
const SAVE_FILE_PATH = "user://settings.ini"

func _ready():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		config.set_value("score", "high_score", 0)
		
		config.save(SAVE_FILE_PATH)
	else:
		config.load(SAVE_FILE_PATH)
		
func save_score(key: String, value):
	config.set_value("score", key, value)
	config.save(SAVE_FILE_PATH)
	
func load_score():
	var high_score = {}
	for key in config.get_section_keys("score"):
		high_score[key] = config.get_value("score", key)
	return high_score["high_score"]
	
