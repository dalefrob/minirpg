# attack an actor
extends Command
class_name AttackCommand

func _can_execute():
	return super._can_execute()

func _execute():
	if !target:
		printerr("no target to execute attack Command")
	
	# run animation
	print("%s attacks!" % user.name)
	await delay(0.5)
	
	# calculate damage
	var dmg = BattleHelper.calculate_physical_damage(user.actor, target.actor)
	target.actor.take_damage(dmg)
