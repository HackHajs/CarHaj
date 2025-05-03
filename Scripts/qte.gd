extends Control
class_name QTE

signal answer(result: bool)

func _ready():
	hide()

func addOption(text, correct: bool):
	var c = Button.new()
	c.text = text
	c.size_flags_horizontal |= Control.SIZE_EXPAND
	c.pressed.connect(selectAns.bind(correct))
	$Options.add_child(c)

func start(time):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Time.max_value = time
	$Time.value = time
	show()

func _process(delta):
	if not visible: return
	$Time.value -= delta
	if $Time.value <= 0:
		selectAns(false)

func selectAns(correct):
	hide()
	for i in $Options.get_children():
		$Options.remove_child(i)
	answer.emit(correct)
