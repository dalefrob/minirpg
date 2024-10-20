extends Node
class_name WorldScreen


func _ready() -> void:
	for i in range(1,99):
		print("LVL %s : EXP %s" % [i+1, BattleHelper.get_exp_for_next_level(i)])


func _on_button_pressed() -> void:
	var encounter : Encounter = load("res://data/test_data/test_encounter.tres")
	Globals.start_encounter(encounter)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		Globals.party[0].add_exp(500)
