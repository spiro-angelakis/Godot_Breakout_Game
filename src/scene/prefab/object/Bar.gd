extends KinematicBody2D

class_name Paddle


export var speed = 100

var limit_right = false
var limit_left = false

onready var ball_paddle_sfx = $BallPaddleAudio
onready var anim = $AnimationPlayer


var last_mouse_pos = Vector2.ZERO

var direction = Vector2.ZERO

var screen_left = false
var screen_right = false


func _physics_process(delta):
	
	if screen_left:
		if !limit_left:
			direction.x = -1
	
	if screen_right:
		if !limit_right:
			direction.x = 1
	
#	if Input.is_action_pressed("ui_left"):
#		if !limit_left:
#			direction.x = -1
#	if Input.is_action_pressed("ui_right"):
#		if !limit_right:
#			direction.x = 1
	
	
	var real_speed = speed + (Main.speed * 100) + (Main.extra_speed * 25)
	
	var velocity = direction * real_speed
	
	
	move_and_slide(velocity, Vector2.UP)


func _input(event):
	var moving = false
#	if event is InputEventAction:
#		if event.pressed:
#			if event.get_action() == "ui_left":
#				if !limit_left:
#					direction.x = -1
#					moving = true
#			elif event.get_action() == "ui_right":
#				if !limit_right:
#					direction.x = 1
#					moving = true
	
	var pressed_menu = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		pressed_menu = true
	
	if Input.is_action_just_released("ui_accept"):
		pressed_menu = true
	
	if pressed_menu:
		if Main.level != null and is_instance_valid(Main.level):
			if not Main.level.game_over:
				Main.game.pause_game()
				return
	
	
	if Input.is_action_pressed("ui_left"):
		if !limit_left:
			direction.x = -1
			moving = true
	
	if Input.is_action_pressed("ui_right"):
		if !limit_right:
			direction.x = 1
			moving = true
	
#
	if not moving:
		direction = Vector2.ZERO



func bounced():
	anim.play("bounce")
	ball_paddle_sfx.play()






func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "bounce":
		anim.play("idle")
