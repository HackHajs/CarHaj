extends Node3D

#loop:
# -> question
# -> quip
# -> repeat
@onready var QTE = $QTE
@onready var Player = $Player
@onready var Cupri = $Cupri
var qtes: Array
var moving = false
var currentIcon = null

func _ready():
	qtes = Array(FileAccess.open("res://Resources/QTES.txt", FileAccess.READ).get_as_text().split("\n"))
	Cupri.longsay("Welcome to your new car! grab the wheel and lets get driving, shall we?")
	await Player.clickedSteer
	Player.shake_strength = .1
	moving = true
	await get_tree().create_timer(2).timeout
	await Cupri.say("You do know how to drive this thing right?")
	await Cupri.say("Like if one of these lights comes on you know what to do?")
	
	QTE.answer.connect(result)
	Cupri.done.connect(nextQTE)
	Cupri.say("Riiiight?")

func _process(delta):
	if moving:
		$MeshInstance3D.position.z += delta * 100
		$MeshInstance3D.position.z -= 125 if $MeshInstance3D.position.z > 0 else 0

func getQ():
	if qtes.size() < 4: return null
	var cam: PackedStringArray = qtes[0].split(" ")
	var target = get_node(qtes[0])
	
	var opts = qtes[1].split("|")
	var idx = qtes[2].to_int()
	var time = qtes[3].to_float()
	qtes = qtes.slice(4)
	return [target, opts, idx, time]

func nextQTE():
	var data = getQ()
	if data == null:
		Cupri.leave()
		return
	
	data[0].show()
	Player.lookat(data[0].position, 2)
	#optional question from cupri
	for i in data[1].size():
		QTE.addOption(data[1][i], i == data[2])
	QTE.start(data[3])
	currentIcon = data[0]

func result(correct):
	Player.returnControl()
	if not correct:
		Player.shake()
		Cupri.make_funOf()
	else:
		currentIcon.hide()
		Cupri.make_congrat()
