# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

# args: [amount]
func damage_target(_source : Actor, target : Actor, args : Dictionary):
	var amount = args["amount"]
	var element = Damage.Element.NONE
	if args.has("element"):
		element = args["element"]
	
	var damage = Damage.create(amount, element, args.has("heal"))
	# apply weakness to element
	if damage.element != Damage.Element.NONE and target.weakness == damage.element:
		damage.amount *= 2
	
	# critical strike
	if randf() < 0.3:
		damage.critical = true
	
	if damage.heal:
		target.heal_damage(damage)
	else:
		target.take_damage(damage)


func calculate_physical_damage(attacker : Actor, defender : Actor) -> Damage:
	var atk = attacker.get_atk()
	var def = defender.get_def()
	
	var amount = atk - def
	if amount < 0:
		amount = 0
	
	var damage = Damage.create(amount)
	# critical strike
	if randf() < 0.3:
		damage.critical = true
	return damage

# show a battle animation anywhere in the game
func show_battle_animation(scene : PackedScene, global_position = Vector2.ZERO, callback : Callable = func():):
	var battle_anim : BattleAnimation = scene.instantiate()
	battle_anim.global_position = global_position
	battle_anim.z_index = 1
	add_child(battle_anim)
	await battle_anim.finished
	callback.call()

func show_floating_text(parent, text : String, color : Color = Color.WHITE, offset : Vector2 = Vector2.ZERO, crit = false):
	var label = preload("res://floating_text.tscn").instantiate() as FloatingText
	label.position = offset
	if crit:
		label.scale *= 1.5
	parent.add_child(label)
	label.float_up(text, color)


func get_enemy_battlers():
	return get_all_battlers().filter(func(b): return b is EnemyBattler)

func get_character_battlers():
	return get_all_battlers().filter(func(b): return b is CharacterBattler)

func get_all_battlers():
	return get_tree().get_nodes_in_group("battler")
