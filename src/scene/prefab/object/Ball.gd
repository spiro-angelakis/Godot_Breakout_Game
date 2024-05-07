extends Area2D

var break_particles_prefab = preload("res://src/scene/prefab/particle/BallParticles.tscn").duplicate()

onready var death_sfx = $BallDeathAudio
onready var wall_sfx = $WallBallAudio

onready var sprite = $Sprite



export var speed = 200


var current_direction = Vector2(0,0)


var do_start_wait = true

var stopped = true

var dead = false



func _ready():
	
	Main.balls.append(self)
	
	if do_start_wait:
		yield(get_tree().create_timer(1.0),"timeout")
	
	stopped = false
	current_direction = Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))
	while current_direction == Vector2(0,0):
		current_direction = Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))


func stop():
	stopped = true

func go():
	stopped = false


func _physics_process(delta):
	
	if not stopped:
		var real_speed = speed + (Main.speed * 100)
		
		var velocity = current_direction * real_speed
		
		position += velocity * delta
		#print(current_direction)


func bounce(other_object):
	#print("bounce")
	
	var col_dir = position.direction_to(other_object.position)
	col_dir = Vector2(clamp(col_dir.x,-1,1),clamp(col_dir.y,-1,1))
	col_dir = -col_dir
	
	if other_object.is_in_group("Top"):
		col_dir = Vector2(0,1)
		wall_sfx.play()
	if other_object.is_in_group("Left"):
		col_dir = Vector2(1,0)
		wall_sfx.play()
	if other_object.is_in_group("Right"):
		col_dir = Vector2(-1,0)
		wall_sfx.play()
	
	if other_object.is_in_group("Bar"):
		col_dir = Vector2(0,-1)
		other_object.bounced()
	
	if col_dir.x == 0:
		col_dir.x = rand_range(-1,1)
	if col_dir.y == 0:
		col_dir.y = rand_range(-1,1)
	current_direction = col_dir
	


func break_ball():
	death_sfx.play()
	visible = false
	
	var p = break_particles_prefab.instance().duplicate()
	p.color = sprite.modulate
	p.position = position
	
	Main.level.particles.add_child(p)
	
	if Main.balls.has(self):
		Main.balls.remove(Main.balls.find(self))
	
	
	yield(get_tree().create_timer(1.0), "timeout")
	if dead:
		get_tree().quit()
	else:
		queue_free()

func ball_death():
	stop()
	
	if Main.balls.size() == 1:
		dead = true
	
	break_ball()


func _on_Ball_body_entered(body):
	bounce(body)


func _on_Ball_body_exited(body):
	pass # Replace with function body.


func _on_Ball_area_entered(area):
	bounce(area)
	if area.is_in_group("Brick"):
		area.break_brick()
	if area.is_in_group("Bottom"):
		ball_death()



