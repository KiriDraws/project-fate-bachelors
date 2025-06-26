extends CanvasLayer

func _ready():
	self.hide()

#Displaying end of game message and high score
func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.show()
	get_tree().paused = true

#Resetting the game
func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	Game.reset_character()
