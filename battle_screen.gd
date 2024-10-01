extends Node
class_name BattleScreen

const PREBATTLE = "prebattle"
const BATTLE = "battle"
const POSTBATTLE_WIN = "postbattlewin"
const POSTBATTLE_LOSE = "postbattlelose"

var battler_pks = preload("res://enemy_battler.tscn")
var damage_label_pks = preload("res://damage_label.tscn")

# Systems
@onready var state_machine : StateMachine = $StateMachine
@onready var turn_system : TurnSystem = $TurnSystem

# ---
@onready var enemy_battlers = $EnemyBattlers
@onready var player_battlers = $PlayerBattlers

# easy accessors
func get_enemy_battlers():
	var result : Array[Battler] = []
	for c in enemy_battlers.get_children():
		var b = c as Battler
		if b:
			result.append(b)
	return result

func get_player_battlers():
	var result : Array[Battler] = []
	for c in player_battlers.get_children():
		var b = c as Battler
		if b:
			result.append(b)
	return result

func get_all_battlers():
	var result : Array[Battler] = get_player_battlers()
	result.append_array(get_enemy_battlers())
	return result


@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background

# UI
@onready var battle_text : Label = %BattleText
@onready var battle_menu : BattleMenu = %BattleMenu

var _last_skill_selected : Skill


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
	else:
		var enemy : Enemy = turn.battler.enemy
		print(enemy.skills)

# on clicking the skill menu
func on_menu_skill_selected(skill_user : Battler):
	battle_menu.load_skills_menu(skill_user, on_skill_selected)

# on selecting a skill from the menu
func on_skill_selected(skill : Skill):
	print("Selected %s" % skill.name)
	turn_system.current_turn.action = SkillAction.create(turn_system.current_turn.battler, skill)
	
	var targets = get_skill_targets(skill)
	battle_menu.load_target_menu(targets, on_target_selected)


func get_skill_targets(_skill : Skill):
	match _skill.targeting:
		Skill.Targeting.SINGLE_ENEMY:
			return get_enemy_battlers()
		Skill.Targeting.SINGLE_ALLY:
			return get_player_battlers()
		_:
			return get_all_battlers()


# on pressing the attack button from the menu
func on_menu_attack_selected():
	turn_system.current_turn.action = AttackAction.create(turn_system.current_turn.battler)
	var targets = get_enemy_battlers()
	battle_menu.load_target_menu(targets, on_target_selected)


func on_target_selected(target_index : int):
	var target = enemy_battlers.get_child(target_index)
	print("Selected %s " % target.name)
	var action = turn_system.current_turn.action
	action._set_target(target)
	
	action._execute() # cross your fingers and execute!
	
	battle_menu.clear_menu()


# TODO - EXECUTE BATTLEACTION, not just SKILL
func execute_skill(skill : Skill, user : Battler, target : Battler):
	if skill.name == "Attack":
		pass
	else:
		
		# TODO - calculate magic damage
		# TODO - Make this dynamic so that any skill effect can be executed
		var dmg = BattleHelper.calculate_damage(user.actor, target.actor)
		var targets = []
		var anim_pos : Vector2
		
		match skill.targeting:
			Skill.Targeting.ALL_ENEMY:
				targets = get_enemy_battlers()
			Skill.Targeting.SINGLE_ENEMY:
				targets.append(target)
				anim_pos = target.position
		
		# animate
		var fx_path = "res://skill_fx_scenes/%s.tscn" % skill.name.to_lower()
		if ResourceLoader.exists(fx_path):
			var battle_anim : BattleAnimation = load(fx_path).instantiate()
			battle_anim.position = anim_pos
			add_child(battle_anim)
			await battle_anim.finished
		
		# hit all targets
		for t in targets:
			t._take_hit(dmg)
	
	# end turn
	turn_system.end_current_turn()

func is_all_enemies_defeated():
	var all_dead = enemy_battlers.get_children().all(func(e): return e.is_dead)
	return all_dead

func on_battler_disintegrated():
	if is_all_enemies_defeated():
		print("You won!")
