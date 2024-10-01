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

# show a battle animation anywhere in the game
func show_battle_animation(scene : PackedScene, 
		parent : Node2D, position : Vector2 = Vector2.ZERO, callback : Callable = func():):
	
	var battle_anim : BattleAnimation = scene.instantiate()
	battle_anim.position = position
	parent.add_child(battle_anim)
	await battle_anim.finished
	callback.call()
