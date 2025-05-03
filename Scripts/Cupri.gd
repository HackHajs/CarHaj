extends Control

const TYPE_SPEED = .03
const WIDTH = 300

signal done

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		$HTTPRequest.make_joke()

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

func make_funOf():
	var json = '{
	  "contents": [{
		"parts":[
		  {"text": "Encourage a new car owner failing to learn how their Cupra Tavascan car works, in a short sentence. The sentence should be in second person, and around 15 words long."}
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
		  {"text": "Congratulate a new car owner on learning a new function on their Cupra Tavascan car works, in a short one-sentence positive joke. The sentence should be in second person, and around 15 words long."}
		]
	  }]
	}'
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
