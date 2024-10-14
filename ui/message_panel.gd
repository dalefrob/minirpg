extends PanelContainer
class_name MessagePanel

@onready var vbox : VBoxContainer = $VBoxContainer
@onready var rich_label : RichTextLabel = $VBoxContainer/RichTextLabel

var bbtext : String = "":
	set(value):
		bbtext = value
		if value != "":
			rich_label.text = bbtext
			rich_label.visible = true

func add_child_control(node: Node):
	vbox.add_child(node)

func add_menu(menu : MenuItemList):
	menu.item_activated.connect(func(_idx): queue_free())
	add_child_control(menu)
