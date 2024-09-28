# globals.gd
# Global game logic
extends Node

@onready var world_screen = preload("res://world_screen.tscn")
@onready var battle_screen = preload("res://battle_screen.tscn")

func start_encounter(encounter : Encounter):
	get_tree().change_scene_to_packed(battle_screen)
	await get_tree().tree_changed
	var scene = get_tree().current_scene as BattleScreen
	scene.load_encounter(encounter)
