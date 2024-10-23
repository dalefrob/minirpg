extends Resource
class_name Encounter

@export var is_boss : bool
@export var enemies : Array[Enemy]

func get_rewards() -> Dictionary:
	var gold = 0
	var exp = 0
	var loot = []
	for e in enemies:
		gold += e.gold
		exp += e.experience
		loot.append(e.get_loot())
	return {
		"exp": exp,
		"gold": gold,
		"loot": loot
	}

func _to_string() -> String:
	var result = ""
	for e in enemies:
		result += "[%s] " % e.name
	return result
