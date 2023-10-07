extends Node

var health = 100
const MAX_HEALTH = 100
var energy = 100
const MAX_ENERGY = 100
var rate = 1 #energy rate
var damage = 15
var STARTING_DMG = 15
var speed = 150
var STARTING_SPD = 150
var MAX_SPEED = 500
var no_energy = false
var on_powerup = false
var score = 0
var touch_mode = false

func getAudio():
	return $AudioStreamPlayer
	
func reset():
	STARTING_SPD = 150
	STARTING_DMG = 15
	health = MAX_HEALTH
	energy = MAX_ENERGY
	damage = STARTING_DMG
	speed = STARTING_SPD
	score = 0
	no_energy = false
	on_powerup = false
	
func _process(_delta):
	energy_check()
	if damage > STARTING_DMG or speed > STARTING_SPD:
		Global.on_powerup = true
	else:
		Global.on_powerup = false

func energy_check():
	if energy < 5:
		no_energy = true
	else:
		no_energy = false
		
func energy_suff():
	return energy >= 5

func powerupid():
	if damage > STARTING_DMG and speed > STARTING_SPD:
		return 99
	elif damage > STARTING_DMG:
		return 0
	elif speed > STARTING_SPD:
		return 3
	
func restartMusic():
	$AudioStreamPlayer.play(0)

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play(0) # Replace with function body.

