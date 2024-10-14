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
	var control = node as Control
	control.visibility_changed.connect(on_child_visibility_changed)
	vbox.add_child(node)
	show()

func add_menu(menu : MenuItemList):
	add_child_control(menu)

func on_child_visibility_changed():
	visible = vbox.get_children().any(func(c): return c.visible)
