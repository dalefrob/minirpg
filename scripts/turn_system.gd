# Manages the flow of turns in the battle system
extends Node
class_name TurnSystem

enum TurnState {
	STANDBY,
	WAITING,
	EXECUTING,
	DONE
}


var turn_id = 0
var is_waiting_for_player : bool = false

var current_turn : Turn:
	get: return get_child(0)

var turns_to_process : int:
	get: return get_child_count()

signal turn_started(turn)
signal turn_ended(turn)
signal all_turns_processed

func clear_queue():
	for c in get_children():
		c.queue_free()

func enqueue(_battler : Battler):
	var turn = Turn.new()
	turn.battler = _battler
	turn.is_player_turn = (_battler is CharacterBattler)
	turn.name = "t%s_%s" % [turn_id, _battler.name]
	add_child(turn)
	turn_id += 1

func end_current_turn():
	current_turn.state = TurnState.DONE
	turn_ended.emit(current_turn)
	current_turn.queue_free()

func _process(delta: float) -> void:
	if turns_to_process == 0:
		all_turns_processed.emit()
		return
	
	if current_turn.state == TurnState.STANDBY:
		# skip dead character turns
		if current_turn.battler.actor.is_dead:
			end_current_turn()
			return
		current_turn.state = TurnState.WAITING
		turn_started.emit(current_turn)
	
	is_waiting_for_player = current_turn.is_player_turn && current_turn.state == TurnState.WAITING
	if is_waiting_for_player:
		return
