extends Node
class_name BattleScreen

const PREBATTLE = "prebattle"
const BATTLE = "battle"
const POSTBATTLE_WIN = "postbattlewin"
const POSTBATTLE_LOSE = "postbattlelose"

var battler_pks = preload("res://enemy_battler.tscn")
var damage_label_pks = preload("res://damage_label.tscn")

# ---------
@onready var turn_system = $TurnSystem
@onready var enemy_battlers = $EnemyBattlers
@onready var player_battlers = $PlayerBattlers

@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background

@onready var battle_text : Label = %BattleText
@onready var battle_menu : BattleMenu = %BattleMenu

var _last_skill_selected : Skill

func get_all_battlers() -> Array[Battler]:
	var result : Array[Battler] = []
	result.append_array(player_battlers.get_children())
	result.append_array(enemy_battlers.get_children())
	return result


func load_encounter(encounter : Encounter):
	await ready
	print("loading encounter: %s" % encounter)
	for enemy in encounter.enemies:
		var new_battler = battler_pks.instantiate()
		new_battler.actor = enemy
		new_battler.disintegrated.connect(on_battler_disintegrated)
		enemy_battlers.add_child(new_battler)

	# align battlers
	var window_width = DisplayServer.window_get_size(0).x
	var step = window_width / (enemy_battlers.get_child_count() + 1)
	for i in range(enemy_battlers.get_child_count()):
		enemy_battlers.get_child(i).position.x = (-window_width / 2) + ((i + 1) * step)
	
	# Setup turn system
	turn_system.turn_started.connect(on_turn_started)
	for battler in get_all_battlers():
		turn_system.enqueue(battler)


func on_turn_started(turn : Turn):
	battle_text.text = "%s's turn started" % turn.battler.actor.name
	if turn.player_turn:
		# show battle menu
		var default_callables = [
			on_menu_attack_selected,
			on_menu_skill_selected.bind(turn.battler),
			func(): print("Pressed Defend")
		]
		battle_menu.load_battle_menu(default_callables)

func on_menu_skill_selected(skill_user : Battler):
	battle_menu.load_skills_menu(skill_user, on_skill_selected)

func on_skill_selected(skill : Skill):
	print("Selected %s" % skill.name)
	_last_skill_selected = skill
	battle_menu.load_target_menu(enemy_battlers.get_children(), on_target_selected)

func on_menu_attack_selected():
	_last_skill_selected = preload("res://data/skills/attack.tres")
	battle_menu.load_target_menu(enemy_battlers.get_children(), on_target_selected)

func on_target_selected(target_index : int):
	print("Selected %s " % enemy_battlers.get_child(target_index).name)
	
	#TODO this needs to be dynamic based on using a skill or regular attack
	#NOTE Regular attacks are skills too?
	execute_skill(_last_skill_selected, turn_system.current_turn.battler, enemy_battlers.get_child(target_index))
	#do_attack(player_battlers.get_child(0) ,enemy_battlers.get_child(target_index))
	battle_menu.clear_menu()

func execute_skill(skill : Skill, user : Battler, target : Battler):
	if skill.name == "Attack":
		do_attack(user, target)
	else:
		# animate
		var battle_anim : BattleAnimation = load("res://skill_fx_scenes/%s.tscn" % skill.name.to_lower()).instantiate()
		target.add_child(battle_anim)
		await battle_anim.finished
		# damage
		var dmg = BattleHelper.calculate_damage(user.actor, target.actor)
		target._take_hit(dmg)
		# show damage text
		var dmg_label = damage_label_pks.instantiate() as DamageLabel
		target.add_child(dmg_label)
		dmg_label.float_up(str(dmg))
	
	# end turn
	turn_system.end_current_turn()

# TODO this should be something like 'execute action' and attack is a type of action
# This will allow for skill use, item use and perhaps even fleeing.
func do_attack(attacker : Battler, target : Battler) -> void:
	var current_turn_actor = player_battlers.get_child(0).actor
	
	var dmg = BattleHelper.calculate_damage(attacker.actor, target.actor)
	target._take_hit(dmg)
	
	# show damage text
	var dmg_label = damage_label_pks.instantiate() as DamageLabel
	target.add_child(dmg_label)
	dmg_label.float_up(str(dmg))



func is_all_enemies_defeated():
	var all_dead = enemy_battlers.get_children().all(func(e): return e.is_dead)
	return all_dead

func on_battler_disintegrated():
	if is_all_enemies_defeated():
		print("You won!")
