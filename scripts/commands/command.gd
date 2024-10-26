# an Command that can be executed such as 'attack' 'use skill' 'use item'
extends RefCounted
class_name Command

var error_msg : String = ""
var user : Battler
var target : Battler # may or may not be used

func _init(_user : Battler) -> void:
	user = _user

# virtual functions to be overidden
func _set_target(_target):
	target = _target

func _can_execute() -> bool:
	if user.actor.is_dead:
		error_msg = "Actor is dead"
		return false
	return true

# Coroutine!
func _execute():
	await user.get_tree().process_frame

func delay(time : float):
	await user.get_tree().create_timer(time).timeout
