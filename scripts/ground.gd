@tool
class_name Ground
extends Node

@onready var polygon: Polygon2D = $Polygon
@export var width: float = 1000.0 :
	set(value):
		width = value
		if not is_node_ready():
			await ready
		polygon.polygon[0].x = -width / 2.0
		polygon.polygon[3].x = -width / 2.0
		polygon.polygon[1].x = width / 2.0
		polygon.polygon[2].x = width / 2.0


func update_dig_positions(digg_positions: PackedVector2Array):
	polygon.material.set_shader_parameter("digg_rect", digg_positions)
