extends State
class_name BattleScreenState

var battle_screen: BattleScreen

func _ready() -> void:
	await owner.ready
	battle_screen = owner as BattleScreen
	assert(battle_screen != null)
