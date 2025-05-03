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

func lookat(pos):
	active = false
	var target = Vector3(0, 0, 0)
	target.y = atan(pos.x / pos.z) if pos.z != 0 else sign(pos.x) * -PI/2
	if pos.z > 0: target.y += PI 
	target.x = atan(pos.y / (pos.x**2 + pos.z**2)**.5) if pos.x != 0 and pos.z != 0 else sign(pos.y) * PI/2
	
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "rotation", target, .3).set_trans(Tween.TRANS_SINE)
	await tween.finished
