extends PanelContainer
class_name HotbarContainer

signal hotbar_use(index : int)

@export var hotbar_size : int = 5

@onready var item_grid: HBoxContainer = $MarginContainer/ItemGrid

func _unhandled_input(event: InputEvent) -> void:
	if not visible or not event.is_pressed() or not event is InputEventKey:
		return
	
	if range(KEY_1, KEY_1 + hotbar_size).has(event.keycode):
		hotbar_use.emit(event.keycode - KEY_1)

func set_inventory_data(inventory_data : InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)
	hotbar_use.connect(inventory_data.use_slot_data)

func populate_item_grid(inventory_data : InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas.slice(0, hotbar_size):
		var new_slot = DansInventory.inventory_interface.SLOT.instantiate()
		item_grid.add_child(new_slot)
		
		if slot_data != null:
			new_slot.set_slot_data(slot_data)
