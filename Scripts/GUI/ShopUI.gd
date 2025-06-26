extends CanvasLayer

var current_item: ItemData
var current_price: int
@export var rarity: int
@onready var shop_item_scene: PackedScene = preload("res://Scenes/GUI/ShopItem.tscn")

func _ready():
	
	self.hide()

#Displaying current player gold and keys
func open_shop():
	get_node("PlayerGold").text = "%s Gold\n %s Keys" % [Game.gold, Game.keys]
	
	#Removing old items if applicable
	var old_items = get_node("ShopItems").get_children()
	if old_items:
		for item in old_items:
			item.free()
	
	#Displaying new items based on rarity
	for i in ["Sword", "Pickaxe", "Bow"]:
		var shop_item_temp = shop_item_scene.instantiate()
		shop_item_temp.price = (10 * rarity) + randi_range(0, 9)
		shop_item_temp.item_info = Game.items[i]
		shop_item_temp.get_node("ItemSprite").texture = Game.items[i].item_texture
		get_node("ShopItems").add_child(shop_item_temp)
	get_node("ItemInfo").hide()
	
#Buying selected item and equipping weapon to the player
func _on_buy_button_pressed():
	if Game.gold >= current_price:
		Game.gold -= current_price
		get_node("../Inventory").equip_item(current_item.item_name, rarity)
		get_node("PlayerGold").text = "%s Gold\n %s Keys" % [Game.gold, Game.keys]

#Selling keys for gold based on rarity
func _on_sell_button_pressed():
	Game.gold += Game.keys * 5 * rarity
	Game.keys = 0
	get_node("PlayerGold").text = "%s Gold\n %s Keys" % [Game.gold, Game.keys]

#Exiting shop
func _on_exit_button_pressed():
	get_tree().paused = false
	Game.shopping = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	self.hide()
