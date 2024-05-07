extends Node2D

signal bricks_built

var brick_prefab = preload("res://src/scene/prefab/object/brick/Brick.tscn").duplicate()


var ball_prefab = preload("res://src/scene/prefab/object/Ball.tscn").duplicate()



onready var bricks = $Bricks
onready var balls = $Balls
onready var particles = $Particles

onready var level_label = $CanvasLayer/CenterContainer/LevelLabel
onready var level_text_tween = $LevelTextTween



const brick_offset = Vector2(43,22)
const initial_brick_pos = Vector2(-450,-250)

var brick_pos = Vector2(0,0)



# Called when the node enters the scene tree for the first time.
func _ready():
	
	Main.level = self
	
	start_level()

func start_level():
	
	Main.extra_speed = 1
	
	level_text_tween.stop_all()
	level_label.bbcode_text = str("[center]Level   " + str(Main.speed) + "[/center]")
	level_label.modulate = Color(1.0,1.0,1.0,1.0)
	yield(get_tree().create_timer(0.5), "timeout")
	level_text_tween.interpolate_property(level_label, "modulate", Color(1.0,1.0,1.0,1.0), Color(1.0,1.0,1.0,0.0), 2.0)
	level_text_tween.start()
	
	
	build_bricks()
	
	yield(self, "bricks_built")
	spawn_ball()


func build_bricks():
	brick_pos = initial_brick_pos
	
	var rows = 22
	var columns = 14
	
	var lvl = Main.speed
	if lvl == 1:
		rows = round(rows / 4)
		brick_pos.x = brick_pos.x / 4
		columns = 4
	if lvl == 2:
		rows = round(rows / 2)
		brick_pos.x = brick_pos.x / 2
		columns = 5
	if lvl == 3:
		columns = 7
	if lvl == 4:
		columns = 10
	
	for h in rows:
		for v in columns:
			
			var brick = brick_prefab.instance()
			brick.position = brick_pos
			bricks.add_child(brick)
			
			var clr = Color(0,0,0,1)
			match v:
				0:
					clr = Color(1,1,1,1)
				1:
					clr = Color(0.95,0.1,0.75,1)
				2:
					clr = Color(0,0,1,1)
				3:
					clr = Color(0,1,0.5,1)
				4:
					clr = Color(0,1,0,1)
				5:
					clr = Color(0.5,1,0,1)
				6:
					clr = Color(1,0.0,0.0,1)
			
			brick.get_child(1).modulate = clr
			brick_pos.y += brick_offset.y
			
			yield(get_tree().create_timer(0.01), "timeout")
		
		brick_pos.y = initial_brick_pos.y
		brick_pos.x += brick_offset.x
	
	emit_signal("bricks_built")


func spawn_ball(where=Vector2.ZERO, do_wait=true):
	var ball = ball_prefab.instance()
	ball.position = where
	ball.do_start_wait = do_wait
	balls.add_child(ball)



func brick_broken():
	if bricks.get_child_count() == 0:
		get_tree().call_group("Ball", "stop")
		
		for ball in Main.balls:
			ball.break_ball()
			yield(get_tree().create_timer(0.1), "timeout")
		
		Main.speed += 1
		start_level()



func _on_RightArea_body_entered(body):
	if body.is_in_group("Bar"):
		body.limit_right = true

func _on_LeftArea_body_entered(body):
	if body.is_in_group("Bar"):
		body.limit_left = true


func _on_RightArea_body_exited(body):
	if body.is_in_group("Bar"):
		body.limit_right = false

func _on_LeftArea_body_exited(body):
	if body.is_in_group("Bar"):
		body.limit_left = false




