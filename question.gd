extends LineEdit

func _ready() -> void:
	text_submitted.connect(question_asked)
	
func question_asked(qst: String):
	print("qst")
	var json = '{
	  "contents": [
		{
		  "parts":[{
			"text": "%s"
		  }],
		  "role": "user"
		}
	  ],
	  "cachedContent": "cachedContents/8cau0f6oa00d"
	}' %qst
	# cachedContent must be changed manually before compilation, it is the cache name
	var url = "https://generativelanguage.googleapis.com/v1beta/models/models/gemini-1.5-flash-001?key=%s" %GEMINI.API_KEY
	$HTTPRequest.request_completed.connect($HTTPRequest._on_request_completed)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)	
