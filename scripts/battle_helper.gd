# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

func do_attack(attacker : Actor, defender : Actor):
	var dmg = attacker.get_damage()
	dmg -= defender.get_defence()
	# negative dmg will 'heal'
	if dmg < 0:
		dmg = 0
		
	defender.take_hit(dmg)
