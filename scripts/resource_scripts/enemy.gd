extends Actor
class_name Enemy

@export var texture : Texture2D

@export var ai : EnemyAI

@export_category("Rewards")
@export var experience : int
@export var loot_table : Array[Item]
@export var gold : int


# Get an item from the loot table
func get_loot():
	if loot_table.size() > 0:
		return loot_table[0].duplicate()
	return null

# TODO -- Figure out a way to give enemies unique AI but keep this data sctructure
# We dont want a class for every enemy
# AI Resource???
func get_command():
	if ai:
		return ai.get_command()
	return AttackCommand.new()
