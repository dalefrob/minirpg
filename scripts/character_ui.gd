extends Panel
class_name CharacterUI

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
	
	# setup signals
	character.took_damage.connect(update_ui)
	character.healed_damage.connect(update_ui)

func update_ui(_args):
	hp_label.text = "HP: %s/%s" % [character.hp, character.get_max_hp()]

func hit_animation():
	var orig_y = portrait.position.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(portrait, "self_modulate", Color.WHITE, 0.1).from(Color.RED)
	tween.tween_property(portrait, "position:y",orig_y + 36, 0.1).from(orig_y)
	tween.chain().tween_property(portrait, "position:y", orig_y, 0.25)
	tween.play()
	
