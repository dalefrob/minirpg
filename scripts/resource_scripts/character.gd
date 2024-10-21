extends Actor
class_name Character

@export var job : Job

@export var texture : Texture2D
@export var equipment : Equipment

var exp_to_next_level : int = 0

signal leveled_up

func _initialize():
	super._initialize()
	_calculate_stats()
	exp_to_next_level -= BattleHelper.get_exp_for_next_level(level)

func get_strength():
	return base_strength + equipment.get_equipment_stat_total("str")

func get_agility():
	return base_agility + equipment.get_equipment_stat_total("agi")

func get_intellect():
	return base_intellect + equipment.get_equipment_stat_total("int")

func get_atk():
	var total = super.get_atk() # + weapon damage
	var weapon = equipment.get_slots()[Equipment.Slot.WEAPON] as EquippableItem
	if weapon:
		total += weapon.add_attack
		
	return total

func add_exp(amount : int):
	print("%s gained %s exp" % [name, amount])
	while(amount > 0):
		# the amount is more than what is needed to level up?
		var abs_exp_to_lvl = abs(exp_to_next_level)
		if amount >= abs_exp_to_lvl:
			# add the exact amount and subtract it from the incoming amount
			amount -= abs_exp_to_lvl
			level_up()
		# just add the amount
		else:
			exp_to_next_level += amount
			amount = 0

func level_up():
	level += 1
	print("%s reached level %s" % [name, level])
	leveled_up.emit()
	_calculate_stats()
	full_heal()
	exp_to_next_level -= BattleHelper.get_exp_for_next_level(level)

func _calculate_stats():
	base_strength = job.get_base_strength_for_level(level)
	base_agility = job.get_base_agility_for_level(level)
	base_intellect = job.get_base_intellect_for_level(level)
