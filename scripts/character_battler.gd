extends Battler
class_name CharacterBattler

var character_ui : CharacterUI

func _initialize():
	super._initialize()

func _on_actor_healed_damage(amount):
	print("test")
	
func _show_healed_text(amount : String):
	var dmg_label = preload("res://damage_label.tscn").instantiate() as DamageLabel
	character_ui.add_child(dmg_label)
	dmg_label.float_up(str(amount), Color.LIME_GREEN)

func _show_damage_text(text : String):
	var dmg_label = preload("res://damage_label.tscn").instantiate() as DamageLabel
	var randx = randi_range(-48, 48)
	dmg_label.position = Vector2((character_ui.size.x / 2) + randx, -48)
	character_ui.add_child(dmg_label)
	dmg_label.float_up(text)
	character_ui.hit_animation()
