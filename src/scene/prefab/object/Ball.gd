extends Area2D

class_name Ball

var break_particles_prefab = preload("res://src/scene/prefab/particle/BallParticles.tscn").duplicate()

onready var death_sfx = $BallDeathAudio
onready var wall_sfx = $WallBallAudio

onready var sprite = $Sprite
onready var col = $CollisionShape2D



export var speed = 200


var current_direction = Vector2(0,0)


var do_start_wait = true

var stopped = true

var dead = false



func _ready():
	
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
		var real_speed = speed + (Main.speed * 50)
		
		var velocity = current_direction * real_speed
		
		position += velocity * delta
		#print(current_direction)


func bounce(other_object):
	#print("bounce")
	
	var col_dir = position.direction_to(other_object.position)
	col_dir = Vector2(clamp(col_dir.x,-1,1),clamp(col_dir.y,-1,1))
	col_dir = -col_dir
	
	if position.y > 235:
		if col_dir.y > 0:
			col_dir.y = -col_dir.y
	
	if other_object.is_in_group("Top"):
		col_dir = Vector2(0,1)
		wall_sfx.play()
	if other_object.is_in_group("Left"):
		col_dir = Vector2(1,0)
		wall_sfx.play()
	if other_object.is_in_group("Right"):
		col_dir = Vector2(-1,0)
		wall_sfx.play()
	
	#if other_object.is_in_group("Bar"):
	
	var randomize_bounce = true
	
	if other_object is Paddle:
		
		randomize_bounce = false
		
		col_dir = Vector2(0,-1)
		
		col_dir.x = clamp((other_object.position.x - position.x) / 100, -0.95, 0.95)
		col_dir.x = -col_dir.x
		
		print_debug(str("PADDLE HIT || " + "Ball Pos: " + str(position) + ", Paddle Pos: " + str(other_object.position) + ", Bounce Dir : " + str(col_dir)))
		
		other_object.bounced()
	
	if randomize_bounce:
		if col_dir.x == 0:
			col_dir.x = rand_range(-1,1)
		if col_dir.y == 0:
			col_dir.y = rand_range(-1,1)
	
	
	current_direction = col_dir
	


func break_ball(is_death=true):
	
	if is_death:
		death_sfx.play()
	
	
	
	
	var p = break_particles_prefab.instance().duplicate()
	p.color = sprite.modulate
	p.position = position
	
	Main.level.particles.add_child(p)
	
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	if not is_death:
		Main.level.ball_broken_by_command()
	
#	if dead:
#		get_tree().quit()
#	else:
	queue_free()

func ball_death():
	stop()
	
	if Main.level.balls.get_child_count() == 1:
		dead = true
	
	break_ball()


func _on_Ball_body_entered(body):
	bounce(body)


func _on_Ball_body_exited(body):
	pass # Replace with function body.


func _on_Ball_area_entered(area):
	if not area.is_in_group("Boom"):
		bounce(area)
		if area.is_in_group("Brick"):
		#if area is Brick:
			area.break_brick()
		if area.is_in_group("Bottom"):
			visible = false
			col.disabled = true
			ball_death()



