extends Node
var lifetime: float = 0.07

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
