# Manages the flow of turns in the battle system
extends Node
class_name TurnSystem

var turn_id = 0
var is_waiting_for_player : bool = false

var enabled : bool = true

var previous_turns : Array[Turn] = []

var current_turn : Turn:
	get: return get_child(0)

var turns_to_process : int:
	get: return get_child_count()

signal turn_started(turn)
signal turn_ended(turn)
signal all_turns_processed


func stop():
	print("Turn System Disabled")
	enabled = false
	clear_queue()


func clear_queue():
	for c in get_children():
		c.queue_free()


func enqueue(_battler : Battler):
	var turn = Turn.new()
	turn.battler = _battler
	turn.name = "t%s_%s" % [turn_id, _battler.name]
	add_child(turn)
	turn_id += 1


func end_current_turn():
	current_turn.state = Turn.DONE
	turn_ended.emit(current_turn)


func _process(delta: float) -> void:
	for child in get_children():
		if child.state == Turn.DONE:
			previous_turns.push_front(current_turn)
			remove_child(child)
	
	if enabled:
		_process_turns()


func _process_turns():
	if turns_to_process == 0:
		all_turns_processed.emit()
		return
	
	# set newest turn to waiting
	if current_turn.state == Turn.STANDBY:
		current_turn.state = Turn.WAITING_FOR_COMMAND
		if current_turn.battler.actor.is_dead:
			print("%s is dead, skipping turn" % current_turn.battler.name)
			current_turn.state = Turn.DONE
		else:
			turn_started.emit(current_turn)
	
	is_waiting_for_player = current_turn.player_controlled && current_turn.state == Turn.WAITING_FOR_COMMAND
	if is_waiting_for_player:
		return
