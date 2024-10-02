# Base class for actor data
extends Resource
class_name Actor

@export var name : String
@export var stats : Stats
@export var skills : Array[Skill]

signal took_damage
signal healed_damage
signal health_depleted

# current values
var hp : int
var mp : int

var is_dead : bool:
	get: return hp <= 0

# set hp and mp to maximum values
func reset():
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

func get_atk():
	return get_stat_total(Stats.StatType.STR) * 2

func get_def():
	return get_stat_total(Stats.StatType.AGI) / 2

func take_damage(dmg):
	hp -= dmg
	took_damage.emit(dmg)
	if hp <= 0:
		hp = 0
		health_depleted.emit()

func heal_damage(dmg):
	hp += dmg
	healed_damage.emit()
	var max_hp = get_max_hp()
	if hp >= max_hp:
		hp = max_hp
