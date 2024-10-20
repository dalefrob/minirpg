# globals.gd
# Global game logic
extends Node

@onready var world_screen = preload("res://world_screen.tscn")
@onready var battle_screen = preload("res://battle_screen.tscn")

@onready var party : Array[Character] = []

var inventory : Array[Item] = []


func _ready() -> void:
	var potion = preload("res://data/items/potion.tres")
	potion.stock = 2
	inventory.append(potion)
	
	load_test_party()


func load_test_party():
	var char1 = preload("res://data/test_data/test_char.tres")
	var char2 = preload("res://data/test_data/test_char_2.tres")
	party.append(char1)
	#party.append(char2)
	# Test party
	for member in party:
		member._initialize()


func start_encounter(encounter : Encounter):
	get_tree().change_scene_to_packed(battle_screen)
	await get_tree().tree_changed
	var scene = get_tree().current_scene as BattleScreen
	scene.load_encounter(encounter)


func return_to_overworld():
	get_tree().change_scene_to_packed(world_screen)
