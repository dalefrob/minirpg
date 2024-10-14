# A turn for use in the turn based battle system.
# A turn holds dats for the battler whose turn it is, and the action to be executed
extends Node
class_name Turn

var state : TurnSystem.TurnState = TurnSystem.TurnState.STANDBY

var battler : Battler # Which battler on the field is this for?
var actor : Actor:
	get: return battler.actor

var is_player_turn : bool # Is it a player?
var action : Action # What command is to be executed?
