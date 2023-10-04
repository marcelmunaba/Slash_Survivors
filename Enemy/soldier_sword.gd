extends Area2D

var speed = 100
var direction = 0 # 0 = left, 1 = right
var target_position
var speed_tmp = speed
var damage = 2
@onready var player = $"../Player"
var dead = false
		
func _process(_delta):
	$hitbox.position = $CharacterBody2D.position
	move_animation()
	$CharacterBody2D.velocity = Vector2.ZERO
	target_position = (player.position - position).normalized()	
	$CharacterBody2D.velocity =  target_position * speed
	$"CharacterBody2D".move_and_slide()
	#print(position.distance_to(target_position))
	
func move_animation():
	if speed > 0:
		if $CharacterBody2D.velocity.x < 0:
			direction = 0
			$CharacterBody2D/AnimatedSprite2D.flip_h = false
		if $CharacterBody2D.velocity.x >= 0:
			direction = 1
			$CharacterBody2D/AnimatedSprite2D.flip_h = true
		$CharacterBody2D/AnimatedSprite2D.play("default")	
	
func take_damage():
	dead = true
	$CharacterBody2D/AnimatedSprite2D.stop()
	$CharacterBody2D/AnimatedSprite2D.play("dead")
	$CharacterBody2D/death_timer.start()
	$CharacterBody2D/skull.visible = true
	speed = 0
		
	
func _on_body_entered(body):
	if dead == false:
		print(body)
		speed = 0
		$CharacterBody2D.velocity = position.direction_to(target_position).normalized()
		print("oi")
		if target_position.x < position.x:
			$CharacterBody2D/AnimatedSprite2D.flip_h = false
		else:
			$CharacterBody2D/AnimatedSprite2D.flip_h = true
		$attack/attack_left.disabled = false
		$CharacterBody2D/AnimatedSprite2D.play("attack")
		body.take_damage(damage)
		print(get_overlapping_bodies())
		$attack_windup.start()

func _on_body_exited(body):
	if dead == false:
		speed = speed_tmp
		target_position = player.position.normalized()	
		$CharacterBody2D.velocity =  target_position * speed
		$attack/attack_left.disabled = true
		$CharacterBody2D/AnimatedSprite2D.play("default")
		print($attack/attack_left.disabled)
		
func _on_attack_windup_timeout():
	if !get_overlapping_bodies().is_empty() and !$CharacterBody2D/death_timer.time_left > 0:
		get_overlapping_bodies().front().take_damage(damage)		

func _on_death_timer_timeout():
	$CharacterBody2D/AnimatedSprite2D.stop()
	Global.score += 10
	print(Global.score)
	queue_free()# Replace with function body.
