extends AnimationPlayer
class_name BattleAnimationPlayer

enum AnimPosition {
	TARGET = 0,
	USER = 1,
	FIELD = 2,
	CUSTOM = 3
}

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var bg : Sprite2D = get_parent().find_child("Background")

@export var sprite_frames : SpriteFrames

var attacker_ref : Battler
var target_ref : Battler 

func play_battle_animation(animation_name : StringName, attacker : Battler, target : Battler):
	attacker_ref = attacker
	target_ref = target
	play("battle_anims/" + animation_name)

func show_sprite_animation(anim_alias : String, anim_position := AnimPosition.TARGET, params = {}):
	if !sprite_frames.has_animation(anim_alias):
		printerr("%s doesn't exist")
		return
	# set up the node
	var new_sprite = AnimatedSprite2D.new()
	new_sprite.sprite_frames = sprite_frames
	new_sprite.z_index = 99
	new_sprite.autoplay = anim_alias
	new_sprite.animation_finished.connect(new_sprite.queue_free, CONNECT_ONE_SHOT)
	add_child(new_sprite)
	match anim_position:
		AnimPosition.TARGET:
			new_sprite.position = target_ref.position
		AnimPosition.USER:
			new_sprite.position = attacker_ref.position
		AnimPosition.CUSTOM:
			if params.has("custom_position"):
				new_sprite.position = params.custom_position
			
	

func color_battler(color : Color):
	var tween = create_tween().bind_node(target_ref)
	tween.tween_property(target_ref.sprite, "self_modulate", color, 0).from(Color.WHITE)
	tween.tween_property(target_ref.sprite, "self_modulate", Color.WHITE, 0.3)
	tween.play()

func dim():
	bg.self_modulate = Color(0.3,0.3,0.3,1)

func undim():
	bg.self_modulate = Color.WHITE

func get_center_screen() -> Vector2:
	return DisplayServer.window_get_size(0) / 2
