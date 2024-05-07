extends KinematicBody2D


export var speed = 50

var limit_right = false
var limit_left = false


onready var anim = $AnimationPlayer


func _physics_process(delta):
	
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed("ui_left"):
		if !limit_left:
			direction.x = -1
	if Input.is_action_pressed("ui_right"):
		if !limit_right:
			direction.x = 1
	
	
	var real_speed = speed + (Main.speed * 10) + (Main.extra_speed * 20)
	
	var velocity = direction * real_speed
	
	
	move_and_slide(velocity, Vector2.UP)



func bounced():
	anim.play("bounce")






func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "bounce":
		anim.play("idle")
