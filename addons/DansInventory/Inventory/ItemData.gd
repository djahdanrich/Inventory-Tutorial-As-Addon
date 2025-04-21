@tool
extends Resource
class_name ItemData

const MAX_STACK_SIZE : int = 99

@export_enum("ITEM", "CONSUMABLE", "EQUIP") var item_type : String = "ITEM"
@export var name : String = ""
@export_multiline var description : String = ""
@export var stackable : bool = false
@export_range(0, MAX_STACK_SIZE) var max_stack_size : int
@export var texture : Texture


func use_item(target):
	match item_type:
		"ITEM":
			print("just an item")
			return
		"CONSUMABLE":
			print(target.name + " uses this item.")
			return
