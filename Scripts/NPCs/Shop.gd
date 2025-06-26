extends Area2D

@export var rarity: int

#Displaying shop on player interaction
func _on_body_entered(body):
	if body.is_in_group("player"):
		Game.shopping = true
		get_tree().paused = true
		get_node("../../Player/GUI/Shop").rarity = rarity
		get_node("../../Player/GUI/Shop").open_shop()
		get_node("../../Player/GUI/Shop").show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
