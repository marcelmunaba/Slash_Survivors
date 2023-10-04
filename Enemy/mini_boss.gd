extends CharacterBody2D

var speed = 100
var BOSS_SPEED = 100
var health = 150
var player_chase = false
@onready var player = $"../Player"
var damage = 20
var dead = false
var direction #0 = side, 1 = back, 2 = front

func _ready():
	$health_bar.value = health
	
func _physics_process(_delta):
	if !player_chase and !dead:
		$AnimatedSprite2D.speed_scale = 1
		if $damage_rate.time_left > 0:
			$damage_rate.stop()
		position += ((player.position - position)/speed).normalized()
		if (player.position.x - position.x) < 0 and (absf(player.position.y - position.y) < 70):
			$AnimatedSprite2D.flip_h = false
			direction = 0
			$AnimatedSprite2D.play("walk_side")
		elif (player.position.x - position.x) >= 0 and (absf(player.position.y - position.y) < 70):
			$AnimatedSprite2D.flip_h = true
			direction = 0
			$AnimatedSprite2D.play("walk_side")
		elif (player.position.y - position.y) < 0:
			$AnimatedSprite2D.flip_h = false
			direction = 1
			$AnimatedSprite2D.play("walk_back")
		else:
			$AnimatedSprite2D.flip_h = false
			direction = 2
			$AnimatedSprite2D.play("walk_front")
	else:
		if $damage_rate.time_left == 0:
			$damage_rate.start()

func _process(_delta):
	if dead and $death_timer.time_left == 0:
		match direction:
			0:
				$AnimatedSprite2D.play("dead_side")
			1:
				$AnimatedSprite2D.play("dead_back")
			2:
				$AnimatedSprite2D.play("dead_front")
		$death_timer.start() 
		$attack_timer.stop()
		$damage_rate.stop()
		$CollisionShape2D.disabled = true
		speed = 0
	velocity = Vector2.ZERO
	velocity = velocity.normalized() * speed
	move_and_slide()
	
func take_damage(damage):
	health -= damage
	$health_bar.value = health
	if health <= 0:
		dead = true
	
func _on_attacking_area_body_entered(body):
	player = body
	$attack_timer.start()
	speed = 1

func _on_attacking_area_body_exited(body):
	player = body
	player_chase = false
	$attack_timer.stop()
	$damage_rate.stop()
	speed = BOSS_SPEED

func _on_attack_timer_timeout():
	player_chase = true

func _on_death_timer_timeout():
	Global.score += 50
	Global.energy += 10
	print(Global.score)
	queue_free()

func _on_damage_rate_timeout():
	if !dead:
		$AnimatedSprite2D.speed_scale = 0.7
		if (player.position.y - position.y > 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("attack_front")
		elif (player.position.y - position.y <= 0) and (absf(player.position.x - position.x) < 30):
			$AnimatedSprite2D.play("attack_back")
		elif (absf(player.position.x - position.x)) >= 30:
			$AnimatedSprite2D.play("attack_side")
		$AudioStreamPlayer2D.play()
		randomize()
		damage = randi_range(10, 30)
		player.take_damage(damage)
