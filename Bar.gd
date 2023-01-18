extends KinematicBody2D


export var speed = 20

var limit_right = false
var limit_left = false


func _physics_process(delta):
	
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed("ui_left"):
		if !limit_left:
			direction.x = -1
	if Input.is_action_pressed("ui_right"):
		if !limit_right:
			direction.x = 1
	
	
	var velocity = direction * speed
	
	
	move_and_slide(velocity, Vector2.UP)


func _on_RightArea_body_entered(body):
	if body == self:
		limit_right = true


func _on_LeftArea_body_entered(body):
	if body == self:
		limit_left = true


func _on_RightArea_body_exited(body):
	limit_right = false


func _on_LeftArea_body_exited(body):
	limit_left = false
