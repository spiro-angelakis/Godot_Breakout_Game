extends Node

class_name Game


var main_menu_prefab = preload("res://src/scene/ui/MainMenu.tscn").duplicate()

var level_test_prefab = preload("res://src/scene/level/BreakoutTest.tscn").duplicate()


onready var game_app = $GameApp

onready var pause_menu = $PauseMenu

onready var hover = $ButtonHover
onready var select = $ButtonSelect


func _ready():
	Main.game = self
	yield(get_tree().create_timer(0.01), "timeout")
	
	enter_main_menu()
	




func _process(_delta):
	if Input.is_action_just_pressed("p"):
		take_screenshot()


func take_screenshot():
	var img = get_viewport().get_texture().get_data()
	#var mainVP = get_parent().get_parent()
	var screenshotNum = 1
	var dir = Directory.new()
	
	if !dir.dir_exists("user://screenshots/"):
		dir.make_dir("user://screenshots/")
	
	while dir.file_exists(str("user://screenshots/screenshot" + str(screenshotNum) + ".png")):
		screenshotNum += 1
	img.flip_y()
	img.save_png(str("user://screenshots/screenshot" + str(screenshotNum) + ".png"))
	print("Screenshot saved.")



func enter_main_menu():
	var main_menu = main_menu_prefab.instance()
	
	Main.main_menu = main_menu
	
	game_app.add_child(main_menu)


func return_to_main_menu():
	unpause_game()
	
	if Main.main_menu == null:
		if Main.level != null:
			Main.level.queue_free()
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		enter_main_menu()
	else:
		Main.main_menu.review()


func start_game():
	
	if Main.main_menu != null:
		Main.main_menu.queue_free()
	
	var level_test = level_test_prefab.instance()
	game_app.add_child(level_test)



func button_hover():
	hover.play()

func button_select():
	select.play()


func pause_game():
	pause_menu.viewed()
	get_tree().paused = true

func unpause_game():
	pause_menu.visible = false
	get_tree().paused = false
