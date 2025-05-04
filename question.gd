extends LineEdit

func _ready() -> void:
	text_submitted.connect(intermediate_step)
	
func intermediate_step(input: String):
	$"..".question_asked(input)
