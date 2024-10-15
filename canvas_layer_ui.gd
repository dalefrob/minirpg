extends CanvasLayer
class_name CanvasUI

@onready var msg_panel_pks = preload("res://message_panel.tscn")
@onready var menu_list_pks = preload("res://menu_item_list.tscn")

var menu_stack  = []


func clear_all_menus():
	for menu in menu_stack:
		menu.queue_free()
	menu_stack.clear()


# Creates a message panel and adds it to the UI
func create_msg_panel_node(_position : Vector2, _bbtext : String = "") -> MessagePanel:
	var panel = msg_panel_pks.instantiate() as MessagePanel
	add_child(panel)
	panel.bbtext = _bbtext
	panel.global_position = _position
	return panel


# Creates a menu
func create_menu(menu_items : Array[MenuItem], selected_callback : Callable, cancel_callback : Callable) -> MenuItemList:
	var menu = menu_list_pks.instantiate() as MenuItemList
	menu.size = Vector2(160, 100)
	menu.auto_height = true
	
	for item in menu_items:
		var idx = menu.add_item(item.text, item.icon)
		menu.set_item_tooltip(idx, item.tooltip)
	
	var activated = func on_menu_item_activated(idx : int):
		selected_callback.call(menu_items[idx])
		menu.hide()
	
	menu.item_activated.connect(activated)
	menu.canceled.connect(cancel_callback, CONNECT_ONE_SHOT)
	
	menu_stack.append(menu)
	
	return menu
