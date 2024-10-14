extends ItemList
class_name MenuItemList

@onready var cursor_texture : TextureRect = $Cursor

signal canceled

func _ready() -> void:
	item_selected.connect(on_item_selected)

func on_item_selected(idx : int):
	# move the hand icon
	var item_rect = get_item_rect(idx)
	cursor_texture.position = item_rect.end + Vector2(-16, -item_rect.size.y / 2)

func _unhandled_key_input(event: InputEvent) -> void:
	var keyevent = event as InputEventKey
	if keyevent.keycode == KEY_ESCAPE and !keyevent.pressed:
		canceled.emit()
		get_viewport().set_input_as_handled()
