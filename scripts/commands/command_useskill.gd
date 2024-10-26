# use a skill on an actor
extends Command
class_name SkillCommand

var skill : Skill
var targets : Array


func _init(_user : Battler, _skill : Skill) -> void:
	super._init(_user)
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
	for t in targets:
		BattleHelper.use_skill(skill, user.actor, t.actor)
