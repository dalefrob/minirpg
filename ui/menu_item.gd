extends RefCounted
class_name MenuItem

# required
var text : String
var callable : Callable
# optional
var tooltip : String
var icon : Texture2D

func _init(_text : String, _callable : Callable, _tooltip = "", _icon = null) -> void:
	text = _text
	callable = _callable
	
	if _tooltip == "":
		_tooltip = _text
	tooltip = _tooltip
	
	icon = _icon
