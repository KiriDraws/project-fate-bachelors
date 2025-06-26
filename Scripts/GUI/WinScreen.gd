extends CanvasLayer

var score: int
var high_score: int

func _ready():
	self.hide()

#Displaying end of game message and high score
func win_game():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_score()
	get_node("Panel/Label").text = "You won!\n Current score:\n %s\n High score:\n %s" % [score, high_score]
	self.show()
	get_tree().paused = true

#Resetting the game
func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	Game.reset_character()

func set_score():
	score = 100 * Game.gold + 500 * Game.keys + 200 * Game.player_health + (3000/Game.weapon_equipped.item_rarity)
	high_score = ConfigFileHandler.load_score()
	
	if score > high_score:
		high_score = score
		ConfigFileHandler.save_score("high_score", high_score)
	
