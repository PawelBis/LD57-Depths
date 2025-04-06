extends Sprite2D

# Top left position of digging area
var dig_start_position: Vector2
# Current position of the digger (bottom right)
var dig_end_position: Vector2
# Digging velocity of the digger in m/s
@export var digging_velocity: float
@export var ground: Ground
@export var shake_angle: float
@export var shake_time_interval_min: float
@export var shake_time_interval_max: float

@onready var shake_timer: Timer = $ShakeTimer


func calculate_dig_left_edge() -> Vector2:
	var local_rect = get_rect()
	var current_position = self.to_global(local_rect.position)
	current_position.y += local_rect.size.y * 0.5
	return current_position


func _ready():
	var local_rect = get_rect()
	var current_position = calculate_dig_left_edge()
	dig_start_position = current_position


func shake():
	var shake_alpha = randf()
	var shake_dir = randf()
	if shake_dir < 0.5:
		shake_dir = 1.0
	else:
		shake_dir = -1.0
	var shake_offset = shake_angle * shake_dir * shake_alpha
	rotation_degrees = shake_offset


func _process(delta: float):
	if ground == null:
		return
	var offset = digging_velocity * delta
	position += Vector2.DOWN * offset
	var dig_position: PackedVector2Array
	dig_position.append(dig_start_position)
	
	var left_edge = calculate_dig_left_edge()
	var roffset = Vector2(get_rect().size.x, 0) * scale
	var right_edge = left_edge + roffset
	dig_position.append(right_edge)
	ground.update_dig_positions(dig_position)


func _on_shake_timer_timeout():
	shake()
	var ntime = randf_range(shake_time_interval_min, shake_time_interval_max)
	shake_timer.start(ntime)
