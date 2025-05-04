extends Control

const TYPE_SPEED = .03
const WIDTH = 300

signal done

#func _gui_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.is_pressed():
#		$HTTPRequest.make_joke()

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
	
func longsay(msg: String):
	if not visible:
		await enter()
	$Bubble.show()
	$Bubble/Label.visible_characters = 0
	$Bubble/Label.text = msg
	var tween = get_tree().create_tween()
	tween.tween_property($Bubble/Label, "visible_characters", msg.length(), msg.length() * TYPE_SPEED)
	await tween.finished
	done.emit()

func make_funOf():
	var json = '{
	  "contents": [{
		"parts":[
		  {"text": "You are a witty assistant in a hastily developed app, where the user is being introduced to their new Cupra Tavascan. React in one sentence to them getting a quiz question wrong"}
		]
	  }]
	}'
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
	
	
func make_congrat():
	var json = '{
	  "contents": [{
		"parts":[
		  {"text": "You are a witty assistant in a hastily developed app, where the user is being introduced to their new Cupra Tavascan. React in one sentence to them getting a quiz question correct"}
		]
	  }]
	}'
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
