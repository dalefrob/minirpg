extends GridContainer
class_name  BattleMenu

func clear_menu():
	# clear out existing buttons
	for c in get_children():
		c.queue_free()

# Create the actual buttons and connect their pressed signal
func create_buttons(buttons : Array):
	clear_menu()
	
	for b in buttons:
		var btn = Button.new()
		btn.text = b.text
		if b.has("tooltip"):
			btn.tooltip_text = b.tooltip
		btn.pressed.connect(b.callable, CONNECT_ONE_SHOT)
		add_child(btn)


# Loads the top level battle menu
func load_battle_menu(callables):
	var buttons = [
		{ "text": "Attack", "callable" : callables[0] },
		{ "text": "Skill", "callable" : callables[1] },
		{ "text": "Defend", "callable" : callables[2] },
	]
	create_buttons(buttons)

func load_skills_menu(actor : Actor, callback : Callable):
	var buttons = []
	for i in range(actor.skills.size()):
		var skill = actor.skills[i]
		var dict = { "text": skill.name, "tooltip": skill.ingame_description, "callable": callback.bind(skill) }
		buttons.append(dict)
	create_buttons(buttons)

# Loads a menu with targets corresponding to battlers
func load_single_target_menu(battlers : Array, callback : Callable):
	var buttons = []
	for i in range(battlers.size()):
		var battler = battlers[i]
		if battler.actor.is_dead:
			continue
		var dict = { "text": battler.name, "callable": callback.bind(battler) }
		buttons.append(dict)
	create_buttons(buttons)
