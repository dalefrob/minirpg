extends Node
class_name BattleScreen

const PREBATTLE = "prebattle"
const BATTLE = "battle"
const POSTBATTLE_WIN = "postbattlewin"
const POSTBATTLE_LOSE = "postbattlelose"

# State machine needed?

var previous_state : String = ""
var current_state : String = PREBATTLE
var time_in_state : float = 0.0

func change_state(new_state : String):
	previous_state = current_state
	current_state = new_state


# ---------

@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background

@export var monsters : Array[Actor] = []
@export var party : Array[Actor] = []

var turns : Array[Turn] = []

func load_encounter(encounter_data):
	pass

func _process(delta: float) -> void:
	call(current_state, delta)
	time_in_state += delta

# state process functions

func prebattle(delta):
	pass

func battle(delta):
	pass

# Subclasses
class Turn:
	var actor : Actor
