extends Control
class_name QTE

func _ready():
	hide()
	#temp
	addOption("wrong answer", false)
	addOption("correct answer", true)
	addOption("very wrong", false)
	start(10)
	#endtemp

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
	$Time.value -= delta
	if $Time.value <= 0:
		selectAns(false)

func selectAns(correct):
	hide()
	for i in $Options.get_children():
		$Options.remove_child(i)
	#TODO respond to answer
	print(correct)
