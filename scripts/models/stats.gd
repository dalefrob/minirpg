extends Resource
class_name Stats

@export var strength : int
@export var intelligence : int
@export var stamina : int
@export var agility : int 

func get_stat(stat_id : StatType):
	var _dict = {
		StatType.STR: strength,
		StatType.INT: intelligence,
		StatType.STA: stamina,
		StatType.AGI: agility
	}
	return _dict[stat_id]

# Global Vars

enum StatType {
	STR,
	INT,
	STA,
	AGI
}

static var stat_string : Dictionary = {
	StatType.STR: "strength",
	StatType.INT: "intellect",
	StatType.STA: "stamina",
	StatType.AGI: "agility"
}
