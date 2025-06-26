extends Control

@onready var equipped = get_node("Panel/TextureRect")

#Equipping item to player
func equip_item(item_name: String, rarity: int = 1) -> void:
	var item = InventoryItem.new()
	item.init(Game.items[item_name])
	equipped.add_child(item)
	Game.equip_weapon(Game.items[item_name], rarity)
