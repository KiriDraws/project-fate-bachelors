extends Node2D

@onready var monsters = get_node("../../Monsters")
@onready var player = get_node("../../Player")
@onready var bat: PackedScene = preload("res://Scenes/Enemies/EnemyM.tscn")
@onready var skeleton: PackedScene = preload("res://Scenes/Enemies/EnemyR.tscn")
@onready var goblin: PackedScene = preload("res://Scenes/Enemies/EnemyT.tscn")

@export var exit1: Marker2D
@export var exit2: Marker2D
@onready var door1 = get_node("RoomExit1/CollisionShape2D")
@onready var door2 = get_node("RoomExit2/CollisionShape2D")

#Only enable doors when all enemies are defeated
func _process(delta: float) -> void:

	if monsters.get_child_count() > 0:
		door1.disabled = true
		door2.disabled = true
	else:
		door1.disabled = false
		door2.disabled = false

#Spawn enemies when player enters room		
func _on_player_detection_body_entered(body: Node2D) -> void:
	for i in get_node("SpawnPoints").get_children():
		spawn_monster(i.type, i.multiplier, i.global_position)
		
#Spawn enemies based on spawn point type	 	
func spawn_monster (type: String, multi: int, pos: Vector2):
	match type:
		"bat": 
			var new_enemy = bat.instantiate()
			new_enemy.global_position = pos
			new_enemy.player = player
			new_enemy.DAMAGE = new_enemy.DAMAGE * multi
			new_enemy.HEALTH = new_enemy.HEALTH * multi
			monsters.add_child.call_deferred(new_enemy)
			
		"goblin":
			var new_enemy = goblin.instantiate()
			new_enemy.global_position = pos
			new_enemy.player = player
			new_enemy.DAMAGE = new_enemy.DAMAGE * multi
			new_enemy.HEALTH = new_enemy.HEALTH * multi
			monsters.add_child.call_deferred(new_enemy)
			
		"skeleton":
			var new_enemy = skeleton.instantiate()
			new_enemy.global_position = pos
			new_enemy.player = player
			new_enemy.DAMAGE = new_enemy.DAMAGE * multi
			new_enemy.HEALTH = new_enemy.HEALTH * multi
			monsters.add_child.call_deferred(new_enemy)

			
#Teleport player to next room based on marker
func _on_room_exit_1_body_entered(body: Node2D) -> void:
	body.global_position = exit1.global_position


func _on_room_exit_2_body_entered(body: Node2D) -> void:
	body.global_position = exit2.global_position
