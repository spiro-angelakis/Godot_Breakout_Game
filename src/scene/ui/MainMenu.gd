extends Control

onready var title_text_vpc = $TitleTextVPC

onready var menu_box = $CenterContainer
onready var tween = $Tween

onready var start_button = $CenterContainer/VBoxContainer/CenterContainer/StartButton


var started = false
var quitted = false

var paused = false

func _ready():
	if Main.os_platform == "HTML5":
		$CenterContainer/VBoxContainer/CenterContainer3.queue_free()
	
	tween_fadein()

func review():
	title_text_vpc.visible = true
	menu_box.visible = true
	start_button.grab_focus()



func _on_StartButton_pressed():
	if not started:
		started = true
		
		button_select()
		
		yield(get_tree().create_timer(0.01), "timeout")
		menu_box.queue_free()
		
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		tween_fadeout()


func _on_SettingsButton_pressed():
	if not paused:
		
		paused = true
		button_select()
		
		title_text_vpc.visible = false
		menu_box.visible = false
		
		Main.game.pause_game()
		paused = false
		


func _on_CloseButton_pressed():
	if not quitted:
		quitted = true
		
		menu_box.queue_free()
		
		button_select()
		yield(get_tree().create_timer(0.1), "timeout")
		
		tween_fadeout()


func tween_fadein():
	tween.interpolate_property(self, "modulate", Color(0.0,0.0,0.0,0.0), Color(1.0,1.0,1.0,1.0), 1.5)
	tween.start()

func tween_fadeout():
	tween.interpolate_property(self, "modulate", Color(1.0,1.0,1.0,1.0), Color(0.0,0.0,0.0,0.0), 1.5)
	tween.start()



func button_hover():
	Main.game.button_hover()

func button_select():
	Main.game.button_select()


func _on_Tween_tween_all_completed():
	if quitted:
		get_tree().quit()
		return
	
	if started:
		Main.game.start_game()
	else:
		menu_box.visible = true
		start_button.grab_focus()
