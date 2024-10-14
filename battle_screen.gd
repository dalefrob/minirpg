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

# easy accessors
func get_enemy_battlers():
	var result = []
	for node in $EnemyBattlers.get_children():
		if node is EnemyBattler:
			result.append(node)
	return result

func get_character_battlers():
	var result = []
	for node in $CharacterBattlers.get_children():
		if node is CharacterBattler:
			result.append(node)
	return result

func get_all_battlers():
	var result = get_enemy_battlers()
	result.append_array(get_character_battlers())
	return result


@onready var bg : Sprite2D = $Background

# UI
@export var character_ui_pks : PackedScene

@onready var battle_text : Label = %BattleText
@onready var character_hbox : HBoxContainer = %CharacterHBoxContainer


func load_encounter(encounter : Encounter):
	print("loading encounter: %s" % encounter)
	
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
func spawn_enemies(enemies : Array[Actor]):
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

# ---- TURN CALLBACKS

func on_turn_started(turn : Turn):
	battle_text.text = "%s's turn started" % turn.battler.actor.name
	
	# Player Turns
	if turn.player_controlled:
		show_main_battle_menu()
	
	# Enemy turns
	else:
		var enemy_battler : EnemyBattler = turn.battler
		# enemy make choice
		var targets = get_character_battlers()
		var target = targets.pick_random()
		var action =  AttackAction.new(enemy_battler)
		action._set_target(target)
		turn_system.current_turn.action = action
		execute_action(action)


func show_main_battle_menu():
	var turn = turn_system.current_turn
	var menu_items : Array[MenuItem] = [
		MenuItem.new("Attack", on_menu_attack_selected, "Attack with your weapon"),
		MenuItem.new("Skills", on_menu_useskill_selected.bind(turn.battler), "Use your skills"),
		MenuItem.new("Item", on_menu_useitem_selected, "Use an item"),
		MenuItem.new("Defend", func(): return false, "Defend for the turn")
	]
	
	var msg_panel = ui.create_msg_panel_node(Vector2(50,400), "What will [color=yellow]%s[/color] do?" % turn.battler.actor.name)
	var menu = ui.create_menu(menu_items, on_menu_selected, func(): return false )
	msg_panel.add_menu(menu)

	menu.grab_focus()
	menu.select(0)


func on_menu_selected(menu_item):
	menu_item.callable.call()


func on_turn_ended(turn : Turn):
	print("%s's turn ended" % turn.battler.actor.name)
	
	if is_all_enemies_defeated():
		turn_system.all_turns_processed.disconnect(on_all_turns_processed)
		turn_system.stop()
		
		battle_state = BattleState.BATTLE_WON
		battle_text.text = "You won!"
		var _center = DisplayServer.window_get_size(0) / 2


func on_all_turns_processed():
	print("All turns processed")
	start_new_round()


# ---- MENU

# on clicking the skill menu
func on_menu_useskill_selected(battler : Battler):
	create_selection_menu(battler.actor.skills, on_skill_selected, show_main_battle_menu)
	#battle_menu.load_skills_menu(battler.actor, on_skill_selected)

# on selecting a skill from the menu
func on_skill_selected(skill : Skill):
	print("Selected %s" % skill.name)
	var action = SkillAction.new(turn_system.current_turn.battler, skill)
	turn_system.current_turn.action = action
	
	var targets = []
	# single targets use single target menu
	if skill.target_ally:
		targets = get_character_battlers()
	else:
		targets = get_enemy_battlers().filter(func(b): return !b.actor.is_dead)
	
	if skill.target_aoe:
		action._set_targets(targets)
		execute_action(action)
	else:
		create_selection_menu(targets, on_target_selected, show_main_battle_menu)


func on_menu_useitem_selected():
	var items = Globals.inventory.filter(filter_valid_consumables)
	create_selection_menu(items, on_item_selected, show_main_battle_menu)


func on_item_selected(_item : Item):
	var item_action = ItemAction.new(turn_system.current_turn.battler, _item)
	turn_system.current_turn.action = item_action
	print("selected %s" % _item.name)
	var targets = get_character_battlers()
	create_selection_menu(targets, on_target_selected, on_menu_useitem_selected)


func filter_valid_consumables(item):
	var consumable = item as Consumable
	if !consumable:
		return false
	if consumable.stock <= 0:
		return false
	return true


func on_menu_attack_selected():
	turn_system.current_turn.action = AttackAction.new(turn_system.current_turn.battler)
	var targets = get_enemy_battlers().filter(func(b): return !b.actor.is_dead)
	
	create_selection_menu(targets, on_target_selected, show_main_battle_menu)


# Creates a menu to select from an array of objects
func create_selection_menu(items, selected_callback : Callable, cancel_callback : Callable):
	var menu_items : Array[MenuItem] = []
	for item in items:
		var menu_item = MenuItem.new(item.name, selected_callback.bind(item))
		menu_items.append(menu_item)
	
	var msg_panel = ui.create_msg_panel_node(Vector2(50,400))
	var menu = ui.create_menu(menu_items, on_menu_selected, cancel_callback)
	msg_panel.add_menu(menu)

	menu.grab_focus()
	menu.select(0)


# Target a 'Battler' on thr screen
func on_target_selected(battler : Battler):
	print("Selected %s " % battler.name)
	var action = turn_system.current_turn.action
	action._set_target(battler)
	
	execute_action(action)


func execute_action(_action : Action):
	if _action._can_execute():
		# run the action - 99% has animations
		await _action._execute()

		turn_system.end_current_turn()
	else:
		battle_text.text = _action.error_msg


func is_all_enemies_defeated():
	return get_enemy_battlers().all(func(b): return b.actor.is_dead)
