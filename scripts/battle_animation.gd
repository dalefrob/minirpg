# animated battle animation to be used for skills and ailments
# for now, uses animated sprites like RPG maker, but may extend into particle effects
extends Node2D
class_name BattleAnimation

var user : Battler
var enemies : Array[Battler]
var enemy : Battler:
	get: return enemies[0]

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal finished


func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_player_finished)
	animation_player.play()


func on_animation_player_finished(_anim_name):
	finished.emit()


func color_battler(color : Color):
	var tween = create_tween().bind_node(enemy)
	tween.tween_property(enemy.sprite, "self_modulate", color, 0.6).from(Color.WHITE)
	tween.tween_property(enemy.sprite, "self_modulate", Color.WHITE, 0.4)
	tween.play()
