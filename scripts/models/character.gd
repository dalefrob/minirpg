extends Actor
class_name Character

@export var texture : Texture2D
@export var equipment : Equipment

@export var level : int = 1
var exp_to_next_level : int = 0

signal leveled_up

func _initialize():
	super._initialize()
	exp_to_next_level -= BattleHelper.get_exp_for_next_level(level)

# Get stat by alias to save duplication of code
func get_stat_total(stat_id : int):
	var _total = 0
	# add base value
	_total += stats.get_stat(stat_id)
	# add equipment stats
	_total += equipment.get_equipment_stat_total(stat_id)
	return _total

func get_atk():
	var base = super.get_atk() # + weapon damage
	return base

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
	exp_to_next_level -= BattleHelper.get_exp_for_next_level(level)
