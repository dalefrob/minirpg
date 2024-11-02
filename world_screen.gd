extends Node
class_name WorldScreen

@onready var battle_screen_pks = preload("res://battle_screen.tscn")

@onready var character = $World/CharacterBody3D

func _ready() -> void:
	return
	
	var arr = []
	for i in range(1,99):
		arr = [i]
		arr.append_array(BattleHelper.get_stats_for_level(i))
		print("LVL %s STR %s INT %s AGI %s STAM %s" % arr)
		print("LVL %s : EXP %s" % [i+1, BattleHelper.get_exp_for_next_level(i)])


func _on_button_pressed() -> void:
	var encounter : Encounter = load("res://data/test_data/test_encounter.tres")
	start_encounter(encounter)


func start_encounter(encounter : Encounter):
	character.set_physics_process(false)
	var new_battle_screen = battle_screen_pks.instantiate() as BattleScreen
	
	var resume = func():
		new_battle_screen.queue_free()
		character.set_physics_process(true)
		
	new_battle_screen.battle_ended.connect(resume, CONNECT_ONE_SHOT)
	add_child(new_battle_screen)
	new_battle_screen.load_encounter(encounter)



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for char in Globals.party:
			char.add_exp(500)
