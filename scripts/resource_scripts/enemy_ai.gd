extends Resource
class_name EnemyAI

@export var skill_pool : Array[Skill]
@export var skill_on_low_health : Skill
@export var skill_on_take_damage : Skill

var enemy : Enemy

func initialize(_enemy : Enemy):
	enemy = _enemy


func get_command() -> Command:
	return AttackCommand.new(null)
