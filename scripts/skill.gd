extends Resource
class_name Skill

enum Targeting {
	SINGLE_ENEMY,
	ALL_ENEMY,
	SINGLE_ALLY,
	ALL_ALLY,
	ALL
}

enum SkillCategory {
	ELEMENTAL_MAGIC,
	SPIRIT_MAGIC,
	TECHNIQUE,
}

@export var name : String
@export var ingame_description : String
@export var category : SkillCategory
@export var mana_cost : int = 1
@export var targeting : Targeting
@export var function_alias : String
@export var args : Array

@export var args_description : String
