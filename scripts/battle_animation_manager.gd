extends Node
class_name BattleAnimationManager

@onready var bg : Sprite2D = get_parent().find_child("Background")

signal battle_animation_finished

func play_battle_animation(scene_name : StringName, params : BattleAnimParams, dim : bool = false):
	var scene_path = "res://battle_anim_scenes/%s.tscn" % scene_name
	if !ResourceLoader.exists(scene_path):
		printerr("No animation: %s" % scene_name)
		await get_tree().process_frame
		battle_animation_finished.emit()
		return
	
	# create the battle animation
	var new_battle_anim = load(scene_path).instantiate() as BattleAnimation
	new_battle_anim.initialize(params)
	new_battle_anim.global_position = params.get_global_position()
	
	var on_finished_anim = func():
		new_battle_anim.queue_free()
		undim()
	
	if dim:
		new_battle_anim.finished.connect(on_finished_anim, CONNECT_ONE_SHOT)
		await dim()
	
	add_child(new_battle_anim)
	
	await new_battle_anim.finished
	battle_animation_finished.emit()


func dim():
	var tween = create_tween()
	tween.tween_property(bg, "self_modulate", Color(0.3,0.3,0.3,1), 0.4).from_current()
	tween.tween_interval(0.2)
	tween.play()
	await tween.finished


func undim():
	var tween = create_tween()
	tween.tween_property(bg, "self_modulate", Color.WHITE, 0.4).from_current()
	tween.play()
	await tween.finished


func get_center_screen() -> Vector2:
	return DisplayServer.window_get_size(0) / 2
