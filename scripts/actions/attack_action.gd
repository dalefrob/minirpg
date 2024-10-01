# attack an actor
extends Action
class_name AttackAction

var target : Battler

func _set_target(_target):
	_target = target

func _execute():
	if !target:
		printerr("no target to execute attack action")
	
	# calculate damage
	var dmg = BattleHelper.calculate_damage(user.actor, target.actor)
	# run animation
	
	# do hit
	target._take_hit(dmg)

static func create(_user : Battler) -> AttackAction:
	var action = AttackAction.new()
	action.user = _user
	return action
