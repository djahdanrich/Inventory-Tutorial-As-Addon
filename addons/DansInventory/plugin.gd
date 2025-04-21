@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("DansInventory", "res://addons/DansInventory/DansInventory.gd")
	
	
func _exit_tree() -> void:
	remove_autoload_singleton("DansInventory")
	InputMap.erase_action("inventory_action_one")
	InputMap.erase_action("inventory_action_two")
