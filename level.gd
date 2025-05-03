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


func _ready():
	qtes = Array(FileAccess.open("res://Resources/QTES.txt", FileAccess.READ).get_as_text().split("\n"))
	Cupri.say("Welcome to your new car! grab the wheel and lets get driving, shall we?")
	await Player.clickedSteer
	Player.shake_strength = .1
	moving = true
	await get_tree().create_timer(2).timeout
	await Cupri.say("You do know how to drive this thing right?")
	await Cupri.say("Like if one of lights comes on you know what to do?")
	
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
	var target = Vector3(cam[0].to_float(), cam[1].to_float(), cam[2].to_float())
	var zoom = cam[3].to_float()
	
	var opts = qtes[1].split("|")
	var idx = qtes[2].to_int()
	var time = qtes[3].to_float()
	qtes = qtes.slice(4)
	return [target, zoom, opts, idx, time]

func nextQTE():
	var data = getQ()
	if data == null:
		Cupri.leave()
		return
	
	Player.lookat(data[0], data[1])
	#optional question from cupri
	for i in data[2].size():
		QTE.addOption(data[2][i], i == data[3])
	QTE.start(data[4])

func result(correct):
	Player.returnControl()
	if not correct:
		Player.shake()
		#Cupri.say("You idiot.")
		Cupri.make_funOf()
	else:
		#Cupri.say("wow.... congrats on this simple question")
		Cupri.make_congrat()
