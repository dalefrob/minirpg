extends GridContainer
class_name  BattleMenu

# Create the actual buttons and connect their pressed signal
func create_buttons(buttons : Array):
	# clear out existing buttons
	for c in get_children():
		c.queue_free()
	
	for b in buttons:
		var btn = Button.new()
		btn.text = b.text
		btn.pressed.connect(b.callable, CONNECT_ONE_SHOT)
		add_child(btn)


# Loads the top level battle menu
func load_battle_menu(callables):
	var buttons = [
		{ "text": "Attack", "callable" : callables[0] },
		{ "text": "Magic", "callable" : callables[1] },
		{ "text": "Defend", "callable" : callables[2] },
	]
	create_buttons(buttons)

# Loads a menu with targets corresponding to enemy battlers
func load_target_menu(battlers : Array[Node], callback : Callable):
	var buttons = []
	for i in range(battlers.size()):
		var battler = battlers[i]
		var dict = { "text": battler.enemy.name, "callable": callback.bind(i) }
		# i should correspond to the batller child index in theory
		buttons.append(dict)
	create_buttons(buttons)
