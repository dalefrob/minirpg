extends Resource
class_name EnemyAI

@export var skill_pool : Array[Skill]
@export var skill_on_low_health : Skill
@export var skill_on_take_damage : Skill

var enemy : Enemy

func initialize(_enemy : Enemy):
	enemy = _enemy

func get_command() -> Command:
	randomize()
	var use_skill = (randf() >= 0.5)
	if skill_pool.size() > 0 and use_skill:
		var skill = skill_pool.pick_random()
		return SkillCommand.new(skill)
	return AttackCommand.new()
