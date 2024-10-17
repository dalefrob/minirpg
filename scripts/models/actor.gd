# Base class for actor data
extends Resource
class_name Actor

@export var name : String
@export var stats : Stats
@export var skills : Array[Skill]
@export var weakness : Damage.Element

@export var status_effects : Array[StatusEffect]

@export var status : int = 0 # Obsolete

signal took_damage
signal healed_damage
signal health_depleted
signal status_changed

# current values
var hp : int
var mp : int
var defending : bool = false

var is_dead : bool:
	get: return hp <= 0

# set hp and mp to maximum values
func full_heal():
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

func take_damage(damage : Damage):
	if damage.heal: # Heal instead?
		heal_damage(damage)
		return
	
	if defending and !damage.nullify_defend:
		damage.critical = false # cannot be crit while defending
		damage.amount *= 0.8
	
	# apply crit
	if damage.critical:
		damage.amount *= 2
		
	hp -= damage.amount
	print("%s took %s damage" % [name, damage.amount])
	took_damage.emit(damage)
	if hp <= 0:
		die()
		health_depleted.emit()


func die():
	hp = 0


func heal_damage(damage : Damage):
	hp += damage.amount
	healed_damage.emit(damage)
	print("%s healed %s damage" % [name, damage.amount])
	var max_hp = get_max_hp()
	if hp >= max_hp:
		hp = max_hp


func update_status_effects():
	defending = false
	var expired = []
	for effect in status_effects:
		effect.actor = self
		effect._update()
		if effect.duration == 0:
			expired.append(effect)
	# Remove all expired
	for e in expired:
		BattleHelper.remove_status_effect(self, e)
