# use an item on an actor
extends Command
class_name ItemCommand

var item : Item

func _init(_user : Battler, _item : Item) -> void:
	super._init(_user)
	item = _item

func _can_execute() -> bool:
	var consumable = item as Consumable
	if !consumable:
		error_msg = "Not a consumable"
		return false
	return super._can_execute()

func _execute():
	item.use(user.actor, target.actor)
