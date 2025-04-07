extends RigidBody2D

@export var velocity: float = 250.0
@onready var drill_collision: Area2D = $Drill/DrillCollision
var stuck = false


func _ready():
	drill_collision.body_entered.connect(on_body_entered)


func _physics_process(delta: float):
	if stuck:
		freeze = true
		return

	var diff = (delta * velocity) * Vector2.RIGHT
	move_and_collide(diff)


func on_body_entered(body: Node):
	if body.is_in_group("wall"):
		stuck = true
