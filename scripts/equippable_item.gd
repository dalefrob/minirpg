extends Resource
class_name EquippableItem

@export var name : String
@export var description : String
@export var slot : Equipment.Slot
@export var stats : Stats = Stats.new()
@export var value : int = 1

func get_sell_price():
	return roundi(value / 2)
