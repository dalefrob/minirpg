# attack an actor
extends Action
class_name AttackAction

func _can_execute():
	return super._can_execute()

func _execute():
	if !target:
		printerr("no target to execute attack action")
	
	# run animation
	await delay(0.5)
	
	# calculate damage
	var dmg = BattleHelper.calculate_physical_damage(user.actor, target.actor)
	target.actor.take_damage(dmg)
