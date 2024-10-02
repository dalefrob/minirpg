extends Battler
class_name PlayerBattler

var player_ui : PlayerUI

func _show_damage_text(text : String):
	var dmg_label = preload("res://damage_label.tscn").instantiate() as DamageLabel
	var randx = randi_range(-48, 48)
	dmg_label.position = Vector2((player_ui.size.x / 2) + randx, -48)
	player_ui.add_child(dmg_label)
	dmg_label.float_up(text)
	player_ui.hit_animation()
