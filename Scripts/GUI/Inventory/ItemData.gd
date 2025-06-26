class_name ItemData
extends Resource

#Creating item resource with individual stats
enum Type {WEAPON, COIN, KEY, HEALTH, MAIN}
@export var item_type: Type
@export var item_name: String
@export var item_damage: int
@export var item_health: int
@export var item_rarity: int
@export_multiline var item_description: String
@export var item_texture: Texture2D
