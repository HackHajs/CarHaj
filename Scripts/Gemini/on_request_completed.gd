extends HTTPRequest
class_name AI

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	get_parent().say(json["candidates"][0]["content"]["parts"][0]["text"])
