extends Area2D

var rng: int


func _ready():
	#Generate random number
	rng = randi_range(0, 6)
	
	get_node("Sword").hide()
	get_node("Pickaxe").hide()
	get_node("Bow").hide()
	get_node("HalfHeart").hide()
	get_node("FullHeart").hide()
	get_node("Gold").hide()
	get_node("Key").hide()

	#Spawn random item
	match rng:
		0:
			get_node("HalfHeart").show()
		1:
			get_node("HalfHeart").show()
		2:
			get_node("FullHeart").show()
		3:
			get_node("Gold").show()
		4:
			get_node("Gold").show()
		5:
			get_node("Gold").show()
		6:
			get_node("Key").show()

#Item pickup effect
func _on_body_entered(body):
	if body.is_in_group("player"):
		match rng: 
			0: 
				Game.heal_player(1)
			1: 
				Game.heal_player(1)
			2: 
				Game.heal_player(2)
			3: 
				Game.gold += 1
			4: 
				Game.gold += 1
			5: 
				Game.gold += 1
			6: 
				Game.keys += 1	
	

		self.queue_free()
