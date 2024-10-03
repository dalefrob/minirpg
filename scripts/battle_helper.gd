# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

# args: [amount]
func deal_damage(source : Actor, target : Actor, args : Array):
	print("%s damages %s for %s" % [source.name, target.name, args[0]])
	target.take_damage(args[0])

# args: [amount]
func heal_damage(source : Actor, target : Actor, args : Array):
	print("%s heals %s for %s" % [source.name, target.name, args[0]])
	target.heal_damage(args[0])

func calculate_damage(attacker : Actor, defender : Actor) -> int:
	var dmg = attacker.get_atk()
	dmg -= defender.get_def()
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

func show_floating_text(parent, text : String, color : Color = Color.WHITE, offset : Vector2 = Vector2.ZERO):
	var label = preload("res://floating_text.tscn").instantiate() as FloatingText
	label.position = offset
	parent.add_child(label)
	label.float_up(text, color)
