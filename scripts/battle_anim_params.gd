extends RefCounted
class_name BattleAnimParams

enum Positioning {
	TARGET,
	USER,
	CENTER
}

var user : Battler
var target : Battler
var positioning := Positioning.TARGET
var offset := Vector2.ZERO

func get_global_position() -> Vector2:
	match positioning:
		Positioning.TARGET: return target.global_position
		Positioning.USER: return user._get_anim_position()
	return Vector2.ZERO
