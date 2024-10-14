# Base class for actual actors battling in the battle screen
extends Node2D
class_name Battler

@export var player_controlled : bool = false

@export var actor : Actor:
	get: return actor

func _ready() -> void:
	name = actor.name

###
# DO NOT CALL THIS
###
func _initialize(_actor : Actor):
	actor = _actor
	# set up signals
	actor.took_damage.connect(_on_actor_took_damage)
	actor.healed_damage.connect(_on_actor_healed_damage)
	actor.health_depleted.connect(_on_actor_health_depleted)

func _get_anim_position():
	pass

# Override these functions in children
func _on_actor_took_damage(_damage : Damage):
	pass

func _on_actor_healed_damage(_damage : Damage):
	pass

func _on_actor_health_depleted():
	pass
