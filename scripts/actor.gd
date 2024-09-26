# Base class for actor data
extends Resource
class_name Actor

@export var name : String
@export var stats : Stats

var hp : int
var mp : int

var is_dead : bool

signal took_damage(dmg)
signal hp_depleted

func init_attributes():
	hp = get_max_hp()
	mp = get_max_mp()

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

func take_hit(damage : int):
	hp -= damage
	if hp <= 0:
		hp = 0
		hp_depleted.emit()
		print("%s was defeated" % name)
		is_dead = true
	else:
		took_damage.emit(damage)
		print("%s took %s damage" % [name, damage])
