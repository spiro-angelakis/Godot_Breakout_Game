extends Control


func viewed():
	visible = true
	$CenterContainer/PauseOptionsVBox/CenterContainer2/ResumeButton.grab_focus()


func button_hover():
	Main.game.button_hover()

func button_select():
	Main.game.button_select()



func _on_FullscreenButton_pressed():
	button_select()
	if Main.fullscreen:
		Main.fullscreen = false
		OS.window_fullscreen = false
	else:
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
