# Base class for actual actors battling in the battle screen
extends Node2D
class_name Battler

@export var actor : Actor:
	get: return actor
	set(value): 
		actor = value
		_initialize()

@export var hp : int
@export var mp : int

var is_dead : bool

func _ready() -> void:
	name = actor.name

func _initialize():
	hp = actor.get_max_hp()
	mp = actor.get_max_mp()

func _take_hit(damage):
	hp -= damage
