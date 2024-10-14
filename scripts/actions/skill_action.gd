# use a skill on an actor
extends Action
class_name SkillAction

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
	# animate
	var fx_path = "res://skill_fx_scenes/%s.tscn" % skill.name.to_lower()
	var scene = load(fx_path)
	
	var first_target = targets[0]
	if targets.size() > 1:
		# play the animation center
		var center_screen = (first_target as Node2D).get_viewport_rect().size / 2
		await BattleHelper.show_battle_animation(scene)
	elif targets.size() == 1:
		await BattleHelper.show_battle_animation(scene, first_target.global_position)
	
	for t in targets:
		skill.use(user.actor, t.actor)
