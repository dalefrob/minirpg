extends Node2D
class_name DamageLabel

@onready var label : Label = $Label

func float_up(msg : String, color : Color = Color.WHITE):
	label.add_theme_color_override("font_color", color)
	label.text = msg
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:y", position.y-48, 1.0)
	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(queue_free)
	tween.play()
