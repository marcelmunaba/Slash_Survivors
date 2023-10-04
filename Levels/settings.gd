extends Control

var toggled1 #bgm
var toggled2 #sfx

func _ready():
	#setup active volumes for each buses
	$BGM/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$sfx/HSlider2.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx"))
	$master/HSlider3.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	#initialize toggled (on check buttons) variables for bgm,sfx,and master 
	toggled1 = !AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	$BGM/CheckButton.button_pressed = toggled1
	
	toggled2 = !AudioServer.is_bus_mute(AudioServer.get_bus_index("Sfx"))
	$sfx/CheckButton2.button_pressed = toggled2

	$bg.play("default")
	
func _process(_delta):
	$BGM/percentage.text = str(2.5* ($BGM/HSlider.value + 40)) + "%"
	
	if $full_screen.is_hovered():
		$full_screen/label.visible = true
	else:
		$full_screen/label.visible = false
		
	if toggled1:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $BGM/HSlider.value)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		
	$sfx/percentage2.text = str(2.5* ($sfx/HSlider2.value + 40)) + "%"
	if toggled2:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), $sfx/HSlider2.value)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), true)
	
	$master/percentage3.text = str(2.5* ($master/HSlider3.value + 40)) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $master/HSlider3.value)
	
func _on_button_pressed():
	$AudioStreamPlayer.play(0.1)
	$button_delay.start()
	
func _on_button_delay_timeout():
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")

func _on_check_button_toggled(button_pressed):
	if !button_pressed:
		toggled1 = false
	else:
		toggled1 = true


func _on_check_button_2_toggled(button_pressed):
	if !button_pressed:
		toggled2 = false
	else:
		toggled2 = true

func _on_full_screen_pressed():
	if DisplayServer.window_get_mode(0) == Window.MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif DisplayServer.window_get_mode(0) == Window.MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
