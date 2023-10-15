extends Control

var is_pressed = false

func _process(delta):
	if is_pressed:
		Input.action_press("attack")
		is_pressed = false
		
func _on_tip_pressed():
	is_pressed = true
