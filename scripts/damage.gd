extends RefCounted
class_name Damage

enum Element {
	PHYSICAL,
	FIRE,
	ICE,
	LIGHTNING
}

var amount : int
var element : Element

static func create(_amount : int, _element = Element.PHYSICAL) -> Damage:
	var dmg = Damage.new()
	dmg.amount = _amount
	dmg.element = _element
	return dmg
