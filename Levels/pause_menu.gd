extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _process(_delta):
	if $"../..".get_tree().paused == true and $"../pause/delay".time_left == 0 and Input.is_action_just_pressed("pause.unpause"):
		$"../.."._on_resume_button_pressed()

