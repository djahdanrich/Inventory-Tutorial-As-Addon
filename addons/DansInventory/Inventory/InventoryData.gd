@tool
extends Resource
class_name InventoryData

signal inventory_updated(inventory_data : InventoryData)
signal inventory_interact(inventory_data : InventoryData, index : int, button : int)

@export_enum("ITEM", "EQUIP") var inventory_type : String = "ITEM"
@export var slot_datas : Array[SlotData] = []


func on_slot_clicked(index : int, button : int):
	inventory_interact.emit(self, index, button)

func grab_slot_data(index : int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	if inventory_type != "ITEM":
		return drop_only_typed_item(grabbed_slot_data, index)
	else:
		return drop_any_item_slot(grabbed_slot_data, index)


func drop_single_slot_data(grabbed_slot_data : SlotData, index : int) -> SlotData:
	if inventory_type != "ITEM":
		return drop_only_one_typed_item(grabbed_slot_data, index)
	else:
		return drop_single_any_item_type_slot(grabbed_slot_data, index)

func drop_only_typed_item(grabbed_slot_data, index) -> SlotData:
	if grabbed_slot_data.item_data.item_type == inventory_type:
		var slot_data = slot_datas[index]
		var return_slot_data : SlotData
		
		if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
			slot_data.fully_merge_with(grabbed_slot_data)
		else:
			slot_datas[index] = grabbed_slot_data
			return_slot_data = slot_data
		
		inventory_updated.emit(self)
		return return_slot_data
		
	inventory_updated.emit(self)
	return grabbed_slot_data

func drop_only_one_typed_item(grabbed_slot_data, index) -> SlotData:
	if grabbed_slot_data.item_data.item_type == inventory_type:
		var slot_data = slot_datas[index]

		if not slot_data:
			slot_datas[index] = grabbed_slot_data.create_single_slot_data()
			
		elif slot_data.can_merge_with(grabbed_slot_data):
			slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
			
		inventory_updated.emit(self)

	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null


func drop_any_item_slot(grabbed_slot_data, index) -> SlotData:
	var slot_data = slot_datas[index]
	var return_slot_data : SlotData
	
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	
	
	return return_slot_data


func drop_single_any_item_type_slot(grabbed_slot_data : SlotData, index : int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func pick_up_slot_data(slot_data : SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index]:
			if slot_datas[index].can_fully_merge_with(slot_data):
				slot_datas[index].fully_merge_with(slot_data)
				inventory_updated.emit(self)
				return true
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	
	return false


func use_slot_data(index : int):
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
		
	match slot_data.item_data.item_type:
		"CONSUMABLE":
			slot_data.quantity -= 1
			
			if slot_data.quantity < 1:
				slot_datas[index] = null
				
			slot_data.item_data.use_item(DansInventory.inventory_interface.player_scene)
			
			inventory_updated.emit(self)
