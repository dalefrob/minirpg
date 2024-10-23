extends Actor
class_name Enemy

@export var texture : Texture2D

@export var bonus_phys_atk : int
@export var bonus_mag_atk : int
@export var bonus_phys_def : int
@export var bonus_mag_def : int

@export var use_skills_chance : float = 0.25

@export_category("Rewards")
@export var experience : int
@export var loot_table : Array[Item]
@export var gold : int

# Get an item from the loot table
func get_loot():
	if loot_table.size() > 0:
		return loot_table[0].duplicate()
	return null
