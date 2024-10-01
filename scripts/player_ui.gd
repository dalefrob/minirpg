extends Panel
class_name PlayerUI

@onready var name_label : Label = $Name
@onready var hp_label : RichTextLabel = $HP
@onready var mp_label : RichTextLabel = $MP
@onready var portrait : TextureRect = $PartyMemberUI

@export var character : Character:
	set(value):
		character = value
	get: return character

func _ready() -> void:
	name = character.name
	name_label.text = character.name
	portrait.texture = character.texture
