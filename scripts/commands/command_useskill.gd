# use a skill on an actor
extends Command
class_name SkillCommand

var skill : Skill
var targets : Array

func _init(_skill : Skill) -> void:
	skill = _skill

# override for aoe skills
func _set_target(_target):
	targets.append(_target)

func _set_targets(_targets):
	targets = _targets

func _can_execute():
	if user.actor.mp < skill.mana_cost:
		error_msg = "Not enough MP!"
		return false
	return super._can_execute()

func _execute():
	print("%s casts %s!" % [user.name, skill.name])
	
	# play the animation
	var params = BattleAnimParams.new()
	params.user = user
	params.target = targets[0]
	params.positioning = skill.positioning
	var battlescreen = user.get_tree().get_first_node_in_group("battle_screen")
	await battlescreen.play_battle_animation(skill.battle_anim_alias, params, skill.dim_screen)
	
	for t in targets:
		BattleHelper.use_skill(skill, user.actor, t.actor)
