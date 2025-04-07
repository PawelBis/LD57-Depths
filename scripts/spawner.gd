extends Area2D

@export var scene_to_spawn: PackedScene
@export var spawn_delay: float = 2.0
@onready var collider = $Collider
var spawn_locations: Array[Node2D]
var triggered = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	for ch in get_children():
		if ch is Node2D && ch != collider:
			spawn_locations.append(ch)


func _on_body_entered(_body: Node2D):
	if triggered:
		return
	triggered = true
	for node in spawn_locations:
		var spawn_position = node.global_position
		var spawn_rotation = node.global_rotation
		var spawn_scale = node.global_scale
		var mob = scene_to_spawn.instantiate()
		get_tree().root.add_child(mob)
		mob.global_position = spawn_position
		mob.global_rotation = spawn_rotation
		mob.global_scale = spawn_scale
		await get_tree().create_timer(spawn_delay).timeout
