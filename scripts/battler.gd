# Base class for actual actors battling in the battle screen
extends Node2D
class_name Battler

@export var actor : Actor:
	get: return actor
	set(value): 
		actor = value
		_initialize()

func _ready() -> void:
	name = actor.name

func _initialize():
	actor._reset()
	# set up signals
	actor.took_damage.connect(_on_actor_took_damage)
	actor.healed_damage.connect(_on_actor_healed_damage)
	actor.health_depleted.connect(_on_actor_health_depleted)

func _get_anim_position():
	pass

# Override these functions in children
func _on_actor_took_damage(damage):
	pass

func _on_actor_healed_damage(amount):
	pass

func _on_actor_health_depleted():
	pass
