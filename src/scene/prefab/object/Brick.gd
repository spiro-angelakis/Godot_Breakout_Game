extends Area2D

class_name Brick


var break_particles_prefab = preload("res://src/scene/prefab/particle/BrickParticles.tscn").duplicate()

var explosion_prefab = preload("res://src/scene/prefab/effect/Explosion.tscn").duplicate()

onready var col = $CollisionShape2D
onready var sprite = $Sprite

onready var ball_sprite = $BallSprite
onready var speed_sprite = $SpeedSprite
onready var paddle_sprite = $PaddleSprite
onready var bomb_sprite = $BombSprite



var is_ball_brick = false
var is_speed_brick = false
var is_paddle_brick = false
var is_bomb_brick = false

var broken = false


func _ready():
	
	if round(rand_range(0,7 + round(Main.level_number / 2))) == 1:
		is_ball_brick = true
		ball_sprite.visible = true
	elif round(rand_range(0,7 + round(Main.level_number / 2))) == 1:
		is_speed_brick = true
		speed_sprite.visible = true
	elif round(rand_range(0,7 + round(Main.level_number / 2))) == 1:
		is_paddle_brick = true
		paddle_sprite.visible = true
	elif round(rand_range(1,14 + round(Main.level_number / 2))) == 1:
		is_bomb_brick = true
		bomb_sprite.visible = true


func break_brick():
	
	if broken:
		return
	
	broken = true
	
	visible = false
	col.disabled = true
	
	if is_ball_brick:
		Main.level.spawn_ball(position, false)
	
	if is_speed_brick:
		Main.extra_speed += 1
		Main.level.speed_powerup()
	
	if is_paddle_brick:
		Main.level.upgrade_paddle()
	
	if is_bomb_brick:
		var explosion = explosion_prefab.instance()
		explosion.position = position
		Main.level.particles.add_child(explosion)
	
	var p = break_particles_prefab.instance().duplicate()
	p.color = sprite.modulate
	p.position = position
	
	Main.level.particles.add_child(p)
	
	#Main.level.brick_broken()
	#yield(get_tree().create_timer(0.01), "timeout")
	
	queue_free()
