extends Resource
class_name Encounter

@export_enum("PLAINS", "CAVE") var background : int
@export var enemies : Array[Actor]

func _to_string() -> String:
	var result = ""
	for e in enemies:
		result += "[%s] " % e.name
	return result
