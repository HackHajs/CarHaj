extends Node3D

#loop:
# -> question
# -> quip
# -> repeat
@onready var QTE = $QTE
@onready var Player = $Player
@onready var Cupri = $Cupri
var qtes: Array

func _ready():
	qtes = Array(FileAccess.open("res://Resources/QTES.txt", FileAccess.READ).get_as_text().split("\n"))
	
	QTE.answer.connect(result)
	Cupri.done.connect(nextQTE)
	Cupri.say("Hello There, Im just gonna talk some stuff")

func getQ():
	if qtes.size() < 4: return null
	var cam: PackedStringArray = qtes[0].split(" ")
	var target = Vector3(cam[0].to_float(), cam[1].to_float(), cam[2].to_float())
	var zoom = cam[3].to_float()
	
	var opts = qtes[1].split(",")
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
		Cupri.say("You idiot.")
	else:
		Cupri.say("wow.... congrats on this simple question")
