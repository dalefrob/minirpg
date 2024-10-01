# use a skill on an actor
extends Action
class_name SkillAction

var skill : Skill
var targets : Array[Battler]

func _set_target(_target):
	targets.append(_target)

func _set_targets(_targets):
	targets = _targets

func _can_execute():
	if user.mp < skill.mana_cost:
		error_msg = "Not enough MP!"
		return false
	return super._can_execute()

func _execute():
	# animate
	var fx_path = "res://skill_fx_scenes/%s.tscn" % skill.name.to_lower()
	var scene = load(fx_path)
	for t in targets:
		BattleHelper.show_battle_animation(scene, t)
		
	await delay(1)
	
	for t in targets:
		# calculate damage
		var dmg = BattleHelper.calculate_damage(user.actor, t.actor)
		t._take_hit(dmg)


static func create(_user : Battler, _skill : Skill):
	var action = SkillAction.new()
	action.user = _user
	action.skill = _skill
	return action
