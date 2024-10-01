# an action that can be executed such as 'attack' 'use skill' 'use item'
extends RefCounted
class_name Action

var error_msg : String = ""
var user : Battler

signal completed

# virtual functions to be overidden
func _set_target(_target):
	pass

func _can_execute() -> bool:
	if user.is_dead:
		error_msg = "Actor is dead"
		return false
	return true

# Coroutine!
func _execute():
	await user.get_tree().process_frame

func delay(time : float):
	await user.get_tree().create_timer(time).timeout
