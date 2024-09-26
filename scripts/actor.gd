# Base class for actor data
extends Resource
class_name Actor

@export var name : String
@export var stats : Stats

# Get stat by alias to save duplication of code
func get_stat_total(stat_id : int):
	var _total = 0
	_total += stats.get_stat(stat_id)
	return _total
