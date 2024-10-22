extends Actor
class_name Enemy

@export var texture : Texture2D

@export var bonus_phys_atk : int
@export var bonus_mag_atk : int
@export var bonus_phys_def : int
@export var bonus_mag_def : int

@export var loot_table : String

@export var use_skills_chance : float = 0.25
@export var experience : int
