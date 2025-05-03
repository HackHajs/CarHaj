extends Node3D

const sens = .003

var active: bool = true
@onready var cam = $Camera3D

func _ready():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and active:
		cam.rotation.x -= event.relative.y * sens
		cam.rotation.x = clamp(cam.rotation.x, -PI/4, PI/4)
		cam.rotation.y -= event.relative.x * sens
		
	#temp
	elif event is InputEventMouseButton and event.pressed:
		if active: lookat(Vector3(.125, 0, -1), .5)
		else: returnControl()
	#temp

func lookat(pos, size):
	active = false
	var target = Vector3(0, 0, 0)
	target.y = PI - atan2(pos.x, pos.z)
	target.x = atan2(pos.y, (pos.x**2 + pos.z**2)**.5)
	var fov = atan(.5*size/pos.length()) / PI * 180
	
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "rotation", target, .3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(cam, "fov", fov, .3).set_trans(Tween.TRANS_EXPO)
	await tween.finished

func returnControl():
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "fov", 75, .3).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	active = true
