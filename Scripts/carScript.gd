extends RigidBody3D
class_name Car

func _process(delta):
	var inp = Input.get_axis("back", "forward")
	apply_force(Vector3.FORWARD * 100 * inp, Vector3.ZERO)
