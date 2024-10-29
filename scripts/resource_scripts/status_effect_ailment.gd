## An effect that does something to the affected actor
extends StatusEffect
class_name AilmentStatusEffect

@export var ailment : BattleHelper.Ailments
@export_range(0.0, 1.0) var chance : float

## Can the effect be applied to the actor?
func _can_apply(_actor : Actor):
	# TODO - If actor is immune to ailment - return false
	# Roll check
	if chance >= randf():
		return false
	return _can_apply(_actor)


func _on_applied():
	actor.ailments |= ailment 
	super._on_applied()

func _update():
	if max_duration > 0:
		duration -= 1

func _on_removed():
	actor.ailments &= ~ailment
	super._on_removed()
