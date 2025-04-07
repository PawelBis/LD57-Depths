class_name Player
extends CharacterBody2D

@export var falling_speed: float = 2000.0
@export var run_speed: float = 150.0
@export var jump_velocity: float = 700.0
@export var recoil: float = 3

@onready var body_animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var weapon_animated_sprite: AnimatedSprite2D = $Weapon
@onready var muzzle: Node2D = $Weapon/Muzzle
@onready var muzzle_ray: RayCast2D = $Weapon/Muzzle/MuzzleRay
@onready var flip_muzzle_ray: RayCast2D = $Weapon/FlipMuzzle/MuzzleRay
@onready var flip_muzzle: Node2D = $Weapon/FlipMuzzle
var gravity: float
var t_since_shot: float = 0.0
var shot_delay: float = 0.2

var shoot_ray_scene= preload("res://scenes/shoot_ray.tscn")
var gun_explosion = preload("res://scenes/gun_explosion.tscn")

# Animation names
const ANIMATION_IDLE = "idle"
const ANIMATION_RUN = "run"
const ANIMATION_JUMP = "jump"
const ANIMATION_FALL = "fall"
const ANIMATION_LAND = "land"

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func set_flip_h(flip: bool):
	body_animated_sprite.flip_h = flip
	weapon_animated_sprite.flip_h = flip


func get_ray_node() -> RayCast2D:
	if weapon_animated_sprite.flip_h:
		return flip_muzzle_ray
	else:
		return muzzle_ray


func get_muzzle() -> Node2D:
	if weapon_animated_sprite.flip_h:
		return flip_muzzle
	else:
		return muzzle


func set_animation(animation_name: String):
	body_animated_sprite.play(animation_name)
	weapon_animated_sprite.play(animation_name)


func spawn_projectile():
	var root = get_tree().root
	var spawn_node = get_muzzle()
	var ray = get_ray_node()
	ray.rotation_degrees = (randf() * recoil) - (recoil / 2)
	ray.force_raycast_update()
	var explosion = gun_explosion.instantiate()
	spawn_node.add_child(explosion)
	explosion.global_position = spawn_node.global_position
	explosion.global_rotation = spawn_node.global_rotation
	var collision_point = ray.get_collision_point()
	if !ray.is_colliding():
		collision_point = ray.target_position.rotated(ray.global_rotation)
		collision_point += global_position
	var shoot_ray = shoot_ray_scene.instantiate()
	root.add_child(shoot_ray)
	shoot_ray.start = spawn_node.global_position
	shoot_ray.end = collision_point



func get_move_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("shoot") && t_since_shot > shot_delay:
		t_since_shot = 0.0
		spawn_projectile()

	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y -= jump_velocity

	if direction.x != 0.0:
		set_flip_h(direction.x < 0.0)

	return direction


func update_animation():
	if is_on_floor():
		if velocity.x == 0:
			set_animation(ANIMATION_IDLE)
		else:
			set_animation(ANIMATION_RUN)
	else:
		if velocity.y < 0:
			set_animation(ANIMATION_JUMP)
		else:
			set_animation(ANIMATION_FALL)


func aim_weapon():
	var mouse_position = get_global_mouse_position()
	# Adjust aim direction if weapon is flipped
	# otherwise we are pointing with the butt of the gun
	if weapon_animated_sprite.flip_h:
		var to_player = global_position - mouse_position
		mouse_position += to_player * 2.0
	weapon_animated_sprite.look_at(mouse_position)


func _physics_process(delta: float) -> void:
	var direction = get_move_direction()
	velocity.x = direction.x * run_speed
	velocity += Vector2.DOWN * 2500 * delta
	t_since_shot += delta
	move_and_slide()
	update_animation()
	aim_weapon()
