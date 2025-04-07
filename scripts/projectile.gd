extends Area2D

var speed: float = 200.0

func ready():
	body_shape_entered.connect(_on_area_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	var delta_position: Vector2 = direction * speed * delta
	global_position += delta_position


func clear():
	queue_free()


func _on_area_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int):
	print(body)


func _on_area_entered2(area: Area2D):
	print(area)
