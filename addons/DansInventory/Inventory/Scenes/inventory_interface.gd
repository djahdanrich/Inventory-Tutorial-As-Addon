@tool
extends Control
class_name InventoryInterface

const SLOT = preload("res://addons/DansInventory/Inventory/Scenes/slot.tscn")

var grabbed_slot_data : SlotData
var external_inventory_owner
var target : Vector2

@export var world_scene : Node
@export var pick_up_scene : PackedScene
@export var player_scene : Node

@onready var inventory_container: PanelContainer = $InventoryContainer
@onready var hotbar_container: PanelContainer = $HotbarContainer
@onready var inventories_container: HBoxContainer = $InventoryContainer/MarginContainer/VBoxContainer/InventoriesContainer
@onready var player_inventory: InventoryScene = $InventoryContainer/MarginContainer/VBoxContainer/InventoriesContainer/PlayerInventory
@onready var equipment_inventory: InventoryScene = $InventoryContainer/MarginContainer/VBoxContainer/InventoriesContainer/EquipmentInventory
@onready var external_inventory: InventoryScene = $InventoryContainer/MarginContainer/VBoxContainer/InventoriesContainer/ExternalInventory
@onready var grabbed_slot: SlotScene = $GrabbedSlot


func _ready() -> void:
	DansInventory.set_inventory_interface(self)
	DansInventory.drop_slot_data.connect(on_drop_slot)
	inventory_container.hide()
	grabbed_slot.hide()
	external_inventory.hide()


func _physics_process(delta: float) -> void:
	target = get_global_mouse_position() + Vector2(5, 5)
	
	if grabbed_slot.visible:
		grabbed_slot.global_position = target

func set_inventories_in_inventory_container():
	pass

func set_player_inventory_data(inventory_data : InventoryData):
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)
	hotbar_container.set_inventory_data(inventory_data)
	
func set_equipment_inventory_data(inventory_data : InventoryData):
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equipment_inventory.set_inventory_data(inventory_data)

func set_external_inventory(_external_inventory_owner):
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	
	external_inventory.show()

func clear_external_inventory():
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		external_inventory.hide()
		external_inventory_owner = null


func give_slot_focus(external_inventory_owner = null):
	if external_inventory_owner:
		external_inventory.focus_button.pressed.emit()
	else:
		player_inventory.focus_button.pressed.emit()


func on_inventory_interact(inventory_data : InventoryData, index : int, button : int):
	match [grabbed_slot_data, button]:
		[null, 1]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, 1]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, 2]:
			inventory_data.use_slot_data(index)
		[_, 2]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()

func update_grabbed_slot():
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_button_pressed() -> void:
	DansInventory.toggle_inventory.emit()
	
	if grabbed_slot_data:
		_on_drop_slot_button_pressed()


func _on_drop_slot_button_pressed() -> void:
	if grabbed_slot_data:
		DansInventory.drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()

func _on_drop_single_slot_pressed() -> void:
	if grabbed_slot_data:
		DansInventory.drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
		if grabbed_slot_data.quantity < 1:
			grabbed_slot_data = null
			
		update_grabbed_slot()

func on_drop_slot(slot_data : SlotData):
	var new_pick_up = pick_up_scene.instantiate()
	new_pick_up.slot_data = slot_data
	world_scene.add_child(new_pick_up)
