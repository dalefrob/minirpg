# allows selecting a target
extends BattleScreenState
class_name StateTargetSelect

var targeting : Skill.Targeting = Skill.Targeting.SINGLE_ENEMY

var enemy_battlers:
	get: return battle_screen.get_enemy_battlers()
var player_battlers:
	get: return battle_screen.get_character_battlers()

var all : bool = false

# msg parameters
var selected_skill : Skill = null

func enter(_msg := {}) -> void:
	if _msg.has("skill"):
		selected_skill = _msg.skill
		targeting = selected_skill.targeting
	
	var battlers = []
	match targeting:
		Skill.Targeting.SINGLE_ENEMY:
			battlers = enemy_battlers
		Skill.Targeting.ALL_ENEMY:
			battlers = enemy_battlers
			all = true
		Skill.Targeting.SINGLE_ALLY:
			battlers = player_battlers
		Skill.Targeting.ALL_ALLY:
			battlers = player_battlers
			all = true
		Skill.Targeting.ALL:
			battlers = battle_screen.get_all_battlers()
			all = true
	
	var battler_array = battlers as Array[Battler]
	battle_screen.battle_menu.load_target_menu(battler_array, battle_screen.on_target_selected)
