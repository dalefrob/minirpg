# animated battle animation to be used for skills and ailments
# for now, uses animated sprites like RPG maker, but may extend into particle effects
extends Node2D
class_name BattleAnimation

var params : BattleAnimParams

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal finished


func _ready() -> void:
	z_index = 99
	z_as_relative = false
	animation_player.animation_finished.connect(on_animation_player_finished)

func initialize(_params : BattleAnimParams):
	params = _params

func on_animation_player_finished(_anim_name):
	finished.emit()

func color_battler(color : Color):
	params.target.flash(color, 0.2)

func color_user(color : Color):
	if params.user.has_method("flash"):
		params.user.flash(color, 0.2)

func color_enemies(color : Color):
	var enemies = BattleHelper.get_enemy_battlers()
	for e in enemies:
		e.flash(color, 0.2)
