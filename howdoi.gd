extends Control

func _ready() -> void:
	$Cupri.longsay("Hi! I am Cupri, your car's personal assistant. How can I help?")
	
func question_asked(qst: String):
	print(qst)
	var json = '{
	  "contents": [
		{
		  "parts":[{
			"text": "How do I drive?"
		  }],
		  "role": "user"
		}
	  ],
	  "cachedContent": "cachedContents/5s4p8huoj5uk"
	}' 
	# cachedContent must be changed manually before compilation, it is the cache name
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-001:generateContent?key=%s" %GEMINI.API_KEY
	$Cupri/HTTPRequest.request_completed.connect($Cupri/HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$Cupri/HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)	
