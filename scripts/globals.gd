# globals.gd
# Global game logic
extends Node

@onready var world_screen = preload("res://world_screen.tscn")
@onready var battle_screen = preload("res://battle_screen.tscn")

@onready var party : Array[Character] = [
	preload("res://data/test_data/test_char.tres"),
	preload("res://data/test_data/test_char_2.tres")
]

var inventory : Array[Item] = [
	preload("res://data/items/antidote.tres")
]

func _ready() -> void:
	var potion = preload("res://data/items/potion.tres")
	potion.stock = 2
	inventory.append(potion)
	

func start_encounter(encounter : Encounter):
	get_tree().change_scene_to_packed(battle_screen)
	await get_tree().tree_changed
	var scene = get_tree().current_scene as BattleScreen

	scene.load_encounter(encounter)
