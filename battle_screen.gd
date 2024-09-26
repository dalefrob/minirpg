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

@export var party : Array[Actor] = []

@export var enemy_battlers : Array[Sprite2D]

var turns : Array[Turn] = []

func load_encounter(encounter_data):
	pass


func _ready() -> void:
	start_battle()


func start_battle():
	for battler in enemy_battlers:
		battler.enemy.init_attributes()
	
	# TEST initial turns
	turns.push_back(Turn.create(party[0]))
	turns.push_back(Turn.create(enemy_battlers[0].enemy))

func _process(delta: float) -> void:
	call(current_state, delta)
	time_in_state += delta

# state process functions

func prebattle(delta):
	pass

func battle(delta):
	pass


func _on_attack_pressed() -> void:
	# TODO - Staged process
	# pick target
	# do animation
	# run logic
	var current_turn_actor = turns[0].actor
	BattleHelper.do_attack(current_turn_actor, enemy_battlers[0].enemy)


# Turn system
class Turn:
	var actor : Actor
	
	func _init(_actor) -> void:
		self.actor = _actor
	
	func execute():
		return true
	
	static func create(actor : Actor):
		var turn = Turn.new(actor)
		return turn

# Signals
