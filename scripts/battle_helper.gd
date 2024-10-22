# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

## Target takes damage
## Use this to do "heal" damage as well
func damage_target(_source : Actor, target : Actor, args : Dictionary):
	var element = Damage.Element.NONE
	var amount = args["amount"]
	var magic = false
	if args.has("element"):
		magic = true
		element = args["element"]
	var damage = Damage.create(amount, element, args.has("heal"))
	if magic:
		damage.add(calculate_magic_damage(element, _source, target))
	# apply weakness to element
	if damage.element != Damage.Element.NONE and target.weakness == damage.element:
		damage.amount *= 1.5
	
	# critical strike
	if randf() < 0.3:
		damage.critical = true
	
	target.take_damage(damage)

func calculate_magic_damage(element : Damage.Element, attacker : Actor, defender : Actor):
	var m_atk = attacker.get_magic_attack_power()
	var m_def = defender.get_magic_defense()
	var amount = m_atk - m_def
	if amount < 0:
		amount = 0
	var damage = Damage.create(amount, element)
	if randf() < 0.1:
		damage.critical = true
	return damage

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
	if scene: # Show animation if there is one
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

func skill_add_status_effect(_source : Actor, target : Actor, args : Dictionary):
	apply_status_effect(target, args.effect)

#region StatusEffects

func get_status_effect(actor : Actor, alias : String):
	var result = null
	for e in actor.status_effects:
		if e.alias == alias:
			result = e
	return result

func apply_status_effect(actor : Actor, new_effect : StatusEffect):
	var existing = get_status_effect(actor, new_effect.alias) as StatusEffect
	if existing:
		# NOTE Removed stacks due to unbalanced gameplay
		# TODO Instead of erase, can we replace the value at index?
		actor.status_effects.erase(existing)
	
	# Add the effect
	new_effect.actor = actor
	actor.status_effects.append(new_effect)
	
	new_effect._on_applied()


func remove_status_effect_by_alias(actor : Actor, alias : String):
	var effect : StatusEffect = get_status_effect(actor, alias)
	remove_status_effect(actor, effect)


func remove_status_effect(actor : Actor, effect : StatusEffect):
	actor.status_effects.erase(effect)
	effect._on_removed()
	


#endregion

# Formulas

func get_exp_for_next_level(current_level : int):
	var base_xp = 6
	var factor = 1.5
	return floori(base_xp * (pow(current_level + 1, factor)))

func get_stats_for_level(level) -> Array:
	return [
		get_base_str_for_level(level),
		get_base_int_for_level(level),
		get_base_agi_for_level(level),
		get_base_stam_for_level(level),
	]

func get_base_str_for_level(level : int):
	return 5 + floori(level * 1)

func get_base_int_for_level(level : int):
	return 5 + floori(level * 0.8)

func get_base_agi_for_level(level : int):
	return 5 + floori(level * 1.2)

func get_base_stam_for_level(level : int):
	return 5 + floori(level * 2)
