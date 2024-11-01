# globals.gd
# Global game logic
extends Node

var DEBUG = true

@onready var world_screen = preload("res://world_screen.tscn")
@onready var battle_screen = preload("res://battle_screen.tscn")

@onready var party : Array[Character] = []

var inventory : Array[Item] = []


func _ready() -> void:
	var potion = preload("res://data/items/potion.tres")
	potion.stock = 2
	inventory.append(potion)
	inventory.append(preload("res://data/items/eyedrops.tres"))
	
	load_test_party()


func load_test_party():
	var char1 = preload("res://data/actors/test_char.tres")
	var char2 = preload("res://data/actors/test_char_2.tres")
	party.append(char1)
	party.append(char2)
	# Test party
	for member in party:
		member._initialize()
