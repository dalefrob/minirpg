extends Node
class_name BattleScreen

enum BattleState {
	PRE_BATTLE,
	BATTLING,
	BATTLE_WON,
	BATTLE_LOST
}

var battle_state : BattleState = BattleState.PRE_BATTLE

var battler_pks = preload("res://enemy_battler.tscn")
var damage_label_pks = preload("res://damage_label.tscn")

# Systems
@onready var state_machine : StateMachine = $StateMachine
@onready var turn_system : TurnSystem = $TurnSystem


# easy accessors
func get_enemy_battlers():
	var result : Array[Battler] = []
	for c in $EnemyBattlers.get_children():
		var b = c as Battler
		if b:
			if not b.is_dead:
				result.append(b)
	return result

func get_character_battlers():
	var result : Array[Battler] = []
	for c in $CharacterBattlers.get_children():
		var b = c as Battler
		if b:
			if not b.is_dead:
				result.append(b)
	return result

func get_all_battlers():
	var result : Array[Battler] = get_character_battlers()
	result.append_array(get_enemy_battlers())
	return result


@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background

# UI
@export var character_ui_pks : PackedScene

@onready var battle_text : Label = %BattleText
@onready var battle_menu : BattleMenu = %BattleMenu
@onready var character_hbox : HBoxContainer = %CharacterHBoxContainer

var _last_skill_selected : Skill


func load_encounter(encounter : Encounter):
	await ready
	print("loading encounter: %s" % encounter)
	
	var enemy_battler_grp = $EnemyBattlers
	
	# load enemies
	for enemy in encounter.enemies:
		var new_battler = battler_pks.instantiate()
		new_battler.actor = enemy
		enemy_battler_grp.add_child(new_battler)
	
	# load players
	for battler in get_character_battlers():
		var character_battler = battler as CharacterBattler
		character_battler._initialize()
		var character_ui = character_ui_pks.instantiate() as CharacterUI
		
		# more elegant way to do this??
		character_ui.character = character_battler.actor
		character_battler.character_ui = character_ui
		
		character_hbox.add_child(character_ui)

	# align battlers
	var window_width = DisplayServer.window_get_size(0).x
	var step = window_width / (enemy_battler_grp.get_child_count() + 1)
	for i in range(enemy_battler_grp.get_child_count()):
		enemy_battler_grp.get_child(i).position.x = (-window_width / 2) + ((i + 1) * step)
	
	# Setup turn system
	turn_system.turn_started.connect(on_turn_started)
	turn_system.turn_ended.connect(on_turn_ended)
	turn_system.all_turns_processed.connect(on_all_turns_processed)
	start_new_round()


func start_new_round():
	print("Starting new round.")
	for battler in get_enemy_battlers():
		if battler.is_dead:
			battler.queue_free()

	# start new round with existing battlers
	for battler in get_all_battlers():
		turn_system.enqueue(battler)
	
	battle_state = BattleState.BATTLING


func on_turn_started(turn : Turn):
	battle_text.text = "%s's turn started" % turn.battler.actor.name
	
	# Player Turns
	if turn.is_player_turn:
		# show battle menu
		var default_callables = [
			on_menu_attack_selected,
			on_menu_skill_selected.bind(turn.battler),
			func(): print("Pressed Defend")
		]
		battle_menu.load_battle_menu(default_callables)
	
	# Enemy turns
	else:
		var enemy_battler : EnemyBattler = turn.battler
		# enemy make choice
		var targets = get_character_battlers()
		var target = targets.pick_random()
		var action =  AttackAction.create(enemy_battler)
		action._set_target(target)
		turn_system.current_turn.action = action
		execute_action(action)

func on_turn_ended(turn : Turn):
	print("%s's turn ended" % turn.battler.actor.name)
	if is_all_enemies_defeated():
		turn_system.all_turns_processed.disconnect(on_all_turns_processed)
		turn_system.clear_queue()
		battle_state = BattleState.BATTLE_WON
		battle_text.text = "You won!"

func on_all_turns_processed():
	print("All turns processed")
	start_new_round()

# on clicking the skill menu
func on_menu_skill_selected(skill_user : Battler):
	battle_menu.load_skills_menu(skill_user, on_skill_selected)

# on selecting a skill from the menu
func on_skill_selected(skill : Skill):
	print("Selected %s" % skill.name)
	turn_system.current_turn.action = SkillAction.create(turn_system.current_turn.battler, skill)
	
	var targets = get_skill_targets(skill)
	battle_menu.load_single_target_menu(targets, on_target_selected)


func get_skill_targets(_skill : Skill):
	match _skill.targeting:
		Skill.Targeting.SINGLE_ENEMY:
			return get_enemy_battlers()
		Skill.Targeting.SINGLE_ALLY:
			return get_character_battlers()
		_:
			return get_all_battlers()


# on pressing the attack button from the menu
func on_menu_attack_selected():
	turn_system.current_turn.action = AttackAction.create(turn_system.current_turn.battler)
	var targets = get_enemy_battlers()
	battle_menu.load_single_target_menu(targets, on_target_selected)


func on_target_selected(target_index : int):
	var target = get_enemy_battlers()[target_index]
	print("Selected %s " % target.name)
	var action = turn_system.current_turn.action
	action._set_target(target)
	
	execute_action(action)


func execute_action(_action : Action):
	if _action._can_execute():
		battle_menu.clear_menu()
		
		# run the action - 99% has animations
		await _action._execute()

		turn_system.end_current_turn()
	else:
		battle_text.text = _action.error_msg


func is_all_enemies_defeated():
	# var all_dead = enemy_battlers.get_children().all(func(e): return e.is_dead)
	return get_enemy_battlers().size() == 0
