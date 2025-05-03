extends Control

func _ready() -> void:
	$Cupri.longsay("Hi! I am Cupri, your car's personal assistant. How can I help?")

func question_asked(qst: String):
	var json = '{
  "model": "models/gemini-1.5-flash",
  "contents":[
	{
	  "parts":[
		{"file_data": {"mime_type": "MIME_TYPE", "file_uri": $file_uri}}
	  ],
	"role": "user"
	}
  ],
  "system_instruction": {
	"parts": [
	  {
		"text": "$SYSTEM_INSTRUCTION"
	  }
	],
	"role": "system"
  },
  "ttl": "$TTL"
}'
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)	
