@tool
extends Node
class_name InventoryController

@onready var inventory_interface : InventoryInterface


signal interface_set
signal toggle_inventory(external_inventory_owner)
signal drop_slot_data(slot_data : SlotData)

func _ready() -> void:
	toggle_inventory.connect(toggle_inventory_interface)
	
	if !InputMap.has_action("inventory_action_one"):
		InputMap.add_action("inventory_action_one")
		var action_one_event = InputEventMouseButton.new()
		action_one_event.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("inventory_action_one", action_one_event)
	
	
	if !InputMap.has_action("inventory_action_two"):
		InputMap.add_action("inventory_action_two")
		var action_two_event = InputEventMouseButton.new()
		action_two_event.button_index = MOUSE_BUTTON_RIGHT
		InputMap.action_add_event("inventory_action_one", action_two_event)


func set_inventory_interface(new_interface : InventoryInterface):
	inventory_interface = new_interface
	interface_set.emit()

func toggle_inventory_interface(external_inventory_owner = null):
	inventory_interface.inventory_container.visible = not inventory_interface.inventory_container.visible
	inventory_interface.hotbar_container.visible = not inventory_interface.hotbar_container.visible
	
	
	if external_inventory_owner && inventory_interface.inventory_container.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
		
	await get_tree().process_frame
	inventory_interface.give_slot_focus(external_inventory_owner)
