extends CharacterBody2D

var speed = 150
var player_chase = false
@onready var player = $"../Player"
var damage = 5
var dead = false

func _physics_process(delta):
	if dead:
		$CollisionShape2D.disabled = true
		if (player.position.y - position.y > 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("dead_front")
		elif (player.position.y - position.y <= 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("dead_back")
		elif (absf(player.position.x - position.x)) >= 30:
			$AnimatedSprite2D.play("dead_side")
	elif !player_chase:
		position += ((player.position - position)/speed).normalized()
		if (player.position.x - position.x) < 0 and (absf(player.position.y - position.y) < 70):
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_side")
		elif (player.position.x - position.x) >= 0 and (absf(player.position.y - position.y) < 70):
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_side")
		elif (player.position.y - position.y) < 0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_back")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_front")
	else:
		if (player.position.y - position.y > 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("attack_front")
		elif (player.position.y - position.y <= 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("attack_back")
		elif (absf(player.position.x - position.x)) >= 30:
			$AnimatedSprite2D.play("attack_side")

		if $damage_rate.time_left == 0:
			$damage_rate.start()
			
func _process(delta):
	velocity = Vector2.ZERO
	velocity = velocity.normalized() * speed
	move_and_slide()
	
func take_damage(damage):
	$death_timer.start()
	dead = true
	$damage_rate.stop()
	speed = 0


func _on_attacking_range_body_entered(body):
	player = body
	$attack_timer.start()

func _on_death_timer_timeout():
	$AnimatedSprite2D.stop()
	$damage_rate.stop()
	$attack_timer.stop()
	Global.score += 10
	Global.energy += 2
	print(Global.score)
	queue_free()# Replace with function body.


func _on_damage_rate_timeout():
	#TODO : spawn the arrow.....
	pass # Replace with function body.

func _on_attack_timer_timeout():
	player_chase = true

func _on_attacking_range_body_exited(body):
	player = body
	player_chase = false
	$attack_timer.stop()
	$damage_rate.stop()
