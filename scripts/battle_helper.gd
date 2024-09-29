# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

func calculate_damage(attacker : Actor, defender : Actor) -> int:
	var dmg = attacker.get_damage()
	dmg -= defender.get_defence()
	# negative dmg will 'heal'
	if dmg < 0:
		dmg = 0
		
	return dmg

func dmg_single(user, target, args):
	pass

func heal_single(user, target, args):
	pass
