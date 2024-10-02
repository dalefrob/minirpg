extends Panel
class_name PlayerUI

@onready var name_label : Label = $Name
@onready var hp_label : RichTextLabel = $HP
@onready var mp_label : RichTextLabel = $MP
@onready var portrait : TextureRect = $PartyMemberUI

@export var character : Character:
	set(value):
		character = value
		await ready
		_initialize()
	get: return character

func _initialize() -> void:
	name = character.name
	name_label.text = character.name
	portrait.texture = character.texture

func hit_animation():
	var orig_y = portrait.position.y
	var tween = create_tween()
	tween.tween_property(portrait, "position:y",orig_y + 48, 0.1).from(orig_y)
	tween.tween_property(portrait, "position:y", orig_y, 0.25)
	tween.play()
	
