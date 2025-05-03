extends Control

const TYPE_SPEED = .03
const WIDTH = 300

signal done

func leave():
	$Bubble.hide()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", -WIDTH, 1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	hide()

func enter():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", WIDTH, 1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
func say(msg: String):
	if not visible:
		await enter()
	$Bubble.show()
	$Bubble/Label.visible_characters = 0
	$Bubble/Label.text = msg
	var tween = get_tree().create_tween()
	tween.tween_property($Bubble/Label, "visible_characters", msg.length(), msg.length() * TYPE_SPEED)
	await tween.finished
	await get_tree().create_timer(5).timeout
	$Bubble.hide()
	done.emit()
