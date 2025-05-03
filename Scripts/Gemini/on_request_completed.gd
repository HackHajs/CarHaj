extends HTTPRequest
class_name AI

func make_joke():
	var json = '{
	  "contents": [{
		"parts":[
		  {"text": "Make a joke about the"}
		]
	  }]
	}'
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	get_parent().say(json["candidates"][0]["content"]["parts"][0]["text"])
