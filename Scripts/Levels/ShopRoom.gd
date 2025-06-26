extends Node2D

@onready var npcs = get_node("../../NPCS")
@onready var shopkeep: PackedScene = preload("res://Scenes/NPCs/Shopkeep.tscn")
@onready var spawnpoint = get_node("SpawnPoints/ShopSpawn")

@export var exit: Marker2D
@export var rarity: int

#Spawn shopkeeper when player enters the room
func _on_player_detection_body_entered(body: Node2D) -> void:

	var new_shop = shopkeep.instantiate()
	new_shop.global_position = spawnpoint.global_position
	new_shop.rarity = rarity
	npcs.add_child.call_deferred(new_shop)

#Teleport player to next room based on marker
func _on_room_exit_body_entered(body: Node2D) -> void:
	body.global_position = exit.global_position
