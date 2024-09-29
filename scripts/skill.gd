extends Resource
class_name Skill

enum SkillCategory {
	ELEMENTAL_MAGIC,
	SPIRIT_MAGIC,
	TECHNIQUE,
}

@export var name : String
@export var ingame_description : String
@export var category : SkillCategory
@export var mana_cost : int = 1

@export var function_alias : String
@export var args : Array

@export var args_description : String
