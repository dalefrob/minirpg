# Handles creating menus for various decision making
# TODO Menus needs to be seprate nodes to allow for navigating between them
extends Control
class_name MenuManager


var menus = []
var current_menu = null

var menu_callables : Dictionary

func create_menu(menu_items : Array[MenuItem], cancel_callback : Callable):
	var itemlist = ItemList.new()
	itemlist.size = Vector2(160, 100)
	itemlist.auto_height = true
	itemlist.set_position(Vector2(0, 300))
	
	for item in menu_items:
		var idx = itemlist.add_item(item.text, item.icon)
		itemlist.set_item_tooltip(idx, item.tooltip)
		menu_callables[idx] = item.callable
	
	itemlist.item_activated.connect(on_item_activated)
	add_child(itemlist)
	
	itemlist.grab_focus()
	itemlist.select(0)
	
	menus.append(itemlist)


func on_item_activated(idx : int):
	hide_menus()
	var callable : Callable = menu_callables[idx]
	callable.call()


func hide_menus():
	for m in menus:
		m.hide()
