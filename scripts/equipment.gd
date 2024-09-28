extends Resource
class_name Equipment

@export var head : EquippableItem
@export var body : EquippableItem
@export var hands : EquippableItem
@export var feet : EquippableItem
@export var ring : EquippableItem
@export var weapon : EquippableItem

func get_slots():
	return {
		Slot.HEAD: head,
		Slot.BODY: body,
		Slot.RING: ring,
		Slot.HANDS: hands,
		Slot.FEET: feet,
		Slot.WEAPON: weapon,
	}

func get_equipment_stat_total(stat_id : int):
	var _total = 0
	for item in get_slots().values():
		if item:
			_total += (item as EquippableItem).stats.get_stat(stat_id)
	return _total

func equip(item : EquippableItem):
	var slot = item.slot
	get_slots()[slot] = item


# ---------------

enum Slot {
	HEAD,
	BODY,
	RING,
	HANDS,
	FEET,
	WEAPON,
	SPIRIT
}

var slot_string = {
	Slot.HEAD: "HEAD",
	Slot.BODY: "BODY",
	Slot.RING: "RING",
	Slot.HANDS: "HANDS",
	Slot.FEET: "FEET",
	Slot.WEAPON: "WEAPON",
	Slot.SPIRIT: "SPIRIT"
}