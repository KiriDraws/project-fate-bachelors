extends Node2D

@onready var monsters = get_node("../../Monsters")
@onready var player = get_node("../../Player")
@onready var boss: PackedScene = preload("res://Scenes/Enemies/Boss.tscn")
@onready var spawnpoint = get_node("SpawnPoints/BossSpawn")

#Spawn boss when player enters the room
func _on_player_detection_body_entered(body: Node2D) -> void:

	var new_boss = boss.instantiate()
	new_boss.global_position = spawnpoint.global_position
	new_boss.player = player
	monsters.add_child.call_deferred(new_boss)
