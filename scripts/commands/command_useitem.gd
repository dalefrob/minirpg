# use an item on an actor
extends Command
class_name ItemCommand

var item : Item

func _init(_item : Item) -> void:
	item = _item


func _can_execute() -> bool:
	var consumable = item as Consumable
	if !consumable:
		error_msg = "Not a consumable"
		return false
	else:
		if consumable.stock < 1:
			return false
	return super._can_execute()


func _execute():
	BattleHelper.use_item(item, user.actor, target.actor)
