extends CanvasLayer

@onready var hp_bar = get_node("HP_Bar")

#Initializing player health UI
func _ready():
	hp_bar.max_value = Game.player_health_max
	hp_bar.value = Game.player_health
	get_node("Container").visible = false
	var gameNode = get_node(Game.get_path())
	gameNode.health_changed.connect(Callable(self, "_on_node_health_changed"))

#Displaying stats screen and mouse
func _physics_process(_delta):
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = !get_tree().paused
		get_node("Container").visible = get_tree().paused
		display_stats()
		match get_tree().paused:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			false:
				Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
				
#Displaying current player stats
func display_stats () -> void:
	get_node("Container/Stats/Label").text = "
	Health: %s
	
	Damage: %s
	
	Gold: %s
	
	Keys: %s
	" % [Game.player_health, Game.player_damage, Game.gold, Game.keys]

#Updating player health bar
func _on_node_health_changed(damage: int):
	var tween = create_tween()
	tween.tween_property(hp_bar, "value", hp_bar.value - damage, 0.2)
