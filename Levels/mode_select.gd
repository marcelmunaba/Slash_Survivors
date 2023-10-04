extends Control

var id # 0 = main menu, 1 = endless, 2 = normal

func _ready():
	$bg.play("default")
	$desc.visible = false

func _process(_delta):
	if $endless.is_hovered():
		$desc.text = "Fight your way through endless waves of enemies and collect as much points as possible."
		$desc.visible = true
	elif $normal.is_hovered():
		$desc.text = "A hack and slash mode with objectives and expanding maps. Currently still in development."
		$desc.visible = true
	else:
		$desc.visible = false
		
func _on_button_pressed():
	id = 0
	$AudioStreamPlayer.play(0.1)
	$button_delay.start()
	
func _on_button_delay_timeout():
	match id:
		0:
			get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
		1: 
			get_tree().change_scene_to_file("res://Levels/loading_menu.tscn")
		2:
			pass	

func _on_endless_pressed():
	id = 1
	$AudioStreamPlayer.play(0.1)
	$button_delay.start()

func _on_normal_pressed():
	id = 2 
	$AudioStreamPlayer.play(0.1)
	$button_delay.start()
