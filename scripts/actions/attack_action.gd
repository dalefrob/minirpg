# attack an actor
extends Action
class_name AttackAction

var target : Battler

func _set_target(_target):
	target = _target


func _can_execute():
	return super._can_execute()


func _execute():
	if !target:
		printerr("no target to execute attack action")
	
	# run animation
	await delay(0.5)
	
	# calculate damage
	var dmg = BattleHelper.calculate_damage(user.actor, target.actor)
	target._take_hit(dmg)

static func create(_user : Battler) -> AttackAction:
	var action = AttackAction.new()
	action.user = _user
	return action
