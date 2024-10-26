# an Command that can be executed such as 'attack' 'use skill' 'use item'
extends Command
class_name DefendCommand

# Coroutine!
func _execute():
	user.actor.defending = true
	BattleHelper.show_floating_text(user, "Defend", Color.YELLOW)
	await delay(1.0)
