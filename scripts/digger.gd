extends RigidBody2D

# Top left position of digging area
var dig_start_position: Vector2
var width: float
# Digging velocity of the digger in m/s
@export var digging_velocity: float
@export var ground: Ground
@export var shake_angle: float

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var dig_area: Sprite2D = $DigArea


func get_rect() -> Rect2:
	var rect = dig_area.get_rect()
	rect.size *= dig_area.global_scale
	return rect


func calculate_dig_left_edge() -> Vector2:
	var local_rect = get_rect()
	var current_position = self.global_position
	current_position.x -= local_rect.size.x * 0.5
	# current_position.y += local_rect.size.y * 0.5
	return current_position


func _ready():
	var current_position = calculate_dig_left_edge()
	width = get_rect().size.x
	dig_start_position = current_position
	player.play("drill")


func shake():
	var shake_alpha = randf()
	var shake_dir = randf()
	if shake_dir < 0.5:
		shake_dir = 1.0
	else:
		shake_dir = -1.0
	var shake_offset = shake_angle * shake_dir * shake_alpha
	rotation_degrees = shake_offset


func _physics_process(delta: float):
	if ground == null:
		return
	var delta_move = digging_velocity * delta
	move_and_collide(Vector2(0, delta_move))
	var dig_position: PackedVector2Array
	dig_position.append(dig_start_position)

	var left_edge = calculate_dig_left_edge()
	var roffset = Vector2(width, 0)
	var right_edge = left_edge + roffset
	dig_position.append(right_edge)
	ground.update_dig_positions(dig_position)
