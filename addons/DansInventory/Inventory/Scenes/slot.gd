@tool
extends PanelContainer
class_name SlotScene

signal slot_clicked(index : int, button : int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@onready var focus_border: Panel = $FocusBorder


func set_slot_data(slot_data : SlotData):
	var item_data = slot_data.item_data
	
	texture_rect.texture = item_data.texture
	tooltip_text = str(item_data.name + " \n " + item_data.description)
	
	if slot_data.quantity > 1:
		quantity_label.show()
		quantity_label.text = "x" + str(slot_data.quantity)
	else:
		quantity_label.hide()

func _on_gui_input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == self:
		if event.is_action_pressed("inventory_action_one"):
			slot_clicked.emit(get_index(), 1)
			
		if event.is_action_pressed("inventory_action_two"):
			slot_clicked.emit(get_index(), 2)


func _on_mouse_entered() -> void:
	grab_focus()


func _on_focus_entered() -> void:
	focus_border.show()


func _on_focus_exited() -> void:
	focus_border.hide()
