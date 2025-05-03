extends Control

func load_file():
	var file = FileAccess.open("res://Resources/Cupra_manual.b64", FileAccess.READ)
	var content = file.get_as_text()
	return content

func _ready():
	var manual = load_file()
	var json = '{
	  "contents": [{
		"parts":[
		  {"inline_data": {"mime_type": "application/pdf", "data": "%s"}},
		  {"text": "Study this manual. You are now a very helpful chatbot to help the user find a function in their brand new car."}
		]
	  }]
	}' %manual
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect(_on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
