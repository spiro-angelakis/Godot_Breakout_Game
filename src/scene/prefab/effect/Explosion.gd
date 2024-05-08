extends Node2D


onready var smoke_particles = $SmokeParticles
onready var fire_particles = $FireParticles



# Called when the node enters the scene tree for the first time.
func _ready():
	Main.level.bomb_powerup()
	fire_particles.emitting = true
	yield(get_tree().create_timer(0.025),"timeout")
	smoke_particles.emitting = true

func _on_BoomArea2D_body_entered(body):
	pass # Replace with function body.


func _on_BoomArea2D_area_entered(area):
	#if area is Brick:
	if area.is_in_group("Brick"):
		area.break_brick()


func _on_Timer_timeout():
	queue_free()
