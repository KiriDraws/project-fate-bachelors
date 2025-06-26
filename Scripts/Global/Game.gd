extends Node

#Custom player health signal
signal health_changed(damage)

#Loading item resources
var items: Dictionary = {
	"Default Sword": preload("res://Scenes/Items/Default Stats/sword_default.tres"),
	"Bow": preload("res://Scenes/Items/bow.tres"),
	"Coin": preload("res://Scenes/Items/coin.tres"),
	"Full Heart": preload("res://Scenes/Items/full_heart.tres"),
	"Half Heart": preload("res://Scenes/Items/half_heart.tres"),
	"Key": preload("res://Scenes/Items/key.tres"),
	"Pickaxe": preload("res://Scenes/Items/pickaxe.tres"),
	"Sword": preload("res://Scenes/Items/sword.tres")
}

#Initializing player stats values
var gold: int = 10
var keys: int = 0
var player_health: int = 10
var player_health_max: int = 10
var weapon_equipped: ItemData = items["Default Sword"]

var player_damage: int = weapon_equipped.item_damage

var shopping: bool = false

#Healing player up to max
func heal_player(amount: int) -> void:
	self.emit_signal("health_changed", -amount)
	player_health += amount
	if player_health > player_health_max:
		player_health = player_health_max 

#Damaging player	
func damage_player(amount: int) -> void:
	self.emit_signal("health_changed", amount)
	player_health -= amount

#Equiping weapon item and setting damage values
func equip_weapon(weapon: ItemData, rarity: int = 1) -> void:
	weapon_equipped = weapon
	player_damage = weapon.item_damage * rarity

#Resetting player stats to base
func reset_character():
	gold = 10
	keys = 0
	player_health = 10
	player_health_max = 10
	weapon_equipped = items["Default Sword"]

	player_damage = weapon_equipped.item_damage

	shopping = false
