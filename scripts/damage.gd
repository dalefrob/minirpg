extends Resource
class_name Damage

enum Element {
	NONE = 0,
	FIRE = 1,
	WATER = 2,
	ICE = 3,
	LIGHTNING = 4,
	EARTH = 5,
	AIR = 6,
	SHADOW = 7,
	HOLY = 8,
	CHAOS = 9
}

var amount : int
var element : Element
var critical : bool
var heal : bool

static func create(_amount : int, _element = Element.NONE, _heal = false) -> Damage:
	var dmg = Damage.new()
	dmg.amount = _amount
	dmg.element = _element
	dmg.heal = _heal
	return dmg
