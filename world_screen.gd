extends Node
class_name WorldScreen


func _on_button_pressed() -> void:
	var encounter : Encounter = load("res://data/test_data/test_encounter.tres")
	Globals.start_encounter(encounter)
