extends Button
class_name PickUpButton

@export var slot_data : SlotData

func _ready() -> void:
	icon = slot_data.item_data.texture
	text = slot_data.item_data.name + " " + str(slot_data.quantity)

func _on_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player is InventoryButton:
		if player.inventory_data.pick_up_slot_data(slot_data):
			queue_free()
