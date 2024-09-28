extends Node
class_name BattleScreen

const PREBATTLE = "prebattle"
const BATTLE = "battle"
const POSTBATTLE_WIN = "postbattlewin"
const POSTBATTLE_LOSE = "postbattlelose"

var battler_pks = preload("res://enemy_battler.tscn")
var damage_label_pks = preload("res://damage_label.tscn")

# State machine needed?

var previous_state : String = ""
var current_state : String = PREBATTLE
var time_in_state : float = 0.0

func change_state(new_state : String):
	previous_state = current_state
	current_state = new_state

# ---------
@onready var enemy_battlers = $EnemyBattlers
@onready var camera : Camera2D = $Camera2D
@onready var bg : Sprite2D = $Background
@onready var timer : Timer = $Timer

@export var party : Array[Actor] = []

var turns : Array[Turn] = []

func load_encounter(encounter : Encounter):
	print("loading encounter: %s" % encounter)
	for e in encounter.enemies:
		var new_battler = battler_pks.instantiate()
		new_battler.enemy = e
		new_battler.disintegrated.connect(on_battler_disintegrated)
		enemy_battlers.add_child(new_battler)

	# align battlers
	var window_width = DisplayServer.window_get_size(0).x
	var step = window_width / (enemy_battlers.get_child_count() + 1)
	for i in range(enemy_battlers.get_child_count()):
		enemy_battlers.get_child(i).position.x = (-window_width / 2) + ((i + 1) * step)
	
	# TEST initial turns
	turns.push_back(Turn.create(party[0]))
	turns.push_back(Turn.create(enemy_battlers.get_child(0).enemy))


func _process(delta: float) -> void:
	call(current_state, delta)
	time_in_state += delta
	

# state process functions

func prebattle(delta):
	pass

func battle(delta):
	pass




func is_all_enemies_defeated():
	var all_dead = enemy_battlers.get_children().all(func(e): return e.is_dead)
	return all_dead


func _on_attack_pressed() -> void:
	# TODO - Staged process
	# pick target
	# do animation
	# run logic
	var current_turn_actor = turns[0].actor
	var battler = enemy_battlers.get_child(0)
	var dmg = BattleHelper.calculate_damage(current_turn_actor, battler.enemy)
	battler.take_hit(dmg)
	var dmg_label = damage_label_pks.instantiate() as DamageLabel
	battler.add_child(dmg_label)
	dmg_label.float_up(str(dmg))

func on_battler_disintegrated():
	if is_all_enemies_defeated():
		print("You won!")


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
