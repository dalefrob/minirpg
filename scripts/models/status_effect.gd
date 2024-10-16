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

func _init() -> void:
	duration = max_duration

func _on_applied():
	pass

func _update():
	pass

func _on_removed():
	pass
