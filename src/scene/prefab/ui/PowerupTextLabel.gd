extends RichTextLabel

enum POWERUP_TYPES {BALL, SPEED, PADDLE, BOOM}

var powerup_type = POWERUP_TYPES.BALL

onready var tween = $Tween
onready var timer = $Timer



func _ready():
	var powerup_string = powerup_type_to_string()
	bbcode_text = str("   " + powerup_string + " !")
	timer.start()


func powerup_type_to_string():
	var powerup_string = "POWERUP"
	match powerup_type:
		POWERUP_TYPES.BALL:
			powerup_string = "EXTRA BALL"
		POWERUP_TYPES.SPEED:
			powerup_string = "FASTER PADDLE"
		POWERUP_TYPES.PADDLE:
			powerup_string = "LONGER PADDLE"
		POWERUP_TYPES.BOOM:
			powerup_string = "BOOM"
	
	return powerup_string


func _on_Timer_timeout():
	tween.interpolate_property(self, "modulate", Color(1.0,1.0,1.0,1.0), Color(0.0,0.0,0.0,0.0), 2.5)
	tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
