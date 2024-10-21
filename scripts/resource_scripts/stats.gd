# Numerical values to represent a characters strengths and weaknesses
# NOTE THIS IS PROBABLY OBSOLETE. Most of the reason for this class is in JOB
extends Resource
class_name Stats

@export var job : Job

@export var strength : int
@export var intelligence : int
@export var agility : int 

func get_stat(stat_id : StatType):
	var _dict = {
		StatType.STR: strength,
		StatType.INT: intelligence,
		StatType.AGI: agility
	}
	return _dict[stat_id]

func get_base_str_for_level(level : int):
	return job.starting_strength + floori(level * job.strength_growth_factor)

func get_base_int_for_level(level : int):
	return job.starting_intellect + floori(level * job.intellect_growth_factor)

func get_base_agi_for_level(level : int):
	return job.starting_agility + floori(level * job.agility_growth_factor)

# Global Vars

enum StatType {
	STR,
	INT,
	AGI
}

static var stat_string : Dictionary = {
	StatType.STR: "strength",
	StatType.INT: "intellect",
	StatType.AGI: "agility"
}
