extends Node2D

const brick_offset = Vector2(65,34)
const initial_brick_pos = Vector2(-450,-250)

var brick_pos = Vector2(0,0)

onready var bricks_node = $Bricks

var brick_prefab = preload("res://Brick.tscn").duplicate()




# Called when the node enters the scene tree for the first time.
func _ready():
	build_bricks()


func build_bricks():
	brick_pos = initial_brick_pos
	for h in 15:
		for v in 7:
			var brick = brick_prefab.instance()
			brick.position = brick_pos
			bricks_node.add_child(brick)
			var clr = Color(0,0,0,1)
			match v:
				0:
					clr = Color(1,0,0,1)
				1:
					clr = Color(1,1,0,1)
				2:
					clr = Color(1,0,1,1)
				3:
					clr = Color(0,1,1,1)
				4:
					clr = Color(0,0,1,1)
				5:
					clr = Color(0,1,0,1)
				6:
					clr = Color(0.2,0.8,0.5,1)
			brick.get_child(1).modulate = clr
			brick_pos.y += brick_offset.y
		brick_pos.y = initial_brick_pos.y
		brick_pos.x += brick_offset.x
