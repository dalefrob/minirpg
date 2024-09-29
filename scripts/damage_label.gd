extends Node2D
class_name DamageLabel

func float_up(msg : String, color : Color = Color.WHITE):
	$Label.add_theme_color_override("font_color", color)
	$Label.text = msg
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:y", -48, 1.5)
	tween.tween_callback(queue_free)
	tween.play()
