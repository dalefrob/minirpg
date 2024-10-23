extends PanelContainer
class_name BattleResultsPanel

# HEADER
@onready var exp_gained_label = $VBoxContainer/HeaderPanel/EXPGained
@onready var gold_gained_label = $VBoxContainer/HeaderPanel/GoldGained

# CHARACTERS
@onready var character_grid = $VBoxContainer/CharacterGrid
@onready var char_panel_template = $VBoxContainer/CharacterGrid/CharacterPanel_TEMPLATE

# FOOTER
@onready var item_get_grid = $VBoxContainer/FooterPanel/ItemGetGrid

signal closed


func _ready() -> void:
	self.hide()


func show_battle_results(rewards : Dictionary):
	exp_gained_label.text = str(rewards.exp) + " EXP"
	gold_gained_label.text = str(rewards.gold) + " GOLD"
	# show character panels
	for character in Globals.party:
		var char_panel = char_panel_template.duplicate()
		char_panel.get_node("Portrait").texture = character.texture
		char_panel.get_node("Name").text = character.name
		char_panel.get_node("Level").text = "LVL " + str(character.level)
		
		character.leveled_up.connect(on_character_level_up.bind(character, char_panel))
		
		char_panel.show()
		character_grid.add_child(char_panel)
	
	self.show()

func on_character_level_up(char, panel):
	var label : Label = panel.get_node("Level")
	label.add_theme_color_override("font_color", Color.YELLOW)
	label.text = "LVL " + str(char.level) + " (Level Up!)"


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_accept"):
		get_viewport().set_input_as_handled()
		closed.emit()
