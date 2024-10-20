extends Resource
class_name Job

@export var name : String = "Default Job"

@export var starting_strength : int = 5
@export var starting_agility : int = 5
@export var starting_intellect : int = 5
@export var starting_stamina : int = 5

@export_range(0.5, 1.5, 0.25) var strength_growth_factor : float = 1.0
@export_range(0.5, 1.5, 0.25) var agility_growth_factor : float = 1.0
@export_range(0.5, 1.5, 0.25) var intellect_growth_factor : float = 1.0
@export_range(0.5, 1.5, 0.25) var stamina_growth_factor : float = 1.0
