extends Control

func _ready() -> void:
	modulate.a = 0
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)
	await tween.finished
