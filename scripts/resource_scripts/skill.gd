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
@export var target_aoe : bool = false
@export var target_ally : bool = false

@export_category("Calling Parameters")
@export var function_alias : String
@export var args : Dictionary

@export_category("Battle Anim Parameters")
@export var battle_anim_alias : String
@export_enum("TARGET", "USER", "CENTER") var positioning = 0
@export var dim_screen : bool = false
