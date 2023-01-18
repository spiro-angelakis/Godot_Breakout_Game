extends Area2D

var break_prefab = preload("res://BrickParticles.tscn").duplicate()
export var speed = 300

var current_direction = Vector2(0,0)


func _ready():
	randomize()
	yield(get_tree().create_timer(1.0),"timeout")
	current_direction = Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))
	while current_direction == Vector2(0,0):
		current_direction = Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))


func _physics_process(delta):
	var velocity = current_direction * speed
	
	position += velocity * delta
	#print(current_direction)


func bounce(other_object):
	print("bounce")
	var col_dir = position.direction_to(other_object.position)
	col_dir = Vector2(clamp(col_dir.x,-1,1),clamp(col_dir.y,-1,1))
	col_dir = -col_dir
	if other_object.is_in_group("Top"):
		col_dir = Vector2(0,1)
	if other_object.is_in_group("Left"):
		col_dir = Vector2(1,0)
	if other_object.is_in_group("Right"):
		col_dir = Vector2(-1,0)
	if other_object.is_in_group("Bar"):
		col_dir = Vector2(0,-1)
	if col_dir.x == 0:
		col_dir.x = round(rand_range(-1,1))
	if col_dir.y == 0:
		col_dir.y = round(rand_range(-1,1))
	current_direction = col_dir
	


func _on_Ball_body_entered(body):
	bounce(body)


func _on_Ball_body_exited(body):
	pass # Replace with function body.


func _on_Ball_area_entered(area):
	bounce(area)
	if area.is_in_group("Brick"):
		var break_p = break_prefab.instance().duplicate()
		break_p.color = area.get_child(1).modulate
		break_p.position = area.position
		get_parent().add_child(break_p)
		break_p.emitting = true
		area.queue_free()
	if area.is_in_group("Bottom"):
		get_tree().quit()
