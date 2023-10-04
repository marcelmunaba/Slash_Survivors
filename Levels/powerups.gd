extends Area2D

var id
var used = false
const damage = 20
const energy = 3 # *2 energy rate
const hp = 15
const speed = 100
#0 = damage, #1 = energy, #2 = hp, #3 = speed

func _ready():
	randomize()
	id = randi_range(0,3)
	if id == 0:
		$icon.play("damage")
	elif id == 1:
		$icon.play("energy")
	elif id == 2:
		$icon.play("hp")
	else:
		$icon.play("speed")

func _on_area_entered(area):
	if used == false:
		match id:
			0:
				Global.damage += damage
				print("STARTING DMG: " + str(Global.STARTING_DMG))
				print("DMG: " + str(Global.damage))
			1:
				if Global.energy >= Global.MAX_ENERGY:
					Global.energy = 100
				else:
					Global.rate = energy
			2:
				if Global.health >= Global.MAX_HEALTH or Global.health + hp >= Global.MAX_HEALTH:
					Global.health = 100
				else:
					Global.health += hp
			3:
				Global.speed += speed
				if Global.speed > Global.MAX_SPEED: #maximum speed
					Global.speed = Global.MAX_SPEED
		used = true
		print(Global.on_powerup)
		print(Global.damage)
		print(Global.speed)
		$CollisionShape2D.disabled = true
		$icon.visible = false
		if $buff_timer.time_left > 0:
			$buff_timer.stop()
			$buff_timer.start()
		else:
			$buff_timer.start()
	
func _on_buff_timer_timeout():
	match id:
		0:
			Global.damage = Global.STARTING_DMG
		1:
			Global.rate = 1
		3:
			Global.speed = Global.STARTING_SPD
	print(Global.on_powerup)
	queue_free()

