## Used for numbers that visually count up or down to heighten impact
extends Label
class_name RollingNumberLabel

@export var prefix : String = ""

@export var value : int:
	set(_value):
		previous_value = value
		value = _value
		roll()
	get:
		return value

var previous_value : int # the value before the next one came in
var rolling_value : int # the rolling value for animation

signal finished

## Sets the value straight away bypassing the roll
func set_value_instantly(_value):
	previous_value = _value
	value = _value

func roll():
	var tween = create_tween()
	tween.tween_method(update_label, previous_value, value, 0.25)
	tween.tween_callback(finished.emit)
	tween.play()

func update_label(number : int):
	text = prefix + " " + str(number)
	
