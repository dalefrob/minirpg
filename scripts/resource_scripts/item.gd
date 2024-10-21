extends Resource
class_name Item

@export var name : String
@export var description : String
@export var value : int = 1

func get_sell_price():
	return roundi(value / 2)
