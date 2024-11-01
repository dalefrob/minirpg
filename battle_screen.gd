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
var character_battler_pks = preload("res://character_battler.tscn")

# Systems
@onready var turn_system : TurnSystem = $TurnSystem
@onready var ui : CanvasUI = $UI

@onready var battlemenupanel = %BattleMenuMessagePanel
@onready var battleresultspanel = %BattleResultsPanelContainer

var current_turn : Turn:
	get: return turn_system.current_turn
	
func get_enemy_battlers():
	return get_all_battlers().filter(func(b): return b is EnemyBattler)

func get_character_battlers():
	return get_all_battlers().filter(func(b): return b is CharacterBattler)

func get_all_battlers():
	return get_tree().get_nodes_in_group("battler")


@onready var bg : Sprite2D = $Background

# UI
@export var character_ui_pks : PackedScene

@onready var battle_text : Label = %BattleText
@onready var character_hbox : HBoxContainer = %CharacterHBoxContainer

var encounter : Encounter

signal battle_ended

func load_encounter(new_encounter : Encounter):
	print("loading encounter: %s" % new_encounter)
	encounter = new_encounter
	
	spawn_enemies(encounter.enemies)
	spawn_party()
	
	# Setup turn system
	turn_system.turn_started.connect(on_turn_started)
	turn_system.turn_ended.connect(on_turn_ended)
	turn_system.all_turns_processed.connect(on_all_turns_processed)
	
	start_new_round()


# Spawns the party on the screen
func spawn_party():
	var character_battler_grp = $CharacterBattlers
	
	# For now, the player battlers are the portraits at hte bottom
	for character in Globals.party:
		var character_battler = character_battler_pks.instantiate() as CharacterBattler
		character_battler._initialize(character)
		character_battler_grp.add_child(character_battler)
		var character_ui = character_ui_pks.instantiate() as CharacterUI
		
		# more elegant way to do this??
		character_ui.character = character_battler.actor
		character_battler.character_ui = character_ui
		character_hbox.add_child(character_ui)


# Spawns new enemies and aligns them on the screen
func spawn_enemies(enemies : Array[Enemy]):
	var enemy_battler_grp = $EnemyBattlers
	# load enemies
	for enemy in enemies:
		var new_battler = battler_pks.instantiate() as EnemyBattler
		new_battler._initialize(enemy.duplicate(true)) # ensure each enemy is a unique instance
		enemy_battler_grp.add_child(new_battler)
	
	# align battlers
	var window_width = DisplayServer.window_get_size(0).x
	var step = window_width / (enemy_battler_grp.get_child_count() + 1)
	for i in range(enemy_battler_grp.get_child_count()):
		enemy_battler_grp.get_child(i).position.x = (-window_width / 2) + ((i + 1) * step)


func start_new_round():
	print("Starting new round.")

	for battler in get_all_battlers():
		turn_system.enqueue(battler)
		battler.visible = !battler.actor.is_dead
	
	battle_state = BattleState.BATTLING

#region TurnCallbacks
# ---- TURN CALLBACKS

func on_turn_started(turn : Turn):
	battle_text.text = "%s's turn started" % turn.battler.actor.name
	
	# Player Turns
	if turn.player_controlled:
		show_main_battle_menu()
	
	# Enemy turns
	else:
		var enemy_battler : EnemyBattler = turn.battler
		await enemy_battler.attack_cue_visual()
		
		var enemy = enemy_battler.enemy
		
		# enemy make choice
		var targets = get_character_battlers().filter(func(b): return !b.actor.is_dead)
		
		# TODO - Send in battle state to help the ai make better decisions
		var battle_state = {
			"enemy_battlers": "",
			"character_battlers": "",
			"time_elapsed": "",
		}
		var command = enemy.get_command()
		
		var skill_command = command as SkillCommand
		if skill_command:
			if skill_command.skill.target_ally:
				targets = get_enemy_battlers().filter(func(b): return !b.actor.is_dead)
		
		var target = targets.pick_random()
		
		command.user = enemy_battler
		command._set_target(target)
		turn_system.current_turn.command = command
		execute_command(command)


func on_turn_ended(turn : Turn):
	turn.actor.update_status_effects()
	print("%s's turn ended" % turn.battler.actor.name)
	
	if is_all_enemies_defeated():
		turn_system.all_turns_processed.disconnect(on_all_turns_processed)
		turn_system.stop()
		
		win_battle()


func win_battle():
	battle_state = BattleState.BATTLE_WON
	battle_text.text = "You won!"
	var _center = DisplayServer.window_get_size(0) / 2
	
	# prepare panel data
	var rewards = encounter.get_rewards()
	battleresultspanel.show_battle_results(rewards)
	
	reward_experience(rewards.exp)
	
	await battleresultspanel.closed
	
	# Go back to the overworld
	battle_ended.emit()


func reward_experience(experience : int):
	# Divide the experience between the characters who are still alive
	var alive_characters = get_character_battlers().filter(func(b): return !b.actor.is_dead )
	for cb in alive_characters:
		(cb.actor as Character).add_exp(experience / alive_characters.size())


func on_all_turns_processed():
	print("All turns processed")
	start_new_round()


func is_all_enemies_defeated():
	return get_enemy_battlers().all(func(b): return b.actor.is_dead)

#endregion

#region BattleMenu

# ---- MENU
var menu_stack = []


# Shows the main battle menu with the topmost options
func show_main_battle_menu():
	ui.clear_all_menus()
	
	var menu_items : Array[MenuItem] = [
		MenuItem.new("Attack", on_menu_attack_selected, "Attack with your weapon"),
		MenuItem.new("Skills", on_menu_useskill_selected.bind(current_turn.battler), "Use your skills"),
		MenuItem.new("Item", on_menu_useitem_selected, "Use an item"),
		MenuItem.new("Defend", on_menu_defend_selected, "Defend for the turn")
	]
	
	#var msg_panel = ui.create_msg_panel_node(Vector2(50,400), "What will [color=yellow]%s[/color] do?" % current_turn.battler.actor.name)
	var current_char = current_turn.battler.actor as Character
	var hex_color = current_char.unique_color.to_html(false)
	var menu = ui.create_menu(menu_items, on_menu_selected, func(): return false )
	battlemenupanel.add_menu(menu, "What will [color=%s]%s[/color] do?" % [hex_color, current_char.name])

	menu.grab_focus()
	menu.select(0)


# When the player presses escape to go back
func on_cancel_selected():
	print("Cancel")
	# Take off the last menu
	var last_menu = ui.menu_stack.pop_back()
	last_menu.queue_free()
	await get_tree().process_frame
	# Show the previous one
	var prev_menu = ui.menu_stack.back()
	prev_menu.show()
	prev_menu.grab_focus()


func on_menu_selected(menu_item):
	menu_item.callable.call()


func on_menu_defend_selected():
	var defend_command = DefendCommand.new()
	defend_command.user = current_turn.battler
	current_turn.command = defend_command
	
	execute_command(current_turn.command)


# on clicking the skill menu
func on_menu_useskill_selected(battler : Battler):
	create_selection_menu(battler.actor.skills, on_skill_selected, on_cancel_selected, "Use Skill")


# on selecting a skill from the menu
func on_skill_selected(_skill : Skill):
	print("Selected %s" % _skill.name)
	var skill_command = SkillCommand.new(_skill)
	skill_command.user = current_turn.battler
	
	current_turn.command = skill_command
	
	var targets = []
	# single targets use single target menu
	if _skill.target_ally:
		targets = get_character_battlers()
	else:
		targets = get_enemy_battlers().filter(func(b): return !b.actor.is_dead)
	
	if _skill.target_all:
		skill_command._set_targets(targets)
		execute_command(skill_command)
	else:
		create_selection_menu(targets, on_target_selected, on_cancel_selected, "Select Target")


func on_menu_useitem_selected():
	var items = Globals.inventory.filter(filter_valid_consumables)
	create_selection_menu(items, on_item_selected, on_cancel_selected, "Use Item")


func on_item_selected(_item : Item):
	var item_command = ItemCommand.new(_item)
	item_command.user = current_turn.battler
	
	current_turn.command = item_command
	print("selected %s" % _item.name)
	var targets = get_character_battlers()
	create_selection_menu(targets, on_target_selected, on_cancel_selected, "Select Target")


func filter_valid_consumables(item):
	var consumable = item as Consumable
	if !consumable:
		return false
	if consumable.stock <= 0:
		return false
	return true


func on_menu_attack_selected():
	var attack_command = SkillCommand.new(current_turn.battler.actor.regular_attack_skill)
	attack_command.user = current_turn.battler
	current_turn.command = attack_command
	
	var targets = get_enemy_battlers().filter(func(b): return !b.actor.is_dead)
	
	create_selection_menu(targets, on_target_selected, show_main_battle_menu, "Attack")


# Creates a menu to select from an array of objects
func create_selection_menu(items, selected_callback : Callable, cancel_callback : Callable, title = ""):
	var menu_items : Array[MenuItem] = []
	for item in items:
		var menu_item = MenuItem.new(item.name, selected_callback.bind(item))
		menu_items.append(menu_item)
	
	var menu = ui.create_menu(menu_items, on_menu_selected, cancel_callback)
	battlemenupanel.add_menu(menu, title)

	menu.grab_focus()
	menu.select(0)


# Target a 'Battler' on the screen
func on_target_selected(target : Battler):
	print("Selected %s " % target.name)
	var command = current_turn.command
	command._set_target(target)

	execute_command(command)


func execute_command(_command : Command):
	if _command._can_execute():
		battlemenupanel.hide() # Execute can happen, so hide menu
		await _command._execute() # run the Command - 99% has animations
		await get_tree().create_timer(1.0).timeout # Cooldown after effect to reorient ourselves
		turn_system.end_current_turn()
	else:
		battle_text.text = _command.error_msg

#endregion


func play_battle_animation(scene_name : StringName, params : BattleAnimParams, dim : bool = false):
	var scene_path = "res://battle_anim_scenes/%s.tscn" % scene_name
	if !ResourceLoader.exists(scene_path):
		printerr("No animation: %s" % scene_name)
		await get_tree().process_frame
		return
	
	# create the battle animation
	var new_battle_anim = load(scene_path).instantiate() as BattleAnimation
	new_battle_anim.initialize(params)
	new_battle_anim.global_position = params.get_global_position()
	
	var on_finished_anim = func():
		new_battle_anim.queue_free()
		undim()
	
	if dim:
		new_battle_anim.finished.connect(on_finished_anim, CONNECT_ONE_SHOT)
		await dim()
	
	add_child(new_battle_anim)
	
	await new_battle_anim.finished


func dim():
	var tween = create_tween()
	tween.tween_property(bg, "self_modulate", Color(0.3,0.3,0.3,1), 0.4).from_current()
	tween.tween_interval(0.2)
	tween.play()
	await tween.finished


func undim():
	var tween = create_tween()
	tween.tween_property(bg, "self_modulate", Color.WHITE, 0.4).from_current()
	tween.play()
	await tween.finished


func get_center_screen() -> Vector2:
	return DisplayServer.window_get_size(0) / 2
