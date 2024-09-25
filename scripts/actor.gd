extends Node
class_name Actor

@export var stats : Stats
@export var equipment : Equipment

func _ready() -> void:
	print("STR %s" % get_stat_total(Stats.StatType.STR))

# Get stat by alias to save duplication of code
func get_stat_total(stat_id : int):
	var _total = 0
	# add base value
	_total += stats.get_stat(stat_id)
	_total += equipment.get_equipment_stat_total(stat_id)
	return _total
