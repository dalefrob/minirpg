extends Resource
class_name Job

@export var name : String = "Default Job"

@export var starting_strength : int = 5
@export var starting_agility : int = 5
@export var starting_intellect : int = 5

@export_range(0.5, 1.5, 0.25) var strength_growth_factor : float = 1.0
@export_range(0.5, 1.5, 0.25) var agility_growth_factor : float = 1.0
@export_range(0.5, 1.5, 0.25) var intellect_growth_factor : float = 1.0

func get_base_strength_for_level(level : int):
	return starting_strength + floori(level * strength_growth_factor)

func get_base_agility_for_level(level : int):
	return starting_agility + floori(level * agility_growth_factor)

func get_base_intellect_for_level(level : int):
	return starting_intellect + floori(level * intellect_growth_factor)
