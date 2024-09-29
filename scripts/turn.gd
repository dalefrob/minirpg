extends RefCounted
class_name Turn
# Turn system

var actor : Actor

func _init(_actor) -> void:
	self.actor = _actor

func execute():
	return true


# ------- STATIC
static func create(actor : Actor):
	var turn = Turn.new(actor)
	return turn
