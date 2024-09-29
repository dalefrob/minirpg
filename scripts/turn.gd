extends Node
class_name Turn
# Turn system

var state : TurnSystem.TurnState = TurnSystem.TurnState.STANDBY

var battler : Battler
var player_turn : bool

signal turn_ended

func _process(delta: float) -> void:
	pass
