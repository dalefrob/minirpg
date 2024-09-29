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


func enqueue(_battler : Battler):
	var turn = Turn.new()
	turn.battler = _battler
	turn.player_turn = (_battler is PlayerBattler)
	turn.name = "t%s_%s" % [turn_id, _battler.name]
	add_child(turn)
	turn_id += 1

func end_current_turn():
	current_turn.state = TurnState.DONE
	current_turn.queue_free()

func _process(delta: float) -> void:
	if turns_to_process == 0:
		return
	
	if current_turn.state == TurnState.STANDBY:
		current_turn.state = TurnState.WAITING
		turn_started.emit(current_turn)
	
	is_waiting_for_player = current_turn.player_turn && current_turn.state == TurnState.WAITING
	if is_waiting_for_player:
		return
