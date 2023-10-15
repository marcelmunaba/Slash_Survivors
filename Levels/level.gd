extends Node

const ENEMY = preload("res://Enemy/enemy1.tscn")
const MINI_BOSS = preload("res://Enemy/mini_boss.tscn")
const PWRUP = preload("res://Levels/powerups.tscn")
const JOYSTICK = preload("res://joystick/virtual_joystick.tscn")
const ATT_JOYSTICK = preload("res://joystick/attack_joystick.tscn")
var diff = -1 #difficulty levels : 0,1,2
var touch = Global.touch_mode#Global.touch_mode #true = touch input mode is on

func _ready():
	$CanvasLayer/pause_menu/enable_touch/Touch.button_pressed = touch
	$game_loaded.play()
	$ysort/campfire.play()
	$ysort/campfire2.play()
	$ysort/flags/flag0.playAn(1)
	$ysort/flags/flag1.playAn(2)
	$ysort/flags/flag2.playAn(3)
	$ysort/flags/flag3.playAn(4)
	$CanvasLayer/pause_menu/volume.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$CanvasLayer/pause_menu/volume2.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx"))
	$CanvasLayer/pause_menu/volume3.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	
func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $CanvasLayer/pause_menu/volume.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), $CanvasLayer/pause_menu/volume2.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $CanvasLayer/pause_menu/volume3.value)
	$CanvasLayer/score_texture/score.text = ": " + str(Global.score)
	$CanvasLayer/health_bar/Label.text = str(Global.health) + "%"
	$CanvasLayer/energy_bar/Label2.text = str(Global.energy) + "%"
	if Input.is_action_just_pressed("pause.unpause"):
		_on_pause_pressed()
		$CanvasLayer/pause/delay.start()
	$CanvasLayer/energy_bar.value = Global.energy
	$CanvasLayer/health_bar.value = Global.health
	if Global.health <= 0:
		get_tree().change_scene_to_file("res://Levels/game_over.tscn")
	if Global.on_powerup:
			if Global.powerupid() == 0:
				$CanvasLayer/poweruplabel1.text = "DAMAGE UP!"
				$CanvasLayer/poweruplabel2.text = ""
			elif Global.powerupid() == 3:
				$CanvasLayer/poweruplabel1.text = ""
				$CanvasLayer/poweruplabel2.text = "SPEED UP!"
			elif Global.powerupid() == 99:
				$CanvasLayer/poweruplabel1.text = "DAMAGE UP!"
				$CanvasLayer/poweruplabel2.text = "SPEED UP!"			
	else:
			$CanvasLayer/poweruplabel1.text = ""
			$CanvasLayer/poweruplabel2.text = ""
	difficulty()

func createJoystick():
	for x in InputMap.action_get_events("attack"):
		if x is InputEventMouseButton: 
			InputMap.action_erase_event("attack", x)
	var joystick = JOYSTICK.instantiate()
	$CanvasLayer.add_child(joystick)
	var children = $CanvasLayer.get_children()
	var index = children.size()-1
	$CanvasLayer.move_child($CanvasLayer.get_child(index), 0)
	
	var attack_joy = ATT_JOYSTICK.instantiate()
	$CanvasLayer.add_child(attack_joy)
	children = $CanvasLayer.get_children()
	index = children.size()-1
	$CanvasLayer.move_child($CanvasLayer.get_child(index), 0)  		

func removeJoystick():
	$CanvasLayer.get_child(0).visible = false
	$CanvasLayer.get_child(0).queue_free()
	$CanvasLayer.get_child(1).visible = false
	$CanvasLayer.get_child(1).queue_free()
	var a = InputEventMouseButton.new()
	a.button_index = 1
	InputMap.action_add_event("attack",	a)
	
	
func _on_enemy_spawn_1_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_enemy_spawn_2_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D2.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_enemy_spawn_3_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D3.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_enemy_spawn_4_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D4.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_enemy_spawn_5_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D5.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_enemy_spawn_6_timeout():
	var enemy = ENEMY.instantiate()
	enemy.position = $StartPositions/Marker2D6.position
	enemy.y_sort_enabled = true
	$ysort.add_child(enemy)

func _on_mini_boss_spawn_timeout():
	var miniboss = MINI_BOSS.instantiate()
	miniboss.position = $StartPositions/Marker2D2.position
	miniboss.y_sort_enabled = true
	$ysort.add_child(miniboss)

func _on_mini_boss_spawn_2_timeout():
	var miniboss = MINI_BOSS.instantiate()
	miniboss.position = $StartPositions/Marker2D4.position
	miniboss.y_sort_enabled = true
	$ysort.add_child(miniboss)

func _on_mini_boss_spawn_3_timeout():
	var miniboss = MINI_BOSS.instantiate()
	miniboss.position = $StartPositions/Marker2D6.position
	miniboss.y_sort_enabled = true
	$ysort.add_child(miniboss)
	
func _on_powerup_timer_timeout():
	randomize()
	var pwrup = PWRUP.instantiate()
	var index = randi_range(1,3)
	var startpos = "powerup_locations/powerup_loc_" + str(index)
	print(pwrup)
	print(startpos)
	pwrup.position = get_node(startpos).position
	$ysort.add_child(pwrup)
	print($ysort/Player.position)
	print(pwrup.position)

func _on_pause_pressed():
	$CanvasLayer/pause_menu/resume_button.disabled = false
	$CanvasLayer/pause_menu.show()
	$CanvasLayer/pause.hide()
	get_tree().paused = true
	
func _on_resume_button_pressed():
	$CanvasLayer/pause_menu/resume_button.disabled = true
	$CanvasLayer/pause_menu.hide()
	$CanvasLayer/pause.show()
	get_tree().paused = false

func _on_quit_button_pressed():
	Global.restartMusic()
	Global.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")

func difficulty():
	if Global.score >= 150 and Global.score < 300 and diff == -1:
		$enemy_spawn_1.wait_time = 8
		$enemy_spawn_2.wait_time = 8
		$enemy_spawn_3.wait_time = 8
		$mini_boss_spawn.wait_time = 45
		$enemy_spawn_4.start()
		diff = 0
		$CanvasLayer/level_announce.text = "DIFFICULTY+"
		$CanvasLayer/level_announce.visible = true
		$CanvasLayer/announce_timer.start()
		$CanvasLayer/level_announce.add_theme_color_override("font_color", Color(0.278, 0.765, 0.655))
				
	elif Global.score >= 250 and Global.score < 500 and diff == 0:
		$enemy_spawn_1.wait_time = 6
		$enemy_spawn_2.wait_time = 6
		$enemy_spawn_3.wait_time = 6
		$mini_boss_spawn.wait_time = 40
		Global.STARTING_DMG = 20
		Global.damage = Global.STARTING_DMG
		$enemy_spawn_5.start()
		$enemy_spawn_4.wait_time = 8
		diff = 1
		$CanvasLayer/level_announce.text = "DIFFICULTY++\nBASE DAMAGE+"
		$CanvasLayer/level_announce.visible = true
		$CanvasLayer/announce_timer.start()
		$CanvasLayer/level_announce.add_theme_color_override("font_color", Color(0.11, 0.577, 0.729))
		
	elif Global.score >= 400 and diff == 1:
		$enemy_spawn_1.wait_time = 6
		$enemy_spawn_2.wait_time = 6
		$enemy_spawn_3.wait_time = 6
		$mini_boss_spawn.wait_time = 20
		Global.STARTING_DMG = 30
		Global.damage = Global.STARTING_DMG
		$enemy_spawn_6.start()
		$enemy_spawn_4.wait_time = 6
		$enemy_spawn_5.wait_time = 8
		$mini_boss_spawn2.start()
		diff = 2
		$CanvasLayer/level_announce.text = "DIFFICULTY+++\nBASE DAMAGE++"
		$CanvasLayer/level_announce.visible = true
		$CanvasLayer/announce_timer.start()
		$CanvasLayer/level_announce.add_theme_color_override("font_color", Color(0.824, 0.367, 0.219))
		
	elif Global.score >= 700 and diff == 2:
		$enemy_spawn_1.wait_time = 4
		$enemy_spawn_2.wait_time = 4
		$enemy_spawn_3.wait_time = 4
		$mini_boss_spawn.wait_time = 20
		$mini_boss_spawn2.wait_time = 30
		Global.STARTING_DMG = 40
		Global.damage = Global.STARTING_DMG
		$enemy_spawn_4.wait_time = 6
		$enemy_spawn_5.wait_time = 6
		$enemy_spawn_6.wait_time = 8
		$mini_boss_spawn3.start()
		diff = 3
		$CanvasLayer/level_announce.text = "DIFFICULTY++++\nBASE DAMAGE+++"
		$CanvasLayer/level_announce.visible = true
		$CanvasLayer/announce_timer.start()
		$CanvasLayer/level_announce.add_theme_color_override("font_color", Color(0.796, 0.213, 0.118))
		
func _on_announce_timer_timeout():
	$CanvasLayer/level_announce.visible = false

func _on_touch_toggled(button_pressed):
	if button_pressed:
		createJoystick()
	else:
		print("remove oi")
		removeJoystick()
