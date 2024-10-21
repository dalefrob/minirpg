extends Item
class_name Consumable

@export var stack_size : int = 99
@export var stock : int = 1

@export_category("Calling Parameters")
@export var function_alias : String
@export var args : Dictionary

func use(user : Actor, target : Variant):
	stock -= 1
	BattleHelper.call(function_alias, user, target, args)
