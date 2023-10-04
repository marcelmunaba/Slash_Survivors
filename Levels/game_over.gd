extends Control

func _ready():
	$Label.text = "Score : " + str(Global.score)
	Global.get_child(0).stop()

func _on_exit_pressed():
	Global.health = Global.MAX_HEALTH
	Global.energy = Global.MAX_ENERGY
	Global.get_child(0).play(0)
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
