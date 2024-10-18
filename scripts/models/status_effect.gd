## An effect that does something to the affected actor
extends Resource
class_name StatusEffect

@export var alias : String
@export var name : String
@export var max_duration : int = -1
@export var negative_effect : bool = false
@export var persists : bool = false # Persists after death?

# Changing values
var actor : Actor # The actor that is affected
var duration : int

func _on_applied():
	print_rich("[color=orange]%s was applied to %s[/color]" % [alias, actor.name])
	duration = max_duration

func _update():
	if max_duration > 0:
		duration -= 1

func _on_removed():
	print_rich("[color=orange]%s was removed from %s[/color]" % [alias, actor.name])

func _is_equal_to(_other : StatusEffect):
	return self.alias == _other.alias

func _is_more_potent(_other):
	return true
