## Deals damage over time
extends StatusEffect
class_name DOTStatusEffect

@export var total_damage : Damage

func _update():
	var damage = total_damage.duplicate() as Damage
	damage.amount = (total_damage.amount / max_duration)
	actor.take_damage(damage)
	
	super._update()

func _is_more_potent(_other):
	assert(_other is DOTStatusEffect)
	return total_damage.amount > _other.total_damage
