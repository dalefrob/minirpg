extends Panel
class_name CharacterUI

@onready var name_label : Label = $Name
@onready var hp_label : RollingNumberLabel = $HP
@onready var mp_label : RollingNumberLabel = $MP
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
	name_label.add_theme_color_override("font_color", character.unique_color)
	portrait.texture = character.texture
	
	hp_label.set_value_instantly(character.hp)
	mp_label.set_value_instantly(character.mp)
	# setup signals
	character.took_damage.connect(update_ui)
	character.healed_damage.connect(update_ui)
	character.health_depleted.connect(update_ui)


func update_ui(_args = {}):
	# update labels
	hp_label.value = character.hp
	var perc = float(character.hp) / character.get_max_hp()
	colorize_label_by_percentage(hp_label, perc)
	perc = float(character.mp) / character.get_max_mp()
	mp_label.value = character.mp
	colorize_label_by_percentage(mp_label, perc)


func colorize_label_by_percentage(label : Label, perc : float):
	var text_color = Color.WHITE
	if perc < 0.5:
		text_color = Color.YELLOW
	if perc <= 0:
		text_color = Color.DARK_RED
	label.add_theme_color_override("font_color", text_color)


func hit_animation():
	var orig_y = portrait.position.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(portrait, "self_modulate", Color.WHITE, 0.1).from(Color.RED)
	tween.tween_property(portrait, "position:y",orig_y + 36, 0.1).from(orig_y)
	tween.chain().tween_property(portrait, "position:y", orig_y, 0.25)
	tween.play()
	
