extends Node

@onready var line: Line2D = $Line2D
var start: Vector2
var end: Vector2
var just_spawned: bool = true

func _physics_process(_delta: float):
	line.points = [start, end]
	if !just_spawned:
		queue_free()
	just_spawned = false
