@tool
extends Resource
class_name SlotData

const MAX_STACK_SIZE : int = 99

var max_stack_size : int
@export var item_data : ItemData = null
@export_range(0, MAX_STACK_SIZE) var quantity : int = 1 :
	set(value):
		quantity = set_quantity(value)
	get:
		return quantity

func can_merge_with(other_slot_data : SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable and quantity + quantity < max_stack_size

func can_fully_merge_with(other_slot_data : SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable and quantity + other_slot_data.quantity <= max_stack_size

func fully_merge_with(other_slot_data : SlotData):
	quantity += other_slot_data.quantity


func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data


func set_quantity(value : int) -> int:
	if value > 1 && !item_data.stackable:
		push_warning(item_data.name + " is not stackable, setting quantity to 1.")
		return 1
	
	max_stack_size = item_data.max_stack_size
	return value
