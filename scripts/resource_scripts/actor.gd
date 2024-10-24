# Base class for actor data
extends Resource
class_name Actor

@export var name : String

@export var level : int = 1
@export var base_strength = 1
@export var base_agility = 1
@export var base_intellect = 1

var hp : int
var mp : int

var defense : int = 0

@export var skills : Array[Skill]
@export var weakness : Damage.Element

@export var status_effects : Array[StatusEffect]
var stat_modifiers : Array[StatModifer]

var defending : bool = false

signal took_damage
signal healed_damage
signal health_depleted


var is_dead : bool:
	get: return hp <= 0

# Called after a new instance
func _initialize():
	full_heal()

func _calculate_stats():
	pass

# set hp and mp to maximum values
func full_heal():
	hp = get_max_hp()
	mp = get_max_mp()

func get_max_hp():
	return get_strength() * 4

func get_max_mp():
	return get_intellect() * 2

func get_strength():
	return base_strength

func get_agility():
	return base_agility

func get_intellect():
	return base_intellect

# Battle Stats

func get_atk():
	return get_strength()

func get_def():
	return defense + (get_agility() / 2.0)

func get_magic_attack_power():
	return get_intellect() / 2.0

func get_magic_defense():
	return get_intellect() / 4.0

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
	took_damage.emit(damage)
	print("%s took %s damage" % [name, damage.amount])
	if hp <= 0:
		die()


func die():
	hp = 0
	health_depleted.emit()


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
