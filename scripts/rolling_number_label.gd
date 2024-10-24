## A label that will roll a numerical value up to the real value.
## Used for visual impact of a value changing.
extends Label
class_name RollingNumberLabel

## Add a word before the value such as HP:, or MP:
@export var prefix : String = ""

## The real value
@export var value : int = 0:
	set(_value):
		previous_value = value
		value = _value
		roll()
	get:
		return value

## The value that gets set once a new value comes in
var previous_value : int = 0 

## Called once the label reaches the real value
signal finished

## Sets the value straight away bypassing the roll
func set_value_instantly(new_value : int):
	previous_value = new_value
	value = new_value

## Runs a tween that rolls the previous value to the new value
func roll():
	var tween = create_tween()
	tween.tween_method(update_label, previous_value, value, 0.25)
	tween.tween_callback(finished.emit)
	tween.play()

## Updates the text by joining the predix and number
func update_label(number : int):
	text = prefix + " " + str(number)
