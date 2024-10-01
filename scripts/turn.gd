# A turn for use in the turn based battle system.
# A turn holds dats for the battler whose turn it is, and the action to be executed
extends Node
class_name Turn

var state : TurnSystem.TurnState = TurnSystem.TurnState.STANDBY

var battler : Battler
var player_turn : bool
var action : Action

signal turn_ended
