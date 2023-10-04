extends CharacterBody2D

var speed = Global.speed
var attack_type = 0 #0 = slash
var direction = 0 #0 = side 1 = up 2 = down
				
func _process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		$"hero".flip_h = false
		$"swordd/sword".flip_h = false
		$"swordd/sword".flip_v = false
		if $swordd/hitbox_timer.time_left > 0:
			$"hero".play("attack_side_slash")
			if $"hero".flip_h == true:
				$"swordd/sword".flip_h = false
				$"swordd/sword".position = Vector2(-7, 3)
			else:
				$"swordd/sword".flip_h = true
				$"swordd/sword".position = Vector2(8, 3)
		else:
			$"swordd/sword".play("side")
			$"swordd/sword".position = Vector2(-50, 0)
		direction = 0
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		$"hero".flip_h = false
		$"swordd/sword".play("up")
		$"swordd/sword".flip_h = false
		$"swordd/sword".flip_v = false
		velocity.y -= 1
		direction = 1
		$"swordd/sword".position = Vector2(30, 10)
	if Input.is_action_pressed("ui_right"):
		$"hero".flip_h = true
		$"swordd/sword".flip_h = true
		$"swordd/sword".flip_v = false
		if $swordd/hitbox_timer.time_left > 0:
			$"hero".play("attack_side_slash")
			if $"hero".flip_h == true:
				$"swordd/sword".flip_h = false
				$"swordd/sword".position = Vector2(-7, 3)
			else:
				$"swordd/sword".flip_h = true
				$"swordd/sword".position = Vector2(8, 3)
		else:
			$"swordd/sword".play("side")
			$"swordd/sword".position = Vector2(59, 2)
		direction = 0
		velocity.x += 1
	if Input.is_action_pressed("ui_down"):
		$"hero".flip_h = false
		$"swordd/sword".play("up")
		$"swordd/sword".flip_h = false
		$"swordd/sword".flip_v = true
		velocity.y += 1
		direction = 2
		$"swordd/sword".position = Vector2(-29, 37)
	if Input.is_action_just_pressed("attack"):
		if $swordd/hitbox_timer.time_left > 0:
			$swordd/hitbox_timer.stop()
			attack_animation(attack_type)
		else:
			attack_animation(attack_type) #energy will be checked in the method
	
	if Global.no_energy:
		$no_energy_icon.visible = true
		Global.no_energy = false
	else:
		$no_energy_icon.visible = false
	
	if (Global.on_powerup and Global.speed > Global.STARTING_SPD and Global.damage > Global.STARTING_DMG):
		$hero.speed_scale = 3
		$powerup_icon.visible = true
		$powerup_icon/both.visible = true
	elif (Global.on_powerup and Global.powerupid() == 3) or Global.speed > Global.STARTING_SPD:
		$hero.speed_scale = 3
		$powerup_icon.visible = true
		$powerup_icon.play("speed")
	elif (Global.on_powerup and Global.powerupid() == 0):
		$hero.speed_scale = 1
		$powerup_icon.visible = true
		$powerup_icon.play("attack")
	else:
		$hero.speed_scale = 1
		$powerup_icon.visible = false
		$powerup_icon/both.visible = false

	checkDmgPowerup()
	
	velocity = velocity.normalized() * Global.speed			
	move_and_slide() #in godot 4 does not have arguments!
	move_animation(velocity)
	if Global.energy > 100: #avoid energy overload
		Global.energy = 100

func move_animation(velocity):
	if $swordd/hitbox_timer.is_stopped():
		if velocity.y == 0 and velocity.x == 0 and direction == 0:
			$"hero".play("idle_side")
		elif velocity.y == 0 and velocity.x == 0 and direction == 1:
			$"hero".play("idle_back")
		elif velocity.y == 0 and velocity.x == 0 and direction == 2:
			$"hero".play("idle_front")
		elif direction == 0:
			$"hero".play("walk_side")
		elif direction == 1:
			$"hero".play("walk_up")
		elif direction == 2: 
			$"hero".play("walk_down")
			
func attack_animation(type):
	if Global.energy_suff():
		if type == 0:
			#if Input.is_action_just_pressed("attack"):
			if type == 0:	
				if Input.is_action_just_pressed("mouse left click"):
					var mouse_pos = get_global_mouse_position()
					var distance = (mouse_pos - position).normalized()
					print(distance)
					if (distance.x >= 0.5 and (absf(distance.y)) <= 0.5): #mouse clicked on right
						direction = 0
						$"hero".flip_h = true
						$"swordd/sword".play("side")
						$"swordd/sword".position = Vector2(8, 3)
						$"swordd/sword".flip_h = true
						$"swordd/sword".flip_v = false
						
						$swordd/sword_hitbox_side_right.disabled = false
						$"swordd/sword".flip_h = false
						$"swordd/sword".position = Vector2(-7, 3)
					elif (distance.x < 0.5 and (absf(distance.y)) <= 0.5): #mouse clicked on left
						direction = 0
						$"hero".flip_h = false
						$"swordd/sword".play("side")
						$"swordd/sword".position = Vector2(-50, 0)
						$"swordd/sword".flip_h = false
						$"swordd/sword".flip_v = false
						
						$swordd/sword_hitbox_side_left.disabled = false
						$"swordd/sword".flip_h = true
						$"swordd/sword".position = Vector2(8, 3)
						$swordd/sword.z_index = 3
					elif 0.5 > distance.y and distance.y < 0: #mouse clicked on top
						direction = 1
						$"hero".flip_h = false
						$"swordd/sword".play("up")
						$"swordd/sword".flip_h = false
						$"swordd/sword".flip_v = false
						$"swordd/sword".position = Vector2(30, 10)
						
						$swordd/sword_hitbox_up.disabled = false
						$swordd/sword.z_index = 0
						$"hero".flip_h = false
						$"hero".play("attack_back_slash")
						$slash_sound.play()
						$"swordd/sword".position = Vector2(28, -2)
					elif distance.y >= 0: #mouse clicked on bottom
						direction = 2
						$"hero".flip_h = false
						$"swordd/sword".play("up")
						$"swordd/sword".flip_h = false
						$"swordd/sword".flip_v = true
						$"swordd/sword".position = Vector2(-29, 37)
						
						$swordd/sword_hitbox_down.disabled = false
						$"hero".flip_h = false
						$"hero".play("attack_front_slash")
						$slash_sound.play()
						$"swordd/sword".position = Vector2(-13, 37)

				if direction == 0 :
					$"hero".play("attack_side_slash")
					$slash_sound.play()
					if $"hero".flip_h == true:
						$swordd/sword_hitbox_side_right.disabled = false
						print("atk kanan dengan mouse?")
						$"swordd/sword".flip_h = false
						$"swordd/sword".position = Vector2(-7, 3)
					elif $"hero".flip_h == false:
						$swordd/sword_hitbox_side_left.disabled = false
						print("atk kiri dengan mouse?")
						$"swordd/sword".flip_h = true
						$"swordd/sword".position = Vector2(8, 3)
						$swordd/sword.z_index = 3

				elif direction == 1:
					$swordd/sword_hitbox_up.disabled = false
					$swordd/sword.z_index = 0
					$"hero".flip_h = false
					$"hero".play("attack_back_slash")
					$slash_sound.play()
					$"swordd/sword".position = Vector2(28, -2)
				else:
					$swordd/sword_hitbox_down.disabled = false
					$"hero".flip_h = false
					$"hero".play("attack_front_slash")
					$slash_sound.play()
					$"swordd/sword".position = Vector2(-13, 37)
				$swordd/hitbox_timer.start(0)									
				if Global.energy-5 >= 0:    
					Global.energy -= 5
				$swordd/sword.z_index = 0
	else:
		Global.no_energy = true #send signal to label
		$AudioStreamPlayer.play()							

func _on_energy_timer_timeout(): #energy regen. Add regen rate(?)
	Global.energy += 3*Global.rate

func _on_hitbox_timer_timeout():
	print("TIMEOUT")
	$"swordd/hit damage".text = ""
	$"swordd/hit damage".z_index = 0
	$swordd/sword_hitbox_side_left.disabled = true
	$swordd/sword_hitbox_side_right.disabled = true
	$swordd/sword_hitbox_up.disabled = true
	$swordd/sword_hitbox_down.disabled = true
	if direction == 0:
		if $"hero".flip_h == true:
			$"swordd/sword".position = Vector2(50, 0)
			$"swordd/sword".flip_h = true
			$"swordd/hit damage".position = Vector2(50, 0)
		else:
			$"swordd/sword".flip_h = false
			$"swordd/sword".position = Vector2(-50, 0)	
	elif direction == 1:
		$"swordd/sword".position = Vector2(30, 10)
	else:
		$"swordd/sword".position = Vector2(-26, 37)
	
func take_damage(damage):
	print("ouch")# Replace with function body.
	Global.health -= damage
	$ough.play(0.1)

func checkDmgPowerup():
	if Global.on_powerup and Global.powerupid() == 0:
		$swordd/sword_hitbox_side_left.set_scale(Vector2(3, 1.5))
		$swordd/sword_hitbox_side_right.set_scale(Vector2(3, 1.5))
		$swordd/sword_hitbox_up.set_scale(Vector2(2, 3))
		$swordd/sword_hitbox_down.set_scale(Vector2(2, 3))
	else:
		$swordd/sword_hitbox_side_left.set_scale(Vector2(1, 1))
		$swordd/sword_hitbox_side_right.set_scale(Vector2(1, 1))
		$swordd/sword_hitbox_up.set_scale(Vector2(1, 1))
		$swordd/sword_hitbox_down.set_scale(Vector2(1, 1))

func _on_swordd_body_entered(body):
	$"swordd/hit damage".text = str(Global.damage)
	#0 = side 1 = up 2 = down
	if direction == 1:
		$"swordd/hit damage".position = $swordd/sword_hitbox_up.position
	elif direction == 2:
		$"swordd/hit damage".position = $swordd/sword_hitbox_down.position
	else:
		if $hero.flip_h == true:
			$"swordd/hit damage".position = $swordd/sword_hitbox_side_right.position
		else:
			$"swordd/hit damage".position = $swordd/sword_hitbox_side_left.position
	$"swordd/hit damage".z_index = 5
	body.take_damage(Global.damage)
	if body.dead:
		$kill.play()
