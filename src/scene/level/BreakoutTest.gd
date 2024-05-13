extends Node2D

class_name Level

signal bricks_built
signal balls_removed


var brick_prefab = preload("res://src/scene/prefab/object/Brick.tscn").duplicate()


var ball_prefab = preload("res://src/scene/prefab/object/Ball.tscn").duplicate()


var powerup_label_prefab = preload("res://src/scene/prefab/ui/PowerupTextLabel.tscn").duplicate()



onready var bricks = $Bricks
onready var balls = $Balls
onready var particles = $Particles


onready var bar = $Bar



onready var level_label = $CanvasLayer/CenterContainer/LevelLabel
onready var level_text_tween = $LevelTextTween

onready var powerup_label_v_box = $CanvasLayer/PowerupMenu/PowerupLabelVBox



onready var ball_powerup_sfx = $PowerupSFX/BallPowerupSFX
onready var paddle_powerup_sfx = $PowerupSFX/PaddlePowerupSFX
onready var speed_powerup_sfx = $PowerupSFX/SpeedPowerupSFX



const brick_offset = Vector2(43,22)
const initial_brick_pos = Vector2(-450,-250)

const initial_paddle_pos = Vector2(-1, 255)
const initial_ball_pos = Vector2(-1, 170)

var brick_pos = Vector2(0,0)

var level_active = false
var level_finished = false

var game_over = false



func _process(delta):
	if level_active:
		if not game_over:
			
			if bricks.get_child_count() == 0:
				end_level()
				return
			
			if balls.get_child_count() == 0:
				if bricks.get_child_count() != 0:
					do_game_over()


func do_game_over():
	if not game_over:
		game_over = true
		
		Main.level_number = 1
		Main.speed = 1
		
		level_text_tween.stop_all()
		level_label.bbcode_text = str("[center]GAME OVER![/center]")
		level_label.modulate = Color(1.0,0.0,0.0,1.0)
		yield(get_tree().create_timer(0.5), "timeout")
		level_text_tween.interpolate_property(level_label, "modulate", Color(1.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,0.0), 2.0)
		level_text_tween.start()
		
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().reload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Main.level = self
	
	start_level()

func start_level():
	
	randomize()
	
	Main.extra_speed = 1
	Main.paddle_size = 1
	
	resize_paddle()
	bar.position = initial_paddle_pos
	
	level_text_tween.stop_all()
	level_label.bbcode_text = str("[center]Level   " + str(Main.level_number) + "[/center]")
	level_label.modulate = Color(1.0,1.0,1.0,1.0)
	yield(get_tree().create_timer(0.5), "timeout")
	level_text_tween.interpolate_property(level_label, "modulate", Color(1.0,1.0,1.0,1.0), Color(1.0,1.0,1.0,0.0), 2.0)
	level_text_tween.start()
	
	
	build_bricks()
	
	yield(self, "bricks_built")
	spawn_ball()
	
	level_active = true
	level_finished = false


func build_bricks():
	brick_pos = initial_brick_pos
	
	var rows = 22
	var columns = 14
	
	var lvl = Main.level_number
	if lvl == 1:
		rows = 7
		brick_pos.x = initial_brick_pos.x / 4
		columns = 4
	if lvl == 2:
		rows = 11
		brick_pos.x = initial_brick_pos.x / 2
		columns = 5
	if lvl == 3:
		columns = 7
	if lvl == 4:
		columns = 10
	
	var is_even_level = false
	var is_a_fifths_level = false
	var is_a_tens_level = false
	
	var do_bars_horizontal = false
	var do_bars_vertical = false
	var do_cutout_middle = false
	var do_cutout_sides = false
	
	if lvl % 2 == 0:
		is_even_level = true
	
	if lvl % 10 == 0:
		is_a_tens_level = true
	else:
		if lvl % 5 == 0:
			is_a_fifths_level = true
	
	
	if is_even_level:
		if round(rand_range(0,2)) == 1:
			do_bars_vertical = true
		if round(rand_range(0,2)) == 1:
			do_bars_horizontal = true
	
	if is_a_tens_level:
		if round(rand_range(0,2)) == 1:
			do_cutout_middle = true
	
	if is_a_fifths_level:
		if round(rand_range(0,2)) == 1:
			do_cutout_sides = true
	
	var left_side_pos = Vector2(round(rand_range(-500, -255)), round(rand_range(-300, 100)))
	var right_side_pos = Vector2(round(rand_range(500, 255)), round(rand_range(-300, 100)))
	
	var middle_pos = Vector2(round(rand_range(-500, 500)), round(rand_range(-300, 100)))
	
	var circle_size1 = round(rand_range(100, round(255)))
	var circle_size2 = round(rand_range(100, round(255)))
	
	do_cutout_sides = true
	
	if do_cutout_sides:
		circle_size1 = round(circle_size1 / rand_range(1.5,2))
		circle_size2 = round(circle_size2 / rand_range(1.5,2))
	
	for h in rows:
		
		var can_do_row = true
		
		if can_do_row:
			for v in columns:
				
				var did_brick = false
				
				var can_do_column = true
				
				if do_bars_horizontal:
					if v > 0:
						if v % 2 == 0:
							can_do_column = false
				else:
					if do_bars_vertical:
						can_do_column = false
						if h % 2 == 0:
							can_do_column = true
						
				
				if can_do_column:
					
					var can_do_brick = true
					
					if do_cutout_middle:
						if brick_pos.distance_to(middle_pos) < circle_size1:
							can_do_brick = false
					elif do_cutout_sides:
						if brick_pos.distance_to(left_side_pos) < circle_size1:
							can_do_brick = false
						if brick_pos.distance_to(right_side_pos) < circle_size2:
							can_do_brick = false
					
					if can_do_brick:
						var brick = brick_prefab.instance()
						brick.position = brick_pos
						bricks.add_child(brick)
						
						did_brick = true
						
						var clr = Color(0,0,0,1)
						match v:
							0:
								clr = Color(1,1,1,1)
							1:
								clr = Color(1,0.0,1,1)
							2:
								clr = Color(0,0,1,1)
							3:
								clr = Color(0,1,1,1)
							4:
								clr = Color(0,1,0,1)
							5:
								clr = Color(1,1,0,1)
							6:
								clr = Color(1,0.0,0.0,1)
						
						brick.get_child(1).modulate = clr
						
						
						var brick_out = false
						if brick.position.x > 490 or brick.position.x < -490:
							brick_out = true
						
						if brick.position.y > 280 or brick.position.y < -280:
							brick_out = true
						
						if brick_out:
							brick.queue_free()
						
				brick_pos.y += brick_offset.y
				
				if did_brick:
					yield(get_tree().create_timer(0.0001), "timeout")
		
		brick_pos.y = initial_brick_pos.y
		brick_pos.x += brick_offset.x
	
	emit_signal("bricks_built")


func spawn_ball(where=null, do_wait=true):
	
	if do_wait == false:
		ball_powerup()
	
	if where == null:
		where = initial_ball_pos
	
	var ball = ball_prefab.instance()
	ball.position = where
	ball.do_start_wait = do_wait
	balls.add_child(ball)



#func brick_broken():
#	yield(get_tree().create_timer(0.1), "timeout")
#	if bricks.get_child_count() == 0:
#		end_level()


func end_level():
	level_active = false
	get_tree().call_group("Ball", "stop")
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	for ball in balls.get_children():
		if ball != null and is_instance_valid(ball):
			ball.break_ball(false)
			yield(get_tree().create_timer(0.1), "timeout")



func ball_broken_by_command():
	yield(get_tree().create_timer(0.25), "timeout")
	
	
	if balls.get_child_count() == 0:
		
		if not level_finished:
			level_finished = true
			Main.speed += 0.1
			if Main.speed >= 10:
				Main.speed == 10
			Main.level_number += 1
			start_level()



func upgrade_paddle():
	paddle_powerup()
	Main.paddle_size += 0.1
	resize_paddle()

func resize_paddle():
	bar.scale = Vector2(Main.paddle_size, 1)


func ball_powerup():
	ball_powerup_sfx.play()
	var l = powerup_label_prefab.instance()
	l.powerup_type = l.POWERUP_TYPES.BALL
	powerup_label_v_box.add_child(l)

func paddle_powerup():
	paddle_powerup_sfx.play()
	var l = powerup_label_prefab.instance()
	l.powerup_type = l.POWERUP_TYPES.PADDLE
	powerup_label_v_box.add_child(l)

func speed_powerup():
	speed_powerup_sfx.play()
	var l = powerup_label_prefab.instance()
	l.powerup_type = l.POWERUP_TYPES.SPEED
	powerup_label_v_box.add_child(l)

func bomb_powerup():
	var l = powerup_label_prefab.instance()
	l.powerup_type = l.POWERUP_TYPES.BOOM
	powerup_label_v_box.add_child(l)



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






func _on_LeftTouch_pressed():
	bar.screen_left = true


func _on_RightTouch_pressed():
	bar.screen_right = true


func _on_LeftTouch_released():
	bar.screen_left = false


func _on_RightTouch_released():
	bar.screen_right = false
