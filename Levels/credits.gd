extends Control

func _ready():
	$bg.play("default")
			
func _on_button_pressed():
	$AudioStreamPlayer.play(0.1)
	$button_delay.start()
	
func _on_button_delay_timeout():
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
