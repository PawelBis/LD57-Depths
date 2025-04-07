@tool
class_name Ground
extends Node

@onready var ground: CanvasItem = $Texture

func update_dig_positions(digg_positions: PackedVector2Array):
	ground.material.set_shader_parameter("digg_rect", digg_positions)
