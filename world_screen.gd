extends Node
class_name WorldScreen


func _ready() -> void:
	var arr = []
	for i in range(1,99):
		arr = [i]
		arr.append_array(BattleHelper.get_stats_for_level(i))
		print("LVL %s STR %s INT %s AGI %s STAM %s" % arr)
		print("LVL %s : EXP %s" % [i+1, BattleHelper.get_exp_for_next_level(i)])


func _on_button_pressed() -> void:
	var encounter : Encounter = load("res://data/test_data/test_encounter.tres")
	Globals.start_encounter(encounter)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		Globals.party[0].add_exp(500)
