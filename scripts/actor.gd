# Base class for actor data
extends Resource
class_name Actor

@export var name : String
@export var stats : Stats
@export var skills : Array[Skill]

func get_max_hp():
	return get_stat_total(Stats.StatType.STA) * 10

func get_max_mp():
	return get_stat_total(Stats.StatType.INT) * 5

# Get stat by alias to save duplication of code
func get_stat_total(stat_id : int):
	var _total = 0
	_total += stats.get_stat(stat_id)
	return _total

func get_damage():
	return get_stat_total(Stats.StatType.STR) * 2

func get_defence():
	return get_stat_total(Stats.StatType.AGI) / 2
