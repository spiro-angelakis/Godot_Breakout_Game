extends Node


var game:Game = null
var level:Level = null

var main_menu = null


var fullscreen = false



var level_number = 1


var speed = 1
var extra_speed = 0

var paddle_size = 1


var os_platform = "None"


func _ready():
	os_platform = OS.get_name()

