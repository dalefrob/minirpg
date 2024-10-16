## Deals damage over time
extends StatusEffect
class_name DOTStatusEffect

@export var total_damage : Damage

var stacks : int = 1 # Deals damage num of times

func _update():
	var damage = total_damage.duplicate() as Damage
	damage.amount = total_damage.amount / max_duration
	actor.take_damage(damage)
