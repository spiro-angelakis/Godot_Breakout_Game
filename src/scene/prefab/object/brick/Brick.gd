extends Area2D


var break_particles_prefab = preload("res://src/scene/prefab/particle/BrickParticles.tscn").duplicate()

onready var col = $CollisionShape2D
onready var sprite = $Sprite

onready var ball_sprite = $BallSprite
onready var speed_sprite = $SpeedSprite


var is_ball_brick = false
var is_speed_brick = false


func _ready():
	
	if round(rand_range(0,7)) == 1:
		is_ball_brick = true
		ball_sprite.visible = true
	elif round(rand_range(0,7)) == 1:
		is_speed_brick = true
		speed_sprite.visible = true


func break_brick():
	
	if is_ball_brick:
		Main.level.spawn_ball(position, false)
	
	if is_speed_brick:
		Main.extra_speed += 1
	
	var p = break_particles_prefab.instance().duplicate()
	p.color = sprite.modulate
	p.position = position
	
	Main.level.particles.add_child(p)
	
	Main.level.brick_broken()
	
	queue_free()
