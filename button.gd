extends Button
class_name InventoryButton

@export var inventory_data : InventoryData
@export var inventory_equipment_data : InventoryData

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await DansInventory.interface_set
	
	if is_in_group("player"):
		DansInventory.inventory_interface.set_player_inventory_data(inventory_data)
		DansInventory.inventory_interface.set_equipment_inventory_data(inventory_equipment_data)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory") && is_in_group("player"):
		DansInventory.toggle_inventory.emit()


func _on_pressed() -> void:
	if is_in_group("player"):
		DansInventory.toggle_inventory.emit(null)
	
	if is_in_group("external_inventory"):
		DansInventory.toggle_inventory.emit(self)
		
	
