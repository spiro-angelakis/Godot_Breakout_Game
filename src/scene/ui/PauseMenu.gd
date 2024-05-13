extends Control

onready var resume_button = $CenterContainer/PauseOptionsVBox/CenterContainer2/ResumeButton
onready var fullscreen_button = $CenterContainer/PauseOptionsVBox/FullscreenHBox/FullscreenButton
onready var volume_slider = $CenterContainer/PauseOptionsVBox/SoundVolumeHBox/VolumeSlider
onready var return_to_menu_button = $CenterContainer/PauseOptionsVBox/CenterContainer/ReturnToMenuButton

func viewed():
	visible = true
	resume_button.grab_focus()


func button_hover():
	Main.game.button_hover()

func button_select():
	Main.game.button_select()



func _on_FullscreenButton_pressed():
	button_select()
	if Main.fullscreen:
		fullscreen_button.text = "Windowed"
		Main.fullscreen = false
		OS.window_fullscreen = false
	else:
		fullscreen_button.text = "Fullscreen"
		Main.fullscreen = true
		OS.window_fullscreen = true


func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	button_select()


func _on_ReturnToMenuButton_pressed():
	button_select()
	Main.game.return_to_main_menu()


func _on_ResumeButton_pressed():
	button_select()
	Main.game.unpause_game()
