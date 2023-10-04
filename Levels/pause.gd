extends Button

func _process(delta):
	if get_tree().paused == true:
		if Input.is_action_pressed("pause.unpause"):
			button_pressed = true
