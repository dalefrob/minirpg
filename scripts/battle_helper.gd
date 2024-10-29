# battle_helper.gd
# battle related functions that can be used anywhere
extends Node

enum Ailments {
	BLINDNESS,
	SILENCE,
	PARALYSIS,
	FROZEN
}

## Run the functions associated with the skill
func use_skill(skill : Skill, user : Actor, target : Actor):
	var rand = randf()
	if user.get_miss_chance() >= rand:
		print_rich("[color=magenta]%s missed![/color]" % user.name)
		return
	
	for key in skill.args.keys():
		if has_method(key):
			call(key, user, target, skill.args[key])


## Functions the same as skills really...
func use_item(item : Item, user : Actor, target : Actor):
	for key in item.args.keys():
		if has_method(key):
			call(key, user, target, item.args[key])


## Target takes damage
func damage_target(user : Actor, target : Actor, _damage : Damage):
	var damage = _damage.duplicate() # Preserve the original damage
	
	if damage.element != Damage.Element.NONE:
		damage.add(calculate_magic_damage(damage.element, user, target))
		if target.weakness == damage.element:
			damage.amount *= 1.5
	else:
		damage.add(calculate_physical_damage(user, target))
	
	# critical strike
	if randf() < 0.3:
		damage.critical = true
	target.take_damage(damage)


## Attacks with the user's weapon
func regular_attack(user : Actor, target : Actor, args):
	var rand = randf()
	if user.get_miss_chance() >= rand:
		print_rich("[color=magenta]%s missed![/color]" % user.name)
		return
	target.take_damage(calculate_physical_damage(user, target))


## Calculate damage based on magix stat values
func calculate_magic_damage(element : Damage.Element, attacker : Actor, defender : Actor):
	var m_atk = attacker.get_magic_attack_power()
	var m_def = defender.get_magic_defense()
	var amount = m_atk - m_def
	if amount < 0:
		amount = 1
	var damage = Damage.create(amount, element)
	if randf() < 0.1:
		damage.critical = true
	return damage


## Calculate damage based on physical stat values
func calculate_physical_damage(attacker : Actor, defender : Actor) -> Damage:
	var atk = attacker.get_atk()
	var def = defender.get_def()
	
	var amount = atk - def
	if amount < 0:
		amount = 1
	
	var damage = Damage.create(amount)
	# critical strike
	if randf() < 0.3:
		damage.critical = true
	return damage

# show a battle animation anywhere in the game
func show_battle_animation(data : Dictionary, scene : PackedScene, global_position = Vector2.ZERO, callback : Callable = func():):
	if scene: # Show animation if there is one
		var battle_anim : BattleAnimation = scene.instantiate()
		battle_anim.user = data.user
		if data.has("target"):
			battle_anim.enemies = [data.target]
		if data.has("targets"):
			battle_anim.enemies = data.targets
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


#region StatusEffects

func get_status_effect(actor : Actor, alias : String):
	var result = null
	for e in actor.status_effects:
		if e.alias == alias:
			result = e
	return result

## Apply a status effect to the target
func apply_status_effect(user : Actor, target : Actor, _new_effect : StatusEffect):
	var new_effect = _new_effect.duplicate() # Preserve the original data
	if !new_effect._can_apply(target):
		print("%s evades the %s" % [target.name, new_effect.name])
		return
	
	var existing = get_status_effect(target, new_effect.alias) as StatusEffect
	if existing:
		# TODO Instead of erase, can we replace the value at index?
		target.status_effects.erase(existing)
	
	# Add the effect
	new_effect.actor = target
	target.status_effects.append(new_effect)
	
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
