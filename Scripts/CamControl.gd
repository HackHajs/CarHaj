extends Node3D

const SENS = .003
const SHAKE_DECAY = 3

signal clickedSteer

var shake_strength = 0
var active: bool = true
@onready var cam = $Camera3D
@onready var Ray = $Camera3D/RayCast3D
@onready var rng = RandomNumberGenerator.new()

@export var steerCollider: StaticBody3D
@export var steerHL: MeshInstance3D

func _ready():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and active:
		cam.rotation.x -= event.relative.y * SENS
		cam.rotation.x = clamp(cam.rotation.x, -PI/10, PI/40)
		cam.rotation.y -= event.relative.x * SENS
		cam.rotation.y = clamp(cam.rotation.y, -PI/12, PI/4)
		steerHL.visible = Ray.get_collider() == steerCollider and active
		
	elif event is InputEventMouseButton and active and event.pressed:
		if Ray.get_collider() == steerCollider:
			clickedSteer.emit()
		
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY * delta)
		cam.h_offset = rng.randf_range(-shake_strength, shake_strength)
		cam.v_offset = rng.randf_range(-shake_strength, shake_strength)

func lookat(pos, size):
	active = false
	var target = Vector3(0, 0, 0)
	target.y = atan2(pos.x, pos.z)
	target.y += PI if target.y < 0 else -PI
	target.x = atan2(pos.y, (pos.x**2 + pos.z**2)**.5)
	var fov = atan(.5*size/pos.length()) / PI * 180
	
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "rotation", target, .3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(cam, "fov", fov, .3).set_trans(Tween.TRANS_EXPO)
	await tween.finished

func returnControl():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "fov", 55, .3).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	active = true

func shake():
	shake_strength = 3.0
