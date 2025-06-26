class_name InventoryItem
extends TextureRect

@export var data: ItemData
@onready var slot = get_parent()

#Displaying current weapon texture and tooltip on hover
func _ready():
	if data:
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.texture = data.item_texture
		slot.tooltip_text = "Name: %s \n%s \nDamage: %s" % [data.item_name, data.item_description, data.item_damage]

func init(d: ItemData) -> void:
	data = d
	
	
