extends PanelContainer
class_name BattleResultsPanel

# HEADER
@onready var exp_gained_label = $VBoxContainer/HeaderPanel/EXPGained
@onready var gold_gained_label = $VBoxContainer/HeaderPanel/GoldGained

# CHARACTERS
@onready var character_grid = $VBoxContainer/CharacterGrid

# FOOTER
@onready var item_get_grid = $VBoxContainer/FooterPanel/ItemGetGrid

func load_results(data : Dictionary):
	pass
