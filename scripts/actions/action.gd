# an action that can be executed such as 'attack' 'use skill' 'use item'
extends RefCounted
class_name Action

var user : Battler

# virtual functions to be overidden
func _set_target(_target):
	pass

func _can_execute() -> bool:
	return true

func _execute():
	pass
