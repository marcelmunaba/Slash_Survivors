extends Control

var id
func _ready():
	$bg.play("default")
	
func _on_button_pressed():
	$button_click.play(0.1)
	$"button delay".start()
	id = 0 	

func _on_button_2_pressed():
	$button_click.play(0.1)
	$"button delay".start()
	id = 1	

func _on_button_3_pressed():
	$button_click.play(0.1)
	$"button delay".start()
	id = 2	

func _on_settings_pressed():
	$button_click.play(0.1)
	$"button delay".start()
	id = 3 	
	
func _on_button_delay_timeout():
	if id == 0:
		get_tree().change_scene_to_file("res://Levels/mode_select.tscn")
	elif id == 1:
		get_tree().change_scene_to_file("res://Levels/credits.tscn")
	elif id == 2: 
		get_tree().quit()
	elif id == 3:
		get_tree().change_scene_to_file("res://Levels/settings.tscn")
