@tool
extends PanelContainer
class_name InventoryScene

@export var inventory_name : String
@export var inventory_data : InventoryData

@onready var focus_button: Button = $VBoxContainer/FocusButton
@onready var item_grid: GridContainer = $VBoxContainer/MarginContainer/ItemGrid
@onready var inventory_name_label: Label = $VBoxContainer/InventoryName

func _ready() -> void:
	inventory_name_label.text = inventory_name

func set_inventory_data(inventory_data : InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)


func clear_inventory_data(inventory_data : InventoryData):
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data : InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var new_slot = DansInventory.inventory_interface.SLOT.instantiate()
		item_grid.add_child(new_slot)
		
		new_slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data != null:
			new_slot.set_slot_data(slot_data)


func _on_focus_button_pressed() -> void:
	item_grid.get_child(0).grab_focus()
