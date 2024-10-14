# A turn for use in the turn based battle system.
# A turn holds dats for the battler whose turn it is
# collects parameters from various sources, and executes an action
extends Node
class_name Turn

const STANDBY = 0
const WAITING_FOR_COMMAND = 1
const SELECTING_TARGET = 2
const EXECUTING_COMMAND = 3
const DONE = 4

var state = STANDBY

var battler : Battler # Which battler on the field is this for?

# convenient accessors
var actor : Actor:
	get: return battler.actor
var player_controlled : bool:
	get: return battler.player_controlled # Is it a player?

var action : Action = null    # What command is to be executed?
var target : Variant = null   # What target is the command to be used on? BATTLER, ITEM?
