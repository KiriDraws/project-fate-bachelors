extends Panel

var item_info: ItemData
var price: int = 10

#Initializing shop item based on item resource
func _on_button_pressed():
	get_node("../../").current_item = item_info
	get_node("../../").current_price = price
	get_node("../../ItemInfo").show()
	get_node("../../ItemInfo/ItemName").text = item_info.item_name
	get_node("../../ItemInfo/ItemDescription").text = "%s" % [item_info.item_description]
	get_node("../../ItemInfo/ItemPrice").text = "%s Gold" % [price]
	get_node("../../ItemInfo/ItemSprite").texture = item_info.item_texture
