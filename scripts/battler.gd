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

func _on_actor_took_damage(damage):
	_show_damage_text(str(damage))

func _on_actor_healed_damage(amount):
	_show_healed_text(str(amount))

func _show_healed_text(amount : String):
	print("heal")
	pass

func _on_actor_health_depleted():
	pass

func _show_damage_text(text : String):
	var dmg_label = preload("res://damage_label.tscn").instantiate() as DamageLabel
	add_child(dmg_label)
	dmg_label.float_up(text)
