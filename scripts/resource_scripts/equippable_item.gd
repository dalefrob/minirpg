extends Item
class_name EquippableItem

@export var slot : Equipment.Slot

@export var add_strength : int
@export var add_intellect : int
@export var add_agility : int

@export_category("Armors")
@export var add_defense : int
@export var add_resistance : int
@export var resistance_element : Damage.Element

@export_category("Weapons")
@export var add_attack : int
@export var attack_element : Damage.Element

func get_stat_dict() -> Dictionary:
	var result = {
		"str" : add_strength,
		"agi" : add_agility,
		"int" : add_intellect
	}
	return result
