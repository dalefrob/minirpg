extends RefCounted
class_name StatModifer

enum ModType {
	ADD = 0,
	MULT = 1
}

var source : Resource # Where it comes from
var stat_alias : String
var amount : int
var mod_type : ModType # Add 0 or Mult 1

static func create(_source : Resource, _stat_alias : String, _amount : int, _mod_type : ModType):
	var sm = StatModifer.new()
	sm.source = _source
	sm.stat_alias = _stat_alias
	sm.amount = _amount
	sm.mod_type = _mod_type
	return sm
